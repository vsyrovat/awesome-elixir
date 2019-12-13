defmodule App.Repo.Migrations.AddRepositororiesKeyToCategories do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :repositories, {:array, :string}
    end
  end
end
