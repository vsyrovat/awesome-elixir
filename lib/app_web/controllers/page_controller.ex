defmodule AppWeb.PageController do
  use AppWeb, :controller

  import AppWeb.PageControllerHelper

  alias App.AwesomeProvider

  def index(conn, params) do
    categories =
      AwesomeProvider.categories()
      |> Enum.map(&transform_category/1)
      |> filter_by_stars(params["min_stars"])
      |> filter_by_libraries_presence()

    render(conn, "index.html", %{categories: categories})
  end
end
