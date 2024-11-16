defmodule SqliteVec.Bit do
  @moduledoc """
  A vector struct for bit vectors.
  Vectors are stored as binaries.
  """

  defstruct [:data]

  @doc """
  Creates a new vector from a list, tensor, or vector
  """
  def new(list) when is_list(list) do
    bin = for v <- list, into: <<>>, do: <<v>>
    from_binary(<<bin::binary>>)
  end

  def new(%SqliteVec.Bit{} = vector) do
    vector
  end

  if Code.ensure_loaded?(Nx) do
    def new(tensor) when is_struct(tensor, Nx.Tensor) do
      if Nx.rank(tensor) != 1 do
        raise ArgumentError, "expected rank to be 1"
      end

      if not binary_type_size?(Nx.type(tensor)) do
        raise ArgumentError, "expected type size to be divisible by 8"
      end

      bin = tensor |> Nx.to_binary()
      from_binary(<<bin::binary>>)
    end

    defp binary_type_size?({_type, size}), do: rem(size, 8) == 0
  end

  @doc """
  Creates a new vector from its binary representation
  """
  def from_binary(binary) when is_binary(binary) do
    %SqliteVec.Bit{data: binary}
  end

  @doc """
  Converts the vector to its binary representation
  """
  def to_binary(vector) when is_struct(vector, SqliteVec.Bit) do
    vector.data
  end

  @doc """
  Converts the vector to a list of integers
  """
  def to_list(vector) when is_struct(vector, SqliteVec.Bit) do
    <<bin::binary>> = vector.data

    for <<v::integer-8 <- bin>>, do: v
  end

  if Code.ensure_loaded?(Nx) do
    @doc """
    Converts the vector to a tensor
    """
    def to_tensor(vector) when is_struct(vector, SqliteVec.Bit) do
      <<bin::binary>> = vector.data
      Nx.from_binary(bin, :u8)
    end
  end
end

defimpl Inspect, for: SqliteVec.Bit do
  import Inspect.Algebra

  def inspect(vector, opts) do
    concat(["vec_bit('", Inspect.List.inspect(SqliteVec.Bit.to_list(vector), opts), "')"])
  end
end
