defmodule App.Github.HelpersTest do
  use ExUnit.Case
  import App.Github.Helpers

  test "it should parse repository url to short name" do
    assert short_name("https://github.com/teamon/tesla") == {:ok, "teamon/tesla"}
    assert short_name("https://github.com/teamon/tesla/") == {:ok, "teamon/tesla"}
    assert short_name("http://github.com/teamon/tesla") == {:ok, "teamon/tesla"}
    assert short_name("https://www.github.com/teamon/tesla") == {:ok, "teamon/tesla"}
    
    assert short_name("https://hex.pm/packages/data_morph") == :error
    assert short_name(nil) == :error
    assert short_name("") == :error
  end
end
