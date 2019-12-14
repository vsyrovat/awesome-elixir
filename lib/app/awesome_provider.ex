defmodule App.AwesomeProvider do
  alias App.LocalCopy

  def categories do
    categories = LocalCopy.list_categories()
    repositories = LocalCopy.list_repositories()

    categories
    |> Enum.map(fn c ->
      %{c | repositories: intersect_repositories(c.repositories, repositories)}
    end)
  end

  defp intersect_repositories(aliases, all_repositories) do
    all_repositories
    |> Enum.filter(fn r -> r.alias in aliases end)
  end
end
