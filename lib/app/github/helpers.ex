defmodule App.Github.Helpers do
  @spec short_name(String.t() | nil) :: {:ok, String.t()} | {:error}
  def short_name(repo_url) when is_binary(repo_url) do
    case Regex.run(~r{^https?://(?:www\.)?github.com/([^/]+/[^/]+)/?$}, repo_url) do
      [^repo_url, repo_name] -> {:ok, repo_name}
      _ -> {:error}
    end
  end

  def short_name(nil), do: {:error}
end
