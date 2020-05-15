defmodule XDR.MixProject do
  use Mix.Project

  @github_url "https://github.com/kommitters/xdr"
  @version "0.1.1"

  def project do
    [
      app: :elixir_xdr,
      version: @version,
      elixir: "~> 1.10.0",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs(),
      name: "Elixir XDR",
      source_url: @github_url
    ]
  end

  def deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Process XDR data with elixir, based on the RFC4506 standard."
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
