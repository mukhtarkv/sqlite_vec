defmodule BitItem do
  use Ecto.Schema

  schema "bit_ecto_items" do
    field(:embedding, SqliteVec.Ecto.Bit)
  end
end

defmodule BitEctoTest do
  use ExUnit.Case, async: false

  import Ecto.Query
  import SqliteVec.Ecto.Query

  setup_all do
    Ecto.Adapters.SQL.query!(Repo, "DROP TABLE IF EXISTS bit_ecto_items", [])

    Ecto.Adapters.SQL.query!(
      Repo,
      "CREATE VIRTUAL TABLE bit_ecto_items USING vec0(id INTEGER PRIMARY KEY, embedding bit[8])",
      []
    )

    create_items()
    :ok
  end

  defp create_items do
    Ecto.Adapters.SQL.query!(
      Repo,
      "insert into bit_ecto_items(id, embedding) values(1, vec_bit(X'FF')), (2, vec_bit(X'00')), (3, vec_bit(X'0A'))",
      []
    )
  end

  test "vector hamming distance" do
    items =
      Repo.all(
        from(i in BitItem,
          order_by: hamming_distance(i.embedding, vec_bit(SqliteVec.Bit.new([0x01]))),
          limit: 5
        )
      )

    assert Enum.map(items, fn v ->
             v.id
           end) == [2, 3, 1]

    assert Enum.map(items, fn v -> v.embedding |> SqliteVec.Bit.to_list() end) == [
             [0x00],
             [0x0A],
             [0xFF]
           ]
  end

  @tag :skip
  test "cast" do
    embedding = [1, 2]
    items = Repo.all(from(i in BitItem, where: i.embedding == ^embedding))
    assert Enum.map(items, fn v -> v.id end) == [1]
  end
end
