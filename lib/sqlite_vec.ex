defmodule SqliteVec do
  @moduledoc """
  Downloads `SqliteVec`.
  """

  @install_dir Application.app_dir(:sqlite_vec, "priv")

  def path(), do: Path.join(@install_dir, "vec0")

  def install_dir(), do: @install_dir

  def download(output_dir) do
    {:ok, _path, []} = SqliteVec.Downloader.download(output_dir)

    {:ok, []}
  end
end
