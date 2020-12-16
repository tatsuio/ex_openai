defmodule ExOpenAI.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_openai,
      version: "0.1.0",
      elixir: "~> 1.11",
      preferred_cli_env: preferred_cli_env(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.7"},
      {:jason, "~> 1.2"},
      {:exvcr, "~> 0.11", only: :test}
    ]
  end

  defp preferred_cli_env do
    [
      vcr: :test,
      "vcr.delete": :test,
      "vcr.check": :test,
      "vcr.show": :test
    ]
  end
end
