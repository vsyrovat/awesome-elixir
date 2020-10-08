defmodule App.Github.RepositoryFetcher do
  use TypedStruct
  use Tesla
  require Logger

  plug Tesla.Middleware.FollowRedirects, max_redirects: 1
  plug Tesla.Middleware.BaseUrl, "https://api.github.com"
  plug Tesla.Middleware.Headers, headers()
  plug Tesla.Middleware.JSON

  defmodule Repo do
    typedstruct enforce: true do
      field :stars, integer()
      field :pushed_at, DateTime.t()
    end
  end

  defmodule Limit do
    typedstruct enforce: true do
      field :limit, integer()
      field :remain, integer()
      field :reset_at, integer()
    end
  end

  defp headers do
    default = [{"User-Agent", "Tesla"}]

    case token = Application.get_env(:app, :github_api_token) do
      nil -> default
      _ -> default ++ [{"Authorization", "token #{token}"}]
    end
  end

  @spec fetch(String.t()) ::
          {:ok, Repo.t(), Limit.t()}
          | {:error, :repo_private}
          | {:error, :limit_exceeded, Limit.t()}
          | {:error, :forbidden}
          | {:error, Tesla.Env.t()}
  def fetch(repo) when is_binary(repo) do
    unless String.match?(repo, ~r|[^/]+/[^/]+|),
      do: raise(ArgumentError, message: "Argument should match the pattern \"{user}/{repo}\"")

    {:ok, github_response} = get("/repos/#{repo}")

    case github_response do
      %Tesla.Env{status: 200} ->
        Logger.info("Repo #{repo} fetched")
        {:ok, repo(github_response), limit(github_response)}

      %Tesla.Env{status: 404} ->
        Logger.warn("Repo #{repo} is private or not exists")
        {:error, :repo_private}

      %Tesla.Env{status: 403} ->
        case l = limit(github_response) do
          %Limit{remain: 0} ->
            Logger.warn("Limit reached, #{inspect(l)}")
            {:error, :limit_exceeded, l}

          _ ->
            Logger.warn("Repo #{repo} forbidden")
            {:error, :forbidden}
        end

      _ ->
        Logger.error("Unknown error while fetch #{repo}")
        {:error, github_response}
    end
  end

  defp repo(%Tesla.Env{status: 200, body: body}) do
    {:ok, pushed_at, _} = DateTime.from_iso8601(body["pushed_at"])
    %Repo{stars: body["stargazers_count"], pushed_at: pushed_at}
  end

  defp limit(%Tesla.Env{headers: headers}) do
    headers = Enum.into(headers, %{})

    {limit, ""} = Integer.parse(headers["x-ratelimit-limit"])
    {remain, ""} = Integer.parse(headers["x-ratelimit-remaining"])
    {reset_at_unix, ""} = Integer.parse(headers["x-ratelimit-reset"])
    reset_at = DateTime.from_unix!(reset_at_unix)
    %Limit{limit: limit, remain: remain, reset_at: reset_at}
  end
end
