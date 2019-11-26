defmodule App.Github.CatalogFetcherTest do
  use ExUnit.Case
  import Tesla.Mock
  alias App.Github.CatalogFetcher

  test "retrieve readme" do
    mock(fn
      %{
        method: :get,
        url: "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"
      } ->
        %Tesla.Env{status: 200, body: "Hello"}
    end)

    assert CatalogFetcher.fetch_readme() == {:ok, "Hello"}
  end

  test "error retrieve readme" do
    response = %Tesla.Env{status: 500}
    mock(fn %{method: :get, url: _} -> response end)

    assert CatalogFetcher.fetch_readme() == {:error, response}
  end
end
