defmodule AppWeb.PageController do
  use AppWeb, :controller

  alias App.AwesomeProvider
  alias NaiveDateTime, as: NDT

  defp transform_repository(%{} = r) do
    r
    |> Map.merge(%{updated_ago_days: div(NDT.diff(NDT.utc_now(), r.pushed_at, :second), 86400)})
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
    |> Enum.filter(fn c -> Enum.count(c.libraries) > 0 end)
  end

  defp filter_by_stars(categories, _), do: categories

  def index(conn, params) do
    categories =
      AwesomeProvider.categories()
      |> Enum.map(&transform_category/1)
      |> filter_by_stars(params["min_stars"])

    render(conn, "index.html", %{categories: categories})
  end
end
