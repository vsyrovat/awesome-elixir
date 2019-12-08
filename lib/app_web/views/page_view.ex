defmodule AppWeb.PageView do
  use AppWeb, :view

  @spec anchor(String.t()) :: String.t()
  def anchor(name) when is_binary(name) do
    String.downcase(name) |> String.replace(" ", "-")
  end

  @spec description(String.t()) :: String.t()
  def description(markdown_string) when is_binary(markdown_string) do
    tmp =
      Regex.replace(
        ~r/\[(.+)\]\((#.+)\)/iuU,
        markdown_string,
        "<a href=\"\\g{2}\">\\g{1}</a>"
      )

    Regex.replace(
      ~r/\[(.+)\]\((.+)\)/iuU,
      tmp,
      "<a href=\"\\g{2}\" target=_blank>\\g{1}</a>"
    )
  end
end
