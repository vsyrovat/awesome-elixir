defmodule App.AwesomeFillerTest do
  use App.DataCase
  alias App.AwesomeFiller
  alias App.Repo
  alias App.LocalCopy
  alias App.Github.CatalogParser

  def category_fixture(timediff) when is_integer(timediff) do
    timestamp = NaiveDateTime.add(NaiveDateTime.utc_now(), -timediff)

    %LocalCopy.Category{}
    |> LocalCopy.Category.changeset(%{name: "foo", description: "foo", checked_at: timestamp})
    |> Repo.insert()
  end

  test "_need_refill? on empty table" do
    assert AwesomeFiller._need_refill?()
  end

  test "_need_refill? when outdated" do
    category_fixture(2 * 86400)
    assert AwesomeFiller._need_refill?()
  end

  test "_need_refill? when not outdated" do
    category_fixture(10 * 3600)
    assert not AwesomeFiller._need_refill?()
  end

  test "_create_or_update_category" do
    {:ok, _} =
      AwesomeFiller._create_or_update_category(%CatalogParser.Category{
        name: "AI",
        description: "Artificial Intelligence",
        repositories: []
      })

    category = Repo.get_by(LocalCopy.Category, name: "AI")
    assert category.description == "Artificial Intelligence"

    {:ok, _} =
      AwesomeFiller._create_or_update_category(%CatalogParser.Category{
        name: "AI",
        description: "No so smart",
        repositories: []
      })

    category = Repo.get_by(LocalCopy.Category, name: "AI")
    assert category.description == "No so smart"
  end

  test "_create_or_update_repository" do
    {:ok, _} =
      AwesomeFiller._create_or_update_repository(%CatalogParser.Repository{
        name: "Neiro",
        description: "Neiro package",
        url: "https://github.com/neiro/neiro"
      })

    repository = Repo.get_by(LocalCopy.Repository, alias: "neiro/neiro")
    assert repository.name == "Neiro"
    assert repository.description == "Neiro package"
    assert repository.url == "https://github.com/neiro/neiro"

    {:ok, _} =
      AwesomeFiller._create_or_update_repository(%CatalogParser.Repository{
        name: "Neiro 2",
        description: "New Neiro version",
        url: "https://github.com/neiro/neiro"
      })

    repository = Repo.get_by(LocalCopy.Repository, alias: "neiro/neiro")
    assert repository.name == "Neiro 2"
    assert repository.description == "New Neiro version"
  end
  
  test "_create_or_update_repository if no github url" do
    assert AwesomeFiller._create_or_update_repository(%CatalogParser.Repository{
      name: "Lambada",
      description: "Lambada",
      url: "https://lambada.org"
    }) == :error
  end
end
