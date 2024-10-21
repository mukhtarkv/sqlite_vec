if Code.ensure_loaded?(Ecto) do
  defmodule SqliteVec.Ecto.Float32 do
    use Ecto.Type

    def type, do: :binary

    def cast(value) do
      {:ok, SqliteVec.Float32.new(value)}
    end

    def load(data) do
      {:ok, SqliteVec.Float32.from_binary(data)}
    end

    def dump(value) do
      {:ok, value |> SqliteVec.Float32.new() |> SqliteVec.Float32.to_binary()}
    end
  end
end
