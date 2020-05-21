defmodule XDR.MixProject do
  use Mix.Project

  @github_url "https://github.com/kommitters/xdr"
  @version "0.1.3"

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
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test}
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
      extras: [
        "README.md",
        "CHANGELOG.md"
      ]
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
