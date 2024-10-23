defmodule SqliteVec.Int8.Test do
  use ExUnit.Case
  use ExUnitProperties

  defp int8_generator do
    gen all(integer <- StreamData.integer()) do
      <<int8::signed-integer-8>> = <<integer>>

      int8
    end
  end

  defp shape_generator do
    {StreamData.positive_integer()}
  end

  defp type_generator do
    [
      {:u, 2},
      {:u, 4},
      {:u, 8},
      # {:u, 16},
      # {:u, 32},
      # {:u, 64},
      {:s, 2},
      {:s, 4},
      {:s, 8},
      # {:s, 16},
      # {:s, 32},
      # {:s, 64},
      # {:f, 8},
      {:f, 16},
      {:f, 32}
      # {:f, 64},
      # {:bf, 16},
      # {:c, 64},
      # {:c, 128}
    ]
    |> Enum.map(&StreamData.constant(&1))
    |> StreamData.one_of()
  end

  defp tensor_generator do
    gen all(seed <- StreamData.integer(), shape <- shape_generator(), type <- type_generator()) do
      key = Nx.Random.key(seed)

      min = Nx.Constants.min_finite(type) |> Nx.to_number()
      max = Nx.Constants.max_finite(type) |> Nx.to_number()

      {tensor, _key} =
        case type do
          {:s, _} -> Nx.Random.randint(key, min, max, shape: shape, type: type)
          {:u, _} -> Nx.Random.randint(key, min, max, shape: shape, type: type)
          {:f, _} -> Nx.Random.uniform(key, min, max, shape: shape, type: type)
          {:bf, _} -> Nx.Random.uniform(key, shape: shape, type: type)
          {:c, _} -> Nx.Random.uniform(key, shape: shape, type: type)
        end

      tensor
    end
    |> StreamData.filter(&is_finite(&1))
  end

  defp is_finite(tensor) do
    tensor |> Nx.is_infinity() |> Nx.any() |> Nx.to_number() == 0
  end

  test "vector" do
    vector = SqliteVec.Int8.new([1, 2, 3])
    assert vector == vector |> SqliteVec.Int8.new()
  end

  test "list" do
    list = [1, 2, 3]
    assert list == list |> SqliteVec.Int8.new() |> SqliteVec.Int8.to_list()
  end

  property "creating vector from list of int8 and calling to_list/1 returns original list" do
    check all(list <- StreamData.list_of(int8_generator(), min_length: 1)) do
      assert list == list |> SqliteVec.Int8.new() |> SqliteVec.Int8.to_list()
    end
  end

  test "tensor" do
    tensor = Nx.tensor([1, 2, 3], type: :s8)
    assert tensor == tensor |> SqliteVec.Int8.new() |> SqliteVec.Int8.to_tensor()
  end

  property "creating vector from tensor and calling to_tensor/1 returns original tensor" do
    check all(tensor <- tensor_generator()) do
      assert tensor ==
               tensor
               |> SqliteVec.Int8.new()
               |> SqliteVec.Int8.to_tensor()
               |> Nx.as_type(Nx.type(tensor))
    end
  end

  test "inspect" do
    vector = SqliteVec.Int8.new([1, 2, 3])
    assert "vec_int8('[1, 2, 3]')" == inspect(vector)
  end

  test "equals" do
    assert SqliteVec.Int8.new([1, 2, 3]) == SqliteVec.Int8.new([1, 2, 3])
    refute SqliteVec.Int8.new([1, 2, 3]) == SqliteVec.Int8.new([1, 2, 4])
  end
end
