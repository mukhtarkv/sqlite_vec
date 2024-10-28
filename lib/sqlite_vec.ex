defmodule SqliteVec do
  @moduledoc """
  Downloads `SqliteVec`.
  """

  def path() do
    version = Application.get_env(:sqlite_vec, :version, SqliteVec.Downloader.default_version())

    Application.app_dir(:sqlite_vec, "priv/#{version}/vec0")
  end

  def download(output_dir, version) do
    SqliteVec.Downloader.download(output_dir, override_version: version)
  end
end
