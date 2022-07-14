defmodule DebugOMatic.MixProject do
  use Mix.Project

  def project do
    [
      app: :debug_o_matic,
      version: "0.1.0",
      elixir: "~> 1.13.4",
      build_embedded: true,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {DebugOMatic, []},
      extra_applications: [:crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:scenic, path: "~/workspace/scenic", override: true},
      {:scenic_driver_local, "~> 0.11.0-beta.0", targets: :host},
      {:scenic_layout_o_matic, path: "~/workspace/scenic_layout_o_matic"}
    ]
  end
end
