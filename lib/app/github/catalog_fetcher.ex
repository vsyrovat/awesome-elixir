defmodule App.Github.CatalogFetcher do
  use Tesla
  require Logger

  @readme_url "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"

  @spec fetch_readme :: {:ok, String.t()} | {:error, Tesla.Env.t()}
  def fetch_readme do
    {:ok, response} = get(@readme_url)

    case response do
      %Tesla.Env{status: 200, body: body} ->
        Logger.info("Fetched " <> @readme_url)
        {:ok, body}

      _ ->
        Logger.warn("Error fetch " <> @readme_url)
        {:error, response}
    end
  end
end
