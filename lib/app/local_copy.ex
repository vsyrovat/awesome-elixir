defmodule App.LocalCopy do
  import Ecto.Query, warn: false

  alias App.Repo
  alias App.LocalCopy.Category
  alias App.LocalCopy.Repository

  def list_categories do
    Repo.all(Category)
  end

  def get_category!(id), do: Repo.get!(Category, id)

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  def list_repositories do
    Repo.all(Repository)
  end

  def get_repository!(id), do: Repo.get!(Repository, id)

  def create_repository(attrs \\ %{}) do
    %Repository{}
    |> Repository.changeset(attrs)
    |> Repo.insert()
  end

  def update_repository(%Repository{} = repository, attrs) do
    repository
    |> Repository.changeset(attrs)
    |> Repo.update()
  end

  def delete_repository(%Repository{} = repository) do
    Repo.delete(repository)
  end

  def change_repository(%Repository{} = repository) do
    Repository.changeset(repository, %{})
  end
end
