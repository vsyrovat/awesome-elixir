defmodule App.LocalCopy.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  schema "repositories" do
    field :alias, :string
    field :checked_at, :naive_datetime
    field :description, :string
    field :name, :string
    field :pushed_at, :naive_datetime
    field :stars, :integer
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [:alias, :url, :name, :description, :stars, :pushed_at, :checked_at])
    |> validate_required([:alias, :url, :name, :description])
    |> unique_constraint(:alias)
  end
end
