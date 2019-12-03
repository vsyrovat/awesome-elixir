defmodule AppWeb.PageViewTest do
  use AppWeb.ConnCase, async: true

  import AppWeb.PageView

  test "create anchor from name" do
    assert anchor("Foo Bar") == "foo-bar"
  end
end
