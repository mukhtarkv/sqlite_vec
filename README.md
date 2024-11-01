# SqliteVec

A wrapper to use [sqlite-vec](https://github.com/asg017/sqlite-vec), a SQLite extension for working with vectors, in Elixir.
The configured version of the precompiled loadable library will be downloaded from the GitHub releases.
Moreover, this package provides structs and custom Ecto types for working with Float32, Int8, and Bit vectors.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sqlite_vec` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sqlite_vec, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/sqlite_vec>.

## Getting Started

`SqliteVec.path/0` returns the path of the downloaded library.
Therefore, you can load the extension using this path.

For instance with `Exqlite`:
```elixir
{:ok, conn} = Basic.open(":memory:")
:ok = Basic.enable_load_extension(conn)

Basic.load_extension(conn, SqliteVec.path())
```

Or, with `SQLite` configured as `Ecto.Repo`:

```elixir
defmodule MyApp.Repo do
  use Ecto.Repo,
    otp_app: :my_app,
    adapter: Ecto.Adapters.SQLite3
end

config :my_app, MyApp.Repo, load_extensions: [SqliteVec.path()]
```

You can check out the [Getting Started](notebooks/getting_started.livemd) and [Usage with Ecto](notebooks/usage_with_ecto.livemd) notebooks.

## Attribution

Special thanks to these projects that helped to make this package:

- [OctoFetch](https://hexdocs.pm/octo_fetch/readme.html) which does all the work for downloading the GitHub releases, and served as a blueprint for this package (yes, including this Attribution section :) )
- [sqlite-vec](https://github.com/asg017/sqlite-vec), of course, which provides all of the functionality
- [pgvector](https://hexdocs.pm/pgvector/readme.html) provides something similar for postgres and quite some code could be reused
