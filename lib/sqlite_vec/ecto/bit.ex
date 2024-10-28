if Code.ensure_loaded?(Ecto) do
  defmodule SqliteVec.Ecto.Bit do
    use Ecto.Type

    def type, do: :binary

    def cast(value) do
      {:ok, SqliteVec.Bit.new(value)}
    end

    def load(data) do
      {:ok, SqliteVec.Bit.from_binary(data)}
    end

    def dump(value) do
      {:ok, value |> SqliteVec.Bit.new() |> SqliteVec.Bit.to_binary()}
    end
  end
end
