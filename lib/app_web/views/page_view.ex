defmodule AppWeb.PageView do
  use AppWeb, :view

  @spec anchor(String.t()) :: String.t()
  def anchor(name) when is_binary(name) do
    String.downcase(name) |> String.replace(" ", "-")
  end
end
