defmodule AppWeb.PageController do
  use AppWeb, :controller

  alias App.AwesomeProvider

  defp pushed_at_to_updated_ago_days(:unknown), do: :unknown
  defp pushed_at_to_updated_ago_days(nil), do: :unknown

  defp pushed_at_to_updated_ago_days(%NaiveDateTime{} = pushed_at),
    do: div(NaiveDateTime.diff(NaiveDateTime.utc_now(), pushed_at, :second), 86400)

  defp transform_repository(%{} = r) do
    r
    |> Map.merge(%{updated_ago_days: pushed_at_to_updated_ago_days(r.pushed_at)})
  end

  defp transform_category(%{} = c) do
    c
    |> Map.merge(%{libraries: Enum.map(c.repositories, &transform_repository/1)})
  end

  defp filter_by_stars(categories, min_stars) when is_binary(min_stars) do
    case Integer.parse(min_stars) do
      {int, ""} -> filter_by_stars(categories, int)
      _ -> categories
    end
  end

  defp filter_by_stars(categories, min_stars) when is_integer(min_stars) and min_stars > 0 do
    categories
    |> Enum.map(fn c ->
      %{c | libraries: Enum.filter(c.libraries, fn r -> r.stars >= min_stars end)}
    end)
  end

  defp filter_by_stars(categories, _), do: categories

  defp filter_by_libraries_presence(categories) do
    categories |> Enum.filter(fn c -> Enum.count(c.libraries) > 0 end)
  end

  def index(conn, params) do
    categories =
      AwesomeProvider.categories()
      |> Enum.map(&transform_category/1)
      |> filter_by_stars(params["min_stars"])
      |> filter_by_libraries_presence()

    render(conn, "index.html", %{categories: categories})
  end
end
