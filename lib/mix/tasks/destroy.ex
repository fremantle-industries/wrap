defmodule Mix.Tasks.Wrap.Destroy do
  @moduledoc """
  Destroy the cloud resources used in the deployment for each package
  """

  use Mix.Task

  @cli_config [
    name: "wrap.destroy",
    description: "Destroy cloud resources for deployed packages",
    about: """
    Examples:

    mix wrap.destroy my_package
    mix wrap.destroy nested_package.a nested_package.b
    mix wrap.destroy nested_package.*

    NOTE: Juice query language https://github.com/rupurt/juice
    """,
    allow_unknown_args: true
  ]

  @shortdoc "Destroy packages"
  @spec run([String.t()]) :: no_return
  def run(argv) do
    @cli_config
    |> Optimus.new!()
    |> Optimus.parse!(argv)
    |> Map.fetch!(:unknown)
    |> packages()
    |> Enum.each(&destroy/1)
  end

  defp packages(argv), do: argv |> Enum.join(" ") |> Wrap.Packages.query()

  defp destroy(package) do
    "terraform"
    |> System.cmd(
      [
        "destroy",
        "-auto-approve",
        "-var",
        "release_name=#{Wrap.Package.hyphenize(package.name)}"
      ],
      cd: "./packages/releases/#{package.name}",
      env: Wrap.Env.read(package),
      into: IO.stream(:stdio, :line)
    )
  end
end
