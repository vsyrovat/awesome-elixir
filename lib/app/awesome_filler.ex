defmodule App.AwesomeFiller do
  import Ecto.Query, only: [from: 2]

  alias App.Github.CatalogFetcher
  alias App.Github.CatalogParser
  alias App.LocalCopy
  alias App.Repo

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

  def _create_or_update_category(%{name: name, description: description}) do
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    attrs = %{name: name, description: description, checked_at: timestamp}

    case category = Repo.get_by(LocalCopy.Category, name: name) do
      nil -> LocalCopy.create_category(attrs)
      _ -> LocalCopy.update_category(category, attrs)
    end
  end
end
