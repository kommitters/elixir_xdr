defmodule XDR.MixProject do
  use Mix.Project

  @github_url "https://github.com/kommitters/elixir_xdr"
  @version "0.3.8"

  def project do
    [
      app: :elixir_xdr,
      version: @version,
      elixir: ">= 1.7.0",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      name: "Elixir XDR",
      source_url: @github_url,
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def deps do
    [
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.15", only: :test, runtime: false}
    ]
  end

  defp description() do
    "Process XDR data with elixir. Based on the RFC4506 standard."
  end

  defp docs() do
    [
      main: "readme",
      name: "Elixir XDR",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/elixir_xdr",
      source_url: @github_url,
      extras: extras(),
      groups_for_extras: groups_for_extras()
    ]
  end

  defp extras() do
    [
      "README.md",
      "CHANGELOG.md",
      "guides/examples/integer.md",
      "guides/examples/unsigned_integer.md",
      "guides/examples/enumeration.md",
      "guides/examples/boolean.md",
      "guides/examples/hyper_integer.md",
      "guides/examples/unsigned_hyper_integer.md",
      "guides/examples/floating_point.md",
      "guides/examples/double_floating_point.md",
      "guides/examples/fixed_length_opaque.md",
      "guides/examples/variable_length_opaque.md",
      "guides/examples/string.md",
      "guides/examples/fixed_length_array.md",
      "guides/examples/variable_length_array.md",
      "guides/examples/structure.md",
      "guides/examples/discriminated_union.md",
      "guides/examples/void.md",
      "guides/examples/optional_data.md"
    ]
  end

  defp groups_for_extras do
    [
      Examples: ~r/guides\/examples\/.?/
    ]
  end

  defp package() do
    [
      name: "elixir_xdr",
      licenses: ["MIT"],
      links: %{"GitHub" => @github_url}
    ]
  end
end
