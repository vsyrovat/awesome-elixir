defmodule App.Release do
  @moduledoc """
  Need due release for perform migrations in production.

  In production run:
  DATABASE_URL=... _build/prod/rel/app/bin/app eval App.Release.migrate
  """

  @app :app

  def migrate do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end
end
