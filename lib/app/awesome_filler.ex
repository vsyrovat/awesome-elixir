defmodule App.AwesomeFiller do
  import Ecto.Query, only: [from: 2]

  alias App.Github.CatalogFetcher
  alias App.Github.CatalogParser
  alias App.LocalCopy
  alias App.Repo
  alias App.Github.Helpers

  @refresh_period_second 86400

  def refill_if_need, do: if(_need_refill?(), do: _fill())

  def _need_refill? do
    case Repo.one(from c in LocalCopy.Category, order_by: [asc: :checked_at], limit: 1) do
      nil ->
        true

      %{checked_at: latest_checked_at} ->
        NaiveDateTime.add(latest_checked_at, @refresh_period_second) < NaiveDateTime.utc_now()
    end
  end

  def _fill do
    {:ok, readme_md} = CatalogFetcher.fetch_readme()
    categories = CatalogParser.parse(readme_md)
    Enum.each(categories, fn c -> _create_or_update_category(c) end)
  end

  def _create_or_update_category(%CatalogParser.Category{} = c) do
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    attrs = %{name: c.name, description: c.description, checked_at: timestamp}

    result =
      case category = Repo.get_by(LocalCopy.Category, name: c.name) do
        nil -> LocalCopy.create_category(attrs)
        _ -> LocalCopy.update_category(category, attrs)
      end

    Enum.each(c.repositories, fn r -> _create_or_update_repository(r) end)

    result
  end

  def _create_or_update_repository(%CatalogParser.Repository{} = r) do
    _create_or_update_repository(Helpers.short_name(r.url), r)
  end
  
  def _create_or_update_repository({:ok, alias}, %CatalogParser.Repository{} = r) do
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    attrs = %{
      name: r.name,
      description: r.description,
      url: r.url,
      alias: alias,
      checked_at: timestamp
    }

    case repository = Repo.get_by(LocalCopy.Repository, alias: attrs.alias) do
      nil -> LocalCopy.create_repository(attrs)
      _ -> LocalCopy.update_repository(repository, attrs)
    end
  end
  
  def _create_or_update_repository(:error, _), do: :error
end
