defmodule Demo.MixProject do
  use Mix.Project

  @uncharted_path "../uncharted"

  def project do
    [
      app: :demo,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      dialyzer: [
        plt_add_apps: ~w(ex_unit mix)a,
        plt_add_deps: :transitive,
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
        # ignore_warnings: "../.dialyzer-ignore.exs"
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        credo: :test,
        dialyzer: :test
      ],
      test_coverage: [tool: ExCoveralls],
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Demo.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  # This refers to dependencies shared among :prod, :test_local, :test, and :dev environments.
  defp deps() do
    [
      {:credo, "~> 1.4", only: [:dev, :test, :test_local], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test, :test_local], runtime: false},
      {:excoveralls, "~> 0.11", only: [:test, :test_local]},
      {:phoenix, "~> 1.5.4"},
      {:phoenix_live_view, "~> 0.15"},
      {:floki, ">= 0.0.0", only: [:test, :test_local]},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"}
    ] ++ uncharted_deps(local: File.exists?(@uncharted_path))
  end

  # This refers to dependencies only needed for local development purposes.
  defp uncharted_deps(local: true) do
    [
      {:uncharted, only: [:dev, :test], path: "../uncharted/uncharted"},
      {:uncharted_phoenix, only: [:dev, :test], path: "../uncharted/uncharted_phoenix"}
    ]
  end

  # This refers to dependencies only needed for prod.
  defp uncharted_deps(local: false) do
    [
      {:uncharted,
       github: "unchartedelixir/uncharted", branch: "master", sparse: "uncharted", override: true},
      {:uncharted_phoenix,
       github: "unchartedelixir/uncharted", branch: "master", sparse: "uncharted_phoenix"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "cmd npm install --prefix assets"]
    ]
  end
end
