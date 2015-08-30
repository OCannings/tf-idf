defmodule Tfidf.Mixfile do
  use Mix.Project

  def project do
    [app: :tfidf,
     version: "0.1.2",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: [
       contributors: ["OCannings"],
       licenses: ["Unlicense"],
       links: %{Github: "https://github.com/OCannings/tf-idf"}
     ],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  def description do
    """
      Elixir implementation of tf-idf (Term frequency-inverse document frequency)
    """
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    []
  end
end
