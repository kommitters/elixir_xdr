defmodule XDR.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_xdr,
      version: "0.1.0",
      elixir: "~> 1.10.0",
      deps: deps(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: "Process XDR data with elixir, based on the standard RFC4506",
      package: package(),
      name: "elixir XDR",
      source_url: "https://github.com/kommitters/xdr",
      files: ~w(mix.exs lib LICENSE README.md),
      homepage_url: "https://kommit.co",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      package: package()
    ]
  end

  def deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      maintainers: ["Francisco Molina", "Luis Hurtado"],
      licenses: ["GNU"],
      links: %{
        "GitHub" => "https://github.com/kommitters/xdr"
      }
    ]
  end
end
