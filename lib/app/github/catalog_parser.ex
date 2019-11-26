defmodule App.Github.CatalogParser do
  use TypedStruct

  defmodule Repository do
    typedstruct enforce: true do
      field :name, String.t()
      field :description, String.t()
      field :url, String.t()
    end
  end

  defmodule Category do
    typedstruct enforce: true do
      field :name, String.t()
      field :description, String.t()
      field :repositories, list(Repository.t())
    end
  end

  @spec parse(binary) :: list(Category.t())
  def parse(readme_md) when is_binary(readme_md) do
    # Based on https://github.com/h4cc/awesome-elixir/blob/master/tests/check.exs

    {blocks, _links, _options} = Earmark.Parser.parse(String.split(readme_md, ~r{\r\n?|\n}))
    [%Earmark.Block.Heading{} | blocks] = blocks
    [_introduction | blocks] = blocks
    [_plusone | blocks] = blocks
    [_other_curated_lists | blocks] = blocks

    [%Earmark.Block.List{blocks: __tableOfContent} | blocksList] = blocks

    extract_categories(blocksList)
  end

  ### Categories ###

  defp extract_categories(blocksList) do
    Enum.reverse(iterate_categories(blocksList, []))
  end

  # Find a level 2 headline, followed by a paragraph and the list of links.
  defp iterate_categories(
         [
           %Earmark.Block.Heading{content: heading, level: 2},
           %Earmark.Block.Para{lines: lines},
           %Earmark.Block.List{blocks: blocks, type: :ul}
           | tail
         ],
         acc
       ) do
    [first_line | _] = lines
    [^first_line, description] = Regex.run(~r/\*?([^*]+)\*?/, first_line)
    repositories = extract_repositories(blocks)
    category = %Category{name: heading, description: description, repositories: repositories}

    iterate_categories(tail, [category | acc])
  end

  # Stop iterating on h1 (Resources list and others not intresting for us)
  defp iterate_categories([%Earmark.Block.Heading{level: 1} | _t], acc), do: acc

  # Unexpected structure
  defp iterate_categories([_h | _t], acc), do: acc

  defp iterate_categories([], acc), do: acc

  ### Repositories ###

  defp extract_repositories(blocksList), do: Enum.reverse(iterate_repositories(blocksList, []))

  defp iterate_repositories([%Earmark.Block.ListItem{blocks: blocks} | tail], acc) do
    [%Earmark.Block.Para{lines: [line | _]} | _] = blocks
    {name, url, description} = parse_repository_line(line)

    iterate_repositories(tail, [%Repository{name: name, description: description, url: url} | acc])
  end

  defp iterate_repositories([], acc), do: acc

  defp parse_repository_line(string) do
    [^string, name, url, description] = Regex.run(~r/\[(.+)\]\((.+)\) +- +(.*)/, string)
    {name, url, description}
  end
end
