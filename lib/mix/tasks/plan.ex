defmodule Mix.Tasks.Wrap.Plan do
  @moduledoc """
  Plan the terraform definition for packages published to the container registry

  mix wrap.plan package_a package_b
  """

  use Mix.Task

  @cli_config [
    name: "wrap.plan",
    description: "Display Terraform plan for packages",
    about: """
    Examples:

    mix wrap.plan my_package
    mix wrap.plan nested_package.a nested_package.b
    mix wrap.plan nested_package.*

    NOTE: Juice query language https://github.com/rupurt/juice
    """,
    allow_unknown_args: true
  ]

  @shortdoc "Plan terraform definition"
  @spec run([String.t()]) :: no_return
  def run(argv) do
    Wrap.Mix.Support.setup()

    @cli_config
    |> Optimus.new!()
    |> Optimus.parse(argv)
    |> case do
      {:ok, parse_result} ->
        parse_result.unknown
        |> Enum.join(" ")
        |> Wrap.Packages.query()
        |> Enum.each(&plan/1)
    end
  end

  defp plan(package) do
    "terraform"
    |> System.cmd(
      [
        "plan",
        "-var",
        "release_name=#{Wrap.Package.hyphenize(package.name)}"
      ],
      cd: "./packages/releases/#{package.name}",
      env: Wrap.Env.read(package),
      into: IO.stream(:stdio, :line)
    )
  end
end
