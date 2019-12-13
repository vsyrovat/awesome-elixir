defmodule App.LocalCopyTest do
  use App.DataCase

  alias App.LocalCopy
  alias App.Repo

  describe "categories" do
    alias App.LocalCopy.Category

    @valid_attrs %{
      description: "some description",
      name: "some name",
      repositories: ["foo/foo", "bar/bar"],
      checked_at: ~N[2010-04-17 14:00:00]
    }
    @update_attrs %{
      description: "some updated description",
      name: "some updated name",
      repositories: ["new/new"],
      checked_at: ~N[2011-05-18 15:01:01]
    }
    @invalid_attrs %{description: nil, name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> LocalCopy.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert LocalCopy.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert LocalCopy.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = LocalCopy.create_category(@valid_attrs)
      assert category.description == "some description"
      assert category.name == "some name"
      assert category.repositories == ["foo/foo", "bar/bar"]
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LocalCopy.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = LocalCopy.update_category(category, @update_attrs)
      assert category.description == "some updated description"
      assert category.name == "some updated name"
      assert category.repositories == ["new/new"]
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = LocalCopy.update_category(category, @invalid_attrs)
      assert category == Repo.get!(Category, category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = LocalCopy.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> LocalCopy.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = LocalCopy.change_category(category)
    end
  end

  describe "repositories" do
    alias App.LocalCopy.Repository

    @valid_attrs %{
      alias: "some alias",
      checked_at: ~N[2010-04-17 14:00:00],
      description: "some description",
      name: "some name",
      pushed_at: ~N[2010-04-17 14:00:00],
      stars: 42,
      url: "some url"
    }
    @update_attrs %{
      alias: "some updated alias",
      checked_at: ~N[2011-05-18 15:01:01],
      description: "some updated description",
      name: "some updated name",
      pushed_at: ~N[2011-05-18 15:01:01],
      stars: 43,
      url: "some updated url"
    }
    @invalid_attrs %{
      alias: nil,
      checked_at: nil,
      description: nil,
      name: nil,
      pushed_at: nil,
      stars: nil,
      url: nil
    }

    def repository_fixture(attrs \\ %{}) do
      {:ok, repository} =
        attrs
        |> Enum.into(@valid_attrs)
        |> LocalCopy.create_repository()

      repository
    end

    test "list_repositories/0 returns all repositories" do
      repository = repository_fixture()
      assert LocalCopy.list_repositories() == [repository]
    end

    test "get_repository!/1 returns the repository with given id" do
      repository = repository_fixture()
      assert LocalCopy.get_repository!(repository.id) == repository
    end

    test "create_repository/1 with valid data creates a repository" do
      assert {:ok, %Repository{} = repository} = LocalCopy.create_repository(@valid_attrs)
      assert repository.alias == "some alias"
      assert repository.checked_at == ~N[2010-04-17 14:00:00]
      assert repository.description == "some description"
      assert repository.name == "some name"
      assert repository.pushed_at == ~N[2010-04-17 14:00:00]
      assert repository.stars == 42
      assert repository.url == "some url"
    end

    test "create_repository/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LocalCopy.create_repository(@invalid_attrs)
    end

    test "update_repository/2 with valid data updates the repository" do
      repository = repository_fixture()

      assert {:ok, %Repository{} = repository} =
               LocalCopy.update_repository(repository, @update_attrs)

      assert repository.alias == "some updated alias"
      assert repository.checked_at == ~N[2011-05-18 15:01:01]
      assert repository.description == "some updated description"
      assert repository.name == "some updated name"
      assert repository.pushed_at == ~N[2011-05-18 15:01:01]
      assert repository.stars == 43
      assert repository.url == "some updated url"
    end

    test "update_repository/2 with invalid data returns error changeset" do
      repository = repository_fixture()
      assert {:error, %Ecto.Changeset{}} = LocalCopy.update_repository(repository, @invalid_attrs)
      assert repository == LocalCopy.get_repository!(repository.id)
    end

    test "delete_repository/1 deletes the repository" do
      repository = repository_fixture()
      assert {:ok, %Repository{}} = LocalCopy.delete_repository(repository)
      assert_raise Ecto.NoResultsError, fn -> LocalCopy.get_repository!(repository.id) end
    end

    test "change_repository/1 returns a repository changeset" do
      repository = repository_fixture()
      assert %Ecto.Changeset{} = LocalCopy.change_repository(repository)
    end
  end
end
