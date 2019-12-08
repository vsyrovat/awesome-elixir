defmodule App.AwesomeProvider do
  def categories do
    [
      %{
        name: "Foo",
        description: "FooDescription",
        repositories: [
          %{
            url: "https://github.com/foo/one",
            name: "fooOne",
            description: "Awesome Foo library for [Elixir](https://elixir-lang.org/)",
            stars: 100,
            pushed_at: days_ago(100)
          },
          %{
            url: "https://github.com/foo/two",
            name: "fooTwo",
            description: "Foo library for Elixir №1 in the world",
            stars: 200,
            pushed_at: days_ago(222)
          }
        ]
      },
      %{
        name: "Bar",
        description: "BarDescription",
        repositories: [
          %{
            url: "https://github.com/bar/lib",
            name: "barLib",
            description: "Simple and fast Bar package",
            stars: 70,
            pushed_at: days_ago(400)
          },
          %{
            url: "https://github.com/bar/another",
            name: "justBar",
            description: "Most rumored Bar lib for Phoenix",
            stars: 99,
            pushed_at: days_ago(70)
          }
        ]
      }
    ]
  end

  defp days_ago(days) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(-1 * days * 86400)
    |> NaiveDateTime.truncate(:second)
  end
end
