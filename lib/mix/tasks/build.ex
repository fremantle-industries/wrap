defmodule Mix.Tasks.Wrap.Build do
  @moduledoc """
  Build docker images from distillery releases. Images can be
  published for consumption to a container registry.
  """

  use Mix.Task

  @cli_config [
    name: "wrap.build",
    description: "Build docker images from distillery releases",
    about: """
    Examples:

    mix wrap.build my_package
    mix wrap.build nested_package.a nested_package.b
    mix wrap.build nested_package.*

    NOTE: Juice query language https://github.com/rupurt/juice
    """,
    allow_unknown_args: true
  ]

  @shortdoc "Build docker images from distillery releases"
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
        |> Enum.each(&build/1)
    end
  end

  defp build(package) do
    "docker"
    |> System.cmd(
      [
        "image",
        "build",
        ".",
        "-f",
        package.dockerfile,
        "-t",
        "#{Wrap.Package.image(package)}:latest",
        "-t",
        "#{Wrap.Package.registry_image(package)}:latest",
        "--build-arg",
        "name=#{package.name}",
        "--build-arg",
        "version=#{package.version}"
      ],
      into: IO.stream(:stdio, :line)
    )
  end
end
