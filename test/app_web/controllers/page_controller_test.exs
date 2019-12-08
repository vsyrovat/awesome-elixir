defmodule AppWeb.PageControllerTest do
  use AppWeb.ConnCase
  import Tesla.Mock

  @readme_url "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"

  test "GET /", %{conn: conn} do
    readme =
      Path.join(Path.dirname(__ENV__.file), "../../app/github/data/good_readme1.md")
      |> File.read!()

    mock(fn %{
              method: :get,
              url: @readme_url
            } ->
      %Tesla.Env{status: 200, body: readme}
    end)

    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Awesome Elixir"
  end
end
