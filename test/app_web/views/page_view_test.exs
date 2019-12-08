defmodule AppWeb.PageViewTest do
  use AppWeb.ConnCase, async: true

  import AppWeb.PageView

  test "create anchor from name" do
    assert anchor("Foo Bar") == "foo-bar"
  end

  test "render hyperlinks in description" do
    assert description(s = "string [should] not (be) changed") == s

    assert description("Awesome Foo library for [Elixir](https://elixir-lang.org/)") ==
             "Awesome Foo library for <a href=\"https://elixir-lang.org/\" target=_blank>Elixir</a>"

    assert description("[Foo](foo)\nBar\n[Baz](baz)") ==
             "<a href=\"foo\" target=_blank>Foo</a>\nBar\n<a href=\"baz\" target=_blank>Baz</a>"

    assert description("Good lib ([Docs](https://hexdocs.pm/good_lib/readme.html)).") ==
             "Good lib (<a href=\"https://hexdocs.pm/good_lib/readme.html\" target=_blank>Docs</a>)."

    assert description("go to the [HTML](#html) section") ==
             "go to the <a href=\"#html\">HTML</a> section"
  end
end
