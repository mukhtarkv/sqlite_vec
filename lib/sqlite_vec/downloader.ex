defmodule SqliteVec.Downloader do
  use OctoFetch,
    latest_version: "0.1.3",
    github_repo: "asg017/sqlite-vec",
    download_versions: %{
      "0.1.3" => [
        {:darwin, :amd64, "8ef228a8935883f8b5c52f191a8123909ea48ab58f6eceb5d4c12ada654556cf"},
        {:darwin, :arm64, "c57a552c8a8df823a8deb937f81d8a9ec5c81377e66e86cd5db8508b74ef4068"},
        {:linux, :amd64, "5fa404f6d61de7b462d1f1504332a522a64331103603ca079714f078cdb28606"}
      ],
      "0.1.2" => [
        {:darwin, :amd64, "d2d4d312fac1d609723b75cc777df42f3ff0770903cd89d53ca201c6e10c25f9"},
        {:darwin, :arm64, "a449cb190366ee0080bcab132d788b0f792600bfa8dd7c0aba539444c6e126ba"},
        {:linux, :amd64, "539e6bb92612665e1fd1870df1b2c5db66e327bf5a98aee1666c57fb3c6e128d"}
      ]
    }

  @impl true
  def download_name(version, :darwin, arch), do: download_name(version, :macos, arch)
  def download_name(version, os, :amd64), do: download_name(version, os, :x86_64)
  def download_name(version, os, :arm64), do: download_name(version, os, :aarch64)

  def download_name(version, os, arch), do: "sqlite-vec-#{version}-loadable-#{os}-#{arch}.tar.gz"

  def pre_download_hook(_file, output_dir) do
    if library_exists?(output_dir) do
      :skip
    else
      :cont
    end
  end

  defp library_exists?(output_dir) do
    matches =
      output_dir
      |> Path.join("vec0.*")
      |> Path.wildcard()

    matches != []
  end

  def post_write_hook(file) do
    output_dir = file |> Path.dirname() |> Path.join("..") |> Path.expand()
    current_version = file |> Path.dirname() |> Path.basename()

    remove_other_versions(output_dir, current_version)

    :ok
  end

  defp remove_other_versions(output_dir, current_version) do
    output_dir
    |> Path.join("*")
    |> Path.wildcard()
    |> Enum.filter(fn path -> Path.basename(path) != current_version end)
    |> Enum.map(&File.rm_rf(&1))
  end
end
