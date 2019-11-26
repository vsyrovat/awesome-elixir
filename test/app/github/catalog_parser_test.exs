defmodule App.Github.CatalogParserTest do
  use ExUnit.Case
  alias App.Github.CatalogParser
  alias App.Github.CatalogParser.{Repository, Category}

  test "Parse good Readme to categories" do
    categories =
      Path.join(Path.dirname(__ENV__.file), "data/good_readme1.md")
      |> File.read!()
      |> CatalogParser.parse()

    assert categories == [
             %Category{
               name: "Actors",
               description: "Libraries and tools for working with actors and such.",
               repositories: [
                 %Repository{
                   name: "dflow",
                   url: "https://github.com/dalmatinerdb/dflow",
                   description: "Pipelined flow processing engine."
                 },
                 %Repository{
                   name: "exactor",
                   url: "https://github.com/sasa1977/exactor",
                   description: "Helpers for easier implementation of actors in Elixir."
                 }
               ]
             },
             %Category{
               name: "Algorithms and Data structures",
               description: "Libraries and implementations of algorithms and data structures.",
               repositories: [
                 %Repository{
                   name: "array",
                   url: "https://github.com/takscape/elixir-array",
                   description: "An Elixir wrapper library for Erlang's array."
                 },
                 %Repository{
                   name: "bimap",
                   url: "https://github.com/mkaput/elixir-bimap",
                   description:
                     "Pure Elixir implementation of [bidirectional maps](https://en.wikipedia.org/wiki/Bidirectional_map) and multimaps."
                 }
               ]
             },
             %Category{
               name: "Applications",
               description: "Standalone applications.",
               repositories: [
                 %Repository{
                   name: "bpe",
                   url: "https://github.com/spawnproc/bpe",
                   description: "Business Process Engine in Erlang."
                 },
                 %Repository{
                   name: "CaptainFact",
                   url: "https://github.com/CaptainFact/captain-fact-api",
                   description: "A collaborative, real-time video fact-checking platform."
                 }
               ]
             }
           ]
  end
end
