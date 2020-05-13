defmodule XDR.MixProject do
  use Mix.Project

  def project do
    [
      app: :xdr_kommit,
      version: "0.1.0",
      elixir: "~> 1.10.3",
      deps: deps(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      name: "XDR kommit",
      source_url: "https://github.com/kommitters/xdr",
      docs: [
        main: "XDR kommit",
        extras: ["README.md"]
      ]
    ]
  end

  def deps do
    []
  end

  defp description() do
    "Process XDR data with elixir, based on the standard RFC4506"
  end

  defp package() do
    [
      name: "XDR kommit",
      licenses: ["GNU"],
      links: %{"GitHub" => "https://github.com/kommitters/xdr"}
    ]
  end
end
