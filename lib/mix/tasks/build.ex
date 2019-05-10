defmodule Mix.Tasks.Package.Build do
  @moduledoc """
  Build docker images from distillery releases. Images can be 
  published for consumption to a container registry.

  mix package.build -r gcr.io -p my-project package_a package_b
  """

  use Mix.Task

  @cli_config [
    name: "package.build",
    description: "Build docker images from distillery releases",
    about: "Task for building packages",
    allow_unknown_args: true,
    parse_double_dash: true,
    options: [
      registry: [
        value_name: "REGISTRY",
        short: "-r",
        long: "--registry",
        help: "Docker registry",
        required: true
      ],
      project: [
        value_name: "PROJECT",
        short: "-p",
        long: "--project",
        help: "Project on the registry",
        required: true
      ],
      dockerfile: [
        value_name: "DOCKERFILE",
        short: "-d",
        long: "--dockerfile",
        help: "Path to Dockerfile that will be built",
        required: false,
        default: "./Dockerfile"
      ]
    ]
  ]

  @shortdoc "Build docker images from distillery releases"
  @spec run([String.t()]) :: no_return
  def run(argv) do
    cli = Optimus.new!(@cli_config) |> Optimus.parse!(argv)
    cli.unknown |> packages() |> build_all(cli)
  end

  def packages([]), do: Package.list()
  def packages(packages), do: packages |> Package.list_only()

  defp build_all(packages, cli), do: packages |> Enum.each(&build_image(&1, cli))

  defp build_image(name, %Optimus.ParseResult{
         options: %{dockerfile: dockerfile, registry: registry, project: project}
       }) do
    version = Package.version(name)
    hyphen_name = name |> Package.hyphen_name()
    image = [project, hyphen_name] |> Enum.join("/")

    "docker"
    |> System.cmd(
      [
        "image",
        "build",
        ".",
        "-f",
        dockerfile,
        "-t",
        "#{image}:latest",
        "-t",
        "#{registry}/#{image}:latest",
        "--build-arg",
        "name=#{name}",
        "--build-arg",
        "version=#{version}"
      ],
      into: IO.stream(:stdio, :line)
    )
  end
end
