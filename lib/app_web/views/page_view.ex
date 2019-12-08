defmodule AppWeb.PageView do
  use AppWeb, :view

  @outdated_line_days 365

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

  @spec outdated?(NaiveDateTime.t()) :: boolean()
  def outdated?(%NaiveDateTime{} = pushed_at) do
    div(NaiveDateTime.diff(NaiveDateTime.utc_now(), pushed_at), 86400) > @outdated_line_days
  end

  @spec outdated?(integer()) :: boolean()
  def outdated?(pushed_days_ago) when is_integer(pushed_days_ago),
    do: pushed_days_ago > @outdated_line_days
end
