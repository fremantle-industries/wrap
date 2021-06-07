defmodule Wrap.MixProject do
  use Mix.Project

  def project do
    [
      app: :wrap,
      version: "0.0.9",
      elixir: "~> 1.10",
      description: description(),
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_add_apps: [:mix, :ex_unit]
      ],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      releases: [
        a: [
          include_executables_for: [:unix],
          applications: [wrap: :permanent]
        ],
        b: [
          include_executables_for: [:unix],
          applications: [wrap: :permanent]
        ],
        within_c: [
          include_executables_for: [:unix],
          applications: [wrap: :permanent]
        ]
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
      {:optimus, "~> 0.2.0"},
      {:jason, "~> 1.1"},
      {:mapail, "~> 1.0"},
      {:juice, "~> 0.0.3"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    "Build, Publish & Deploy Elixir Infrastructure to the Cloud with Docker & Terraform"
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Alex Kwiatkowski"],
      links: %{"GitHub" => "https://github.com/fremantle-capital/wrap"}
    }
  end
end
