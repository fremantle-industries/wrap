defmodule Package.MixProject do
  use Mix.Project

  def project do
    [
      app: :package,
      version: "0.0.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [flags: [:error_handling, :unmatched_returns, :underspecs], plt_add_apps: [:mix]]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:optimus, "~> 0.1.0"},
      {:distillery, "~> 2.0"},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
