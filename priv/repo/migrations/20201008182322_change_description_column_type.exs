defmodule App.Repo.Migrations.ChangeDescriptionColumnType do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      modify :description, :text
    end

    alter table(:repositories) do
      modify :description, :text
    end
  end
end
