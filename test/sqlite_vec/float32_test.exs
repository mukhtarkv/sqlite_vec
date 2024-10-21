defmodule SqliteVec.Float32.Test do
  use ExUnit.Case

  test "vector" do
    vector = SqliteVec.Float32.new([1, 2, 3])
    assert vector == vector |> SqliteVec.Float32.new()
  end

  test "list" do
    list = [1.0, 2.0, 3.0]
    assert list == list |> SqliteVec.Float32.new() |> SqliteVec.Float32.to_list()
  end

  test "tensor" do
    tensor = Nx.tensor([1.0, 2.0, 3.0], type: :f32)
    assert tensor == tensor |> SqliteVec.Float32.new() |> SqliteVec.Float32.to_tensor()
  end

  test "inspect" do
    vector = SqliteVec.Float32.new([1, 2, 3])
    assert "vec_f32('[1.0, 2.0, 3.0]')" == inspect(vector)
  end

  test "equals" do
    assert SqliteVec.Float32.new([1, 2, 3]) == SqliteVec.Float32.new([1, 2, 3])
    refute SqliteVec.Float32.new([1, 2, 3]) == SqliteVec.Float32.new([1, 2, 4])
  end

  test "little endian" do
    assert SqliteVec.Float32.new([2]).data == <<0x00, 0x00, 0x00, 0x40>>
  end
end
