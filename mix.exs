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
    output_dir = Path.join(__DIR__, "priv")
    File.mkdir_p!(output_dir)
    SqliteVec.download(output_dir)
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
      {:octo_fetch, "~> 0.4.0"}
    ]
  end
end
