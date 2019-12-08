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

  def index(conn, _params) do
    categories = AwesomeProvider.categories() |> Enum.map(&transform_category/1)
    render(conn, "index.html", %{categories: categories})
  end
end
