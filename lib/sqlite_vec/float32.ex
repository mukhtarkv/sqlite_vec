defmodule SqliteVec.Float32 do
  @moduledoc """
  A vector struct for float32 vectors.
  Vectors are stored as binaries in little endian.
  """

  defstruct [:data]

  @doc """
  Creates a new vector from a list, tensor, or vector
  """
  def new(list) when is_list(list) do
    bin = for v <- list, into: <<>>, do: <<v::float-32-little>>
    from_binary(<<bin::binary>>)
  end

  def new(%SqliteVec.Float32{} = vector) do
    vector
  end

  if Code.ensure_loaded?(Nx) do
    def new(tensor) when is_struct(tensor, Nx.Tensor) do
      if Nx.rank(tensor) != 1 do
        raise ArgumentError, "expected rank to be 1"
      end

      if Nx.type(tensor) != {:f, 32} do
        raise ArgumentError, "expected type to be :f32"
      end

      bin = tensor |> Nx.to_binary() |> f32_native_to_little()
      from_binary(<<bin::binary>>)
    end

    defp f32_native_to_little(binary) do
      for <<n::float-32-native <- binary>>, into: <<>>, do: <<n::float-32-little>>
    end
  end

  @doc """
  Creates a new vector from its binary representation
  """
  def from_binary(binary) when is_binary(binary) do
    %SqliteVec.Float32{data: binary}
  end

  @doc """
  Converts the vector to its binary representation
  """
  def to_binary(vector) when is_struct(vector, SqliteVec.Float32) do
    vector.data
  end

  @doc """
  Converts the vector to a list
  """
  def to_list(vector) when is_struct(vector, SqliteVec.Float32) do
    <<bin::binary>> = vector.data

    for <<v::float-32-native <- bin>>, do: v
  end

  if Code.ensure_loaded?(Nx) do
    @doc """
    Converts the vector to a tensor
    """
    def to_tensor(vector) when is_struct(vector, SqliteVec.Float32) do
      <<bin::binary>> = vector.data
      bin |> f32_little_to_native() |> Nx.from_binary(:f32)
    end

    defp f32_little_to_native(binary) do
      for <<n::float-32-little <- binary>>, into: <<>>, do: <<n::float-32-native>>
    end
  end
end

defimpl Inspect, for: SqliteVec.Float32 do
  import Inspect.Algebra

  def inspect(vector, opts) do
    concat(["vec_f32('", Inspect.List.inspect(SqliteVec.Float32.to_list(vector), opts), "')"])
  end
end
