defmodule App.LocalCopy.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :description, :string
    field :name, :string
    field :checked_at, :naive_datetime
    field :repositories, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description, :checked_at, :repositories])
    |> validate_required([:name, :description, :checked_at])
    |> unique_constraint(:name)
  end
end
