defmodule App.AwesomeProvider do
  alias App.LocalCopy

  def categories do
    categories = LocalCopy.list_categories()

    categories
    |> Enum.map(fn c ->
      Map.merge(c, %{
        repositories:
          Enum.map(%{}, fn r ->
            Map.merge(r, %{pushed_at: :unknown, stars: :unknown})
          end)
      })
    end)
  end
end
