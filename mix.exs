defmodule Wrap.MixProject do
  use Mix.Project

  def project do
    [
      app: :wrap,
      version: "0.0.7",
      elixir: "~> 1.9",
      description: description(),
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_add_apps: [:mix, :ex_unit]
      ]
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
      {:jason, "~> 1.1"},
      {:mapail, "~> 1.0"},
      {:juice, "~> 0.0.3"},
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    "Build, Publish & Deploy Elixir Infrastructure to the Cloud with Distillery, Docker & Terraform"
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Alex Kwiatkowski"],
      links: %{"GitHub" => "https://github.com/fremantle-capital/wrap"}
    }
  end
end
