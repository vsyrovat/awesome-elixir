defmodule App.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :description, :string
      add :checked_at, :naive_datetime

      timestamps()
    end

    create unique_index(:categories, [:name])
  end
end
