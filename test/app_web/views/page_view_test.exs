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

  test "calculate outdated? flag by updated_ago_days" do
    assert outdated?(400)
    assert not outdated?(100)
  end

  test "calculate outdated? flag by pushed_at" do
    assert outdated?(NaiveDateTime.add(NaiveDateTime.utc_now(), -400 * 86400))
    assert not outdated?(NaiveDateTime.add(NaiveDateTime.utc_now(), -100 * 86400))
  end
end
