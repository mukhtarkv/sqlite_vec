if Code.ensure_loaded?(Ecto) do
  defmodule SqliteVec.Ecto.Int8 do
    use Ecto.Type

    def type, do: :binary

    def cast(value) do
      {:ok, SqliteVec.Int8.new(value)}
    end

    def load(data) do
      {:ok, SqliteVec.Int8.from_binary(data)}
    end

    def dump(value) do
      {:ok, value |> SqliteVec.Int8.new() |> SqliteVec.Int8.to_binary()}
    end
  end
end
