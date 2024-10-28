defmodule SqliteVec.MixProject do
  use Mix.Project

  def project do
    [
      app: :sqlite_vec,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: Mix.compilers() ++ [:download_sqlite_vec],
      aliases: [
        "compile.download_sqlite_vec": &download_sqlite_vec/1
      ]
    ]
  end

  defp download_sqlite_vec(_) do
    version = Application.get_env(:sqlite_vec, :version, SqliteVec.Downloader.default_version())

    output_dir = Path.join(__DIR__, "priv/#{version}")
    File.mkdir_p!(output_dir)

    case SqliteVec.download(output_dir, version) do
      :skip ->
        :ok

      {:ok, _successful_files, []} ->
        :ok

      {:ok, _successful_files, failed_files} ->
        message = "failed to download: " <> Enum.join(failed_files, ", ")
        raise(message)

      {:error, message} ->
        raise(message)
    end
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:octo_fetch, "~> 0.4.0"},
      # {:exqlite, ">= 0.0.0"},
      {:ecto, "~> 3.0", optional: true},
      {:nx, "~> 0.9", optional: true},
      {:ecto_sql, "~> 3.0", only: :test},
      {:ecto_sqlite3, "~> 0.17", only: :test},
      {:stream_data, "~> 1.0", only: :test}
      # {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end
end
