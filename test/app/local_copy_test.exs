defmodule App.LocalCopyTest do
  use App.DataCase

  alias App.LocalCopy
  alias App.Repo

  describe "categories" do
    alias App.LocalCopy.Category

    @valid_attrs %{
      description: "some description",
      name: "some name",
      checked_at: ~N[2010-04-17 14:00:00]
    }
    @update_attrs %{
      description: "some updated description",
      name: "some updated name",
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
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LocalCopy.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = LocalCopy.update_category(category, @update_attrs)
      assert category.description == "some updated description"
      assert category.name == "some updated name"
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
end
