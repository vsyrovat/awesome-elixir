defmodule App.AwesomeFillerTest do
  use App.DataCase
  alias App.AwesomeFiller
  alias App.Repo
  alias App.LocalCopy.Category

  def category_fixture(timediff) when is_integer(timediff) do
    timestamp = NaiveDateTime.add(NaiveDateTime.utc_now(), -timediff)

    %Category{}
    |> Category.changeset(%{name: "foo", description: "foo", checked_at: timestamp})
    |> Repo.insert()
  end

  test "_need_refill? on empty table" do
    assert AwesomeFiller._need_refill?()
  end

  test "_need_refill? when outdated" do
    category_fixture(2 * 86400)
    assert AwesomeFiller._need_refill?()
  end

  test "_need_refill? when not outdated" do
    category_fixture(10 * 3600)
    assert not AwesomeFiller._need_refill?()
  end

  test "_create_or_update_category" do
    {:ok, _} =
      AwesomeFiller._create_or_update_category(%{
        name: "AI",
        description: "Artificial Intelligence"
      })

    category = Repo.get_by(Category, name: "AI")
    assert category.description == "Artificial Intelligence"

    {:ok, _} =
      AwesomeFiller._create_or_update_category(%{
        name: "AI",
        description: "No so smart"
      })

    category = Repo.get_by(Category, name: "AI")
    assert category.description == "No so smart"
  end
end
