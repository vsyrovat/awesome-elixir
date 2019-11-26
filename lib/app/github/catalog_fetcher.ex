defmodule App.Github.CatalogFetcher do
  use Tesla

  @readme_url "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"

  @spec fetch_readme :: {:ok, String.t()} | {:error, Tesla.Env.t()}
  def fetch_readme do
    {:ok, response} = get(@readme_url)

    case response do
      %Tesla.Env{status: 200, body: body} -> {:ok, body}
      _ -> {:error, response}
    end
  end
end
