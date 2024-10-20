defmodule SqliteVec.Downloader do
  use OctoFetch,
    latest_version: "0.1.3",
    github_repo: "asg017/sqlite-vec",
    download_versions: %{
      "0.1.3" => [
        {:darwin, :amd64, "8ef228a8935883f8b5c52f191a8123909ea48ab58f6eceb5d4c12ada654556cf"},
        {:darwin, :arm64, "c57a552c8a8df823a8deb937f81d8a9ec5c81377e66e86cd5db8508b74ef4068"},
        {:linux, :amd64, "5fa404f6d61de7b462d1f1504332a522a64331103603ca079714f078cdb28606"}
      ]
    }

  @impl true
  def download_name(version, :darwin, arch), do: download_name(version, :macos, arch)
  def download_name(version, os, :amd64), do: download_name(version, os, :x86_64)
  def download_name(version, os, :arm64), do: download_name(version, os, :aarch64)

  def download_name(version, os, arch), do: "sqlite-vec-#{version}-loadable-#{os}-#{arch}.tar.gz"

  def pre_download_hook(file, output_dir) do
    current_version = Path.basename(file, ".tar.gz")

    if cached_exists?(output_dir) and equals_cached_version?(current_version) do
      :skip
    else
      File.write(Path.join(output_dir, "tmp_version"), current_version)
      :cont
    end
  end

  def cached_exists?(output_dir) do
    matches =
      output_dir
      |> Path.join("vec0.*")
      |> Path.wildcard()

    matches != []
  end

  def equals_cached_version?(current_version) do
    case File.read(cached_version_file()) do
      {:ok, cached_version} -> current_version == cached_version
      _else -> false
    end
  end

  defp cached_version_file(), do: Application.app_dir(:sqlite_vec, "priv/version")

  def post_write_hook(file) do
    tmp_version_file = file |> Path.dirname() |> Path.join("tmp_version")
    version_file = file |> Path.dirname() |> Path.join("version")

    File.rename(tmp_version_file, version_file)

    :ok
  end
end
