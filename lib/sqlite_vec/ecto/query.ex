if Code.ensure_loaded?(Ecto) do
  defmodule SqliteVec.Ecto.Query do
    @moduledoc """
    Distance functions for Ecto
    """

    @doc """
    Creates a bit vector
    """
    defmacro vec_bit(vector) do
      quote do
        fragment("vec_bit(?)", type(^unquote(vector).data, :binary))
      end
    end

    @doc """
    Creates an int8 vector
    """
    defmacro vec_int8(vector) do
      quote do
        fragment("vec_int8(?)", type(^unquote(vector).data, :binary))
      end
    end

    @doc """
    Creates a float32 vector
    """
    defmacro vec_f32(vector) do
      quote do
        fragment("vec_f32(?)", type(^unquote(vector).data, :binary))
      end
    end

    @doc """
    Returns the L2 distance
    """
    defmacro l2_distance(left, right) do
      quote do
        fragment("vec_distance_L2(?, ?)", unquote(left), unquote(right))
      end
    end

    @doc """
    Returns the cosine distance
    """
    defmacro cosine_distance(left, right) do
      quote do
        fragment("vec_distance_cosine(?, ?)", unquote(left), unquote(right))
      end
    end

    @doc """
    Returns the Hamming distance
    """
    defmacro hamming_distance(left, right) do
      quote do
        fragment("vec_distance_hamming(?, ?)", unquote(left), unquote(right))
      end
    end
  end
end
