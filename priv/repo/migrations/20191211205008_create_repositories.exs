defmodule App.Repo.Migrations.CreateRepositories do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :alias, :string, nullable: false
      add :url, :string
      add :name, :string
      add :description, :string
      add :stars, :integer
      add :pushed_at, :naive_datetime
      add :checked_at, :naive_datetime

      timestamps()
    end

    create unique_index(:repositories, [:alias])
  end
end
