defmodule AppWeb.PageController do
  use AppWeb, :controller

  def index(conn, _params) do
    categories = [
      %{
        name: "Foo",
        description: "FooDescription",
        libraries: [
          %{
            name: "fooOne",
            description:
              "Awesome Foo library for <a href=\"https://elixir-lang.org/\" target=_blank>Elixir</a>",
            url: "https://github.com/foo/one/",
            stars: 100,
            updated_ago_days: 100,
            outdated?: false
          },
          %{
            name: "fooTwo",
            description: "Foo library for Elixir №1 in the World",
            url: "https://github.com/foo/two/",
            stars: 200,
            updated_ago_days: 222,
            outdated?: true
          }
        ]
      },
      %{
        name: "Bar",
        description: "BarDescription",
        libraries: [
          %{
            name: "barLib",
            description: "Simple and fast Bar package",
            url: "https://github.com/bar/lib/",
            stars: 70,
            updated_ago_days: 400,
            outdated?: true
          },
          %{
            name: "justBar",
            description: "Most rumored Bar lib for Phoenix",
            url: "https://github.com/bar/another/",
            stars: 99,
            updated_ago_days: 70,
            outdated?: false
          }
        ]
      }
    ]

    render(conn, "index.html", %{categories: categories})
  end
end
