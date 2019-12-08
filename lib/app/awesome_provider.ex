defmodule App.AwesomeProvider do
  alias App.Github.CatalogFetcher
  alias App.Github.CatalogParser

  def categories do
    {:ok, readme_md} = CatalogFetcher.fetch_readme()
    categories = CatalogParser.parse(readme_md)

    categories
    |> Enum.map(fn c ->
      Map.merge(c, %{
        repositories:
          Enum.map(c.repositories, fn r ->
            Map.merge(r, %{pushed_at: :unknown, stars: :unknown})
          end)
      })
    end)
  end
end
