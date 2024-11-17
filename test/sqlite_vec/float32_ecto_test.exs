defmodule Float32Item do
  use Ecto.Schema

  schema "float32_ecto_items" do
    field(:embedding, SqliteVec.Ecto.Float32)
  end
end

defmodule EctoTest do
  use ExUnit.Case, async: false

  import Ecto.Query
  import SqliteVec.Ecto.Query

  setup_all do
    Ecto.Adapters.SQL.query!(Repo, "DROP TABLE IF EXISTS float32_ecto_items", [])

    Ecto.Adapters.SQL.query!(
      Repo,
      "CREATE VIRTUAL TABLE float32_ecto_items USING vec0(id INTEGER PRIMARY KEY, embedding float[2])",
      []
    )

    create_items()
    :ok
  end

  defp create_items do
    Repo.insert(%Float32Item{
      embedding: SqliteVec.Float32.new([1, 2])
    })

    Repo.insert(%Float32Item{
      embedding: [52.0, 43.0]
    })

    Repo.insert(%Float32Item{
      embedding: Nx.tensor([3, 4], type: :f32)
    })
  end

  test "vector l2 distance" do
    v = SqliteVec.Float32.new([2, 2])

    items =
      Repo.all(
        from(i in Float32Item,
          order_by: l2_distance(i.embedding, vec_f32(v)),
          limit: 5
        )
      )

    assert Enum.map(items, fn v ->
             v.id
           end) == [1, 3, 2]

    assert Enum.map(items, fn v -> v.embedding |> SqliteVec.Float32.to_list() end) == [
             [1.0, 2.0],
             [3.0, 4.0],
             [52.0, 43.0]
           ]
  end

  test "vector cosine distance" do
    items =
      Repo.all(
        from(i in Float32Item,
          order_by: cosine_distance(i.embedding, vec_f32(SqliteVec.Float32.new([1, 1]))),
          limit: 5
        )
      )

    assert Enum.map(items, fn v -> v.id end) == [2, 3, 1]
  end

  test "vector cosine similarity" do
    items =
      Repo.all(
        from(i in Float32Item,
          order_by: 1 - cosine_distance(i.embedding, vec_f32(SqliteVec.Float32.new([1, 1]))),
          limit: 5
        )
      )

    assert Enum.map(items, fn v -> v.id end) == [1, 3, 2]
  end

  test "cast" do
    embedding = [1.0, 2.0]
    items = Repo.all(from(i in Float32Item, where: i.embedding == ^embedding))
    assert Enum.map(items, fn v -> v.id end) == [1]
  end
end
