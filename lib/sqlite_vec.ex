defmodule SqliteVec do
  @moduledoc """
  Downloads `SqliteVec`.
  """

  def path(), do: Application.app_dir(:sqlite_vec, "priv/vec0")

  def download(output_dir) do
    SqliteVec.Downloader.download(output_dir)

    {:ok, []}
  end
end
