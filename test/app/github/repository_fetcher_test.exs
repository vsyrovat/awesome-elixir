defmodule App.Github.RepositoryFetcherTest do
  use ExUnit.Case
  import Tesla.Mock
  alias App.Github.RepositoryFetcher
  alias App.Github.RepositoryFetcher.Repo
  alias App.Github.RepositoryFetcher.Limit

  test "retrieve repo info" do
    mock(fn %{method: :get, url: "https://api.github.com/repos/foo/bar"} ->
      %Tesla.Env{
        status: 200,
        body: %{"stargazers_count" => 10, "pushed_at" => "2019-07-13T09:36:02Z"},
        headers: [
          {"x-ratelimit-limit", "60"},
          {"x-ratelimit-remaining", "59"},
          {"x-ratelimit-reset", "1563085238"}
        ]
      }
    end)

    assert RepositoryFetcher.fetch("foo/bar") ==
             {
               :ok,
               %Repo{stars: 10, pushed_at: ~U[2019-07-13T09:36:02Z]},
               %Limit{limit: 60, remain: 59, reset_at: ~U[2019-07-14 06:20:38Z]}
             }
  end

  test "retrieve private repo" do
    mock(fn %{method: :get, url: "https://api.github.com/repos/private/private"} ->
      %Tesla.Env{
        status: 404
      }
    end)

    assert RepositoryFetcher.fetch("private/private") ==
             {:error, :repo_private}
  end

  test "api limit exceeded" do
    mock(fn %{method: :get, url: "https://api.github.com/repos/foo/bar"} ->
      %Tesla.Env{
        status: 403,
        headers: [
          {"x-ratelimit-limit", "60"},
          {"x-ratelimit-remaining", "0"},
          {"x-ratelimit-reset", "1574803073"}
        ]
      }
    end)

    assert RepositoryFetcher.fetch("foo/bar") ==
             {:error, :limit_exceeded,
              %Limit{limit: 60, remain: 0, reset_at: ~U[2019-11-26 21:17:53Z]}}
  end

  test "api limit not exceeded but 403" do
    mock(fn %{method: :get, url: "https://api.github.com/repos/foo/bar"} ->
      %Tesla.Env{
        status: 403,
        headers: [
          {"x-ratelimit-limit", "60"},
          {"x-ratelimit-remaining", "59"},
          {"x-ratelimit-reset", "1574803073"}
        ]
      }
    end)

    assert RepositoryFetcher.fetch("foo/bar") ==
             {:error, :forbidden}
  end

  test "other http error" do
    response = %Tesla.Env{status: 500}
    mock(fn %{} -> response end)

    assert RepositoryFetcher.fetch("foo/bar") == {:error, response}
  end

  test "incorrect argument" do
    assert_raise ArgumentError, "Argument should match the pattern \"{user}/{repo}\"", fn ->
      RepositoryFetcher.fetch("foobar")
    end
  end
end
