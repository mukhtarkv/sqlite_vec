defmodule Int8Item do
  use Ecto.Schema

  schema "int8_ecto_items" do
    field(:embedding, SqliteVec.Ecto.Int8)
  end
end

defmodule Int8EctoTest do
  use ExUnit.Case, async: false

  import Ecto.Query
  import SqliteVec.Ecto.Query

  setup_all do
    Ecto.Adapters.SQL.query!(Repo, "DROP TABLE IF EXISTS int8_ecto_items", [])

    Ecto.Adapters.SQL.query!(
      Repo,
      "CREATE VIRTUAL TABLE int8_ecto_items USING vec0(id INTEGER PRIMARY KEY, embedding int8[2])",
      []
    )

    create_items()
    :ok
  end

  defp create_items do
    Ecto.Adapters.SQL.query!(
      Repo,
      "insert into int8_ecto_items(id, embedding) values(1, vec_int8('[1, 2]')), (2, vec_int8('[52, 43]')), (3, vec_int8('[3, 4]'))",
      []
    )

    # Repo.insert(%Int8Item{
    #   embedding: SqliteVec.Int8.new([1, 2])
    # })

    # Repo.insert(%Int8Item{
    #   embedding: SqliteVec.Int8.new([52, 43])
    # })

    # Repo.insert(%Int8Item{
    #   embedding: Nx.tensor([3, 4], type: :s8)
    # })
  end

  test "vector l2 distance" do
    items =
      Repo.all(
        from(i in Int8Item,
          order_by: l2_distance(i.embedding, vec_int8(SqliteVec.Int8.new([2, 2]))),
          limit: 5
        )
      )

    assert Enum.map(items, fn v ->
             v.id
           end) == [1, 3, 2]

    assert Enum.map(items, fn v -> v.embedding |> SqliteVec.Int8.to_list() end) == [
             [1, 2],
             [3, 4],
             [52, 43]
           ]
  end

  test "vector cosine distance" do
    items =
      Repo.all(
        from(i in Int8Item,
          order_by: cosine_distance(i.embedding, vec_int8(SqliteVec.Int8.new([1, 1]))),
          limit: 5
        )
      )

    assert Enum.map(items, fn v -> v.id end) == [2, 3, 1]
  end

  test "vector cosine similarity" do
    items =
      Repo.all(
        from(i in Int8Item,
          order_by: 1 - cosine_distance(i.embedding, vec_int8(SqliteVec.Int8.new([1, 1]))),
          limit: 5
        )
      )

    assert Enum.map(items, fn v -> v.id end) == [1, 3, 2]
  end

  @tag :skip
  test "cast" do
    embedding = [1, 2]
    items = Repo.all(from(i in Int8Item, where: i.embedding == ^embedding))
    assert Enum.map(items, fn v -> v.id end) == [1]
  end
end
