defmodule App.AwesomeFiller do
  import Ecto.Query, only: [from: 2]
  require Logger

  alias App.Github.CatalogFetcher
  alias App.Github.CatalogParser
  alias App.Github.Helpers
  alias App.Github.RepositoryFetcher
  alias App.LocalCopy
  alias App.Repo

  @refresh_period_second 86400

  def fill_if_need do
    Logger.info("Refill started")
    _fill_categories_if_need()
    _fill_repositories_if_need()
    Logger.info("Refill finished")
  end

  def _fill_categories_if_need, do: if(_need_fill_categories?(), do: _fill_categories())

  def _need_fill_categories? do
    case Repo.one(from c in LocalCopy.Category, order_by: [asc: :checked_at], limit: 1) do
      nil ->
        true

      %{checked_at: latest_checked_at} ->
        NaiveDateTime.add(latest_checked_at, @refresh_period_second) < NaiveDateTime.utc_now()
    end
  end

  def _fill_categories do
    {:ok, readme_md} = CatalogFetcher.fetch_readme()
    categories = CatalogParser.parse(readme_md)
    Enum.each(categories, fn c -> _create_or_update_category(c) end)
  end

  def _create_or_update_category(%CatalogParser.Category{} = c) do
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    attrs = %{
      name: c.name,
      description: c.description,
      checked_at: timestamp,
      repositories:
        c.repositories
        |> Enum.map(fn r ->
          case Helpers.short_name(r.url) do
            {:ok, x} -> x
            _ -> nil
          end
        end)
        |> Enum.filter(fn x -> x end)
    }

    Enum.each(c.repositories, fn r -> _create_or_update_repository(r) end)

    case category = Repo.get_by(LocalCopy.Category, name: c.name) do
      nil -> LocalCopy.create_category(attrs)
      _ -> LocalCopy.update_category(category, attrs)
    end
  end

  def _create_or_update_repository(%CatalogParser.Repository{} = r) do
    _create_or_update_repository(Helpers.short_name(r.url), r)
  end

  def _create_or_update_repository({:ok, alias}, %CatalogParser.Repository{} = r) do
    attrs = %{
      name: r.name,
      description: r.description,
      url: r.url,
      alias: alias
    }

    case repository = Repo.get_by(LocalCopy.Repository, alias: attrs.alias) do
      nil -> LocalCopy.create_repository(attrs)
      _ -> LocalCopy.update_repository(repository, attrs)
    end
  end

  def _create_or_update_repository(_, _), do: {:error}

  def _fill_repositories_if_need do
    _fill_next_repository()
  end

  def _fill_next_repository do
    case _suggest_repository_for_fill() do
      {:ok, repository} ->
        case _fill_repository(repository) do
          {:ok, _, _} ->
            _fill_next_repository()

          {:error, :limit_exceeded, limit} ->
            {:ok, :pause_due_limit, limit}

          {:error, _} ->
            _mark_repository_as_checked(repository)
            _fill_next_repository()
        end

      :none ->
        {:ok, :done}
    end
  end

  def _suggest_repository_for_fill do
    case Repo.one(from r in LocalCopy.Repository, where: is_nil(r.checked_at), limit: 1) do
      nil ->
        timestamp = NaiveDateTime.add(NaiveDateTime.utc_now(), -@refresh_period_second)

        case Repo.one(
               from r in LocalCopy.Repository,
                 where: r.checked_at < ^timestamp,
                 order_by: [asc: :checked_at],
                 limit: 1
             ) do
          nil -> :none
          repository -> {:ok, repository}
        end

      repository ->
        {:ok, repository}
    end
  end

  def _fill_repository(%LocalCopy.Repository{} = repository) do
    case RepositoryFetcher.fetch(repository.alias) do
      {:ok, repo, limit} ->
        case _update_repository(repository, repo.stars, repo.pushed_at) do
          {:ok, repository} -> {:ok, repository, limit}
          :error -> :error
        end

      any ->
        any
    end
  end

  def _update_repository(%LocalCopy.Repository{} = repository, stars, pushed_at) do
    LocalCopy.update_repository(repository, %{
      stars: stars,
      pushed_at: pushed_at,
      checked_at: NaiveDateTime.utc_now()
    })
  end

  def _mark_repository_as_checked(repository) do
    LocalCopy.update_repository(repository, %{checked_at: NaiveDateTime.utc_now()})
  end
end
