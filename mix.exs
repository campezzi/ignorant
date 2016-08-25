defmodule Ignorant.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ignorant,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      package: package,
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  def package do
    [
      description: "Selectively ignore parts of a data structure to allow for partial comparison.",
      licenses: ["MIT"],
      maintainers: ["Thiago Campezzi"],
      links: %{
        "GitHub" => "https://github.com/campezzi/ignorant"
      },
      files: ~w(mix.exs README.md lib)
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:mix_test_watch, "~> 0.2.6", only: :dev}
    ]
  end
end
