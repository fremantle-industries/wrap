defmodule Mix.Tasks.Wrap.Publish do
  @moduledoc """
  Publish the latest docker images that have been built on the local docker instance

  mix wrap.publish release_a release_b
  """

  use Mix.Task

  @cli_config [
    name: "wrap.publish",
    description:
      "Publish the latest docker images that have been built on the local docker instance",
    about: "Task for publishing docker images",
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
      ]
    ]
  ]

  @shortdoc "Publish latest docker images"
  @spec run([String.t()]) :: no_return
  def run(argv) do
    cli = Optimus.new!(@cli_config) |> Optimus.parse!(argv)
    cli.unknown |> packages() |> build_all(cli)
  end

  def packages([]), do: Wrap.list()
  def packages(packages), do: packages |> Wrap.list_only()

  defp build_all(packages, cli), do: packages |> Enum.each(&build_image(&1, cli))

  defp build_image(name, %Optimus.ParseResult{
         options: %{registry: registry, project: project}
       }) do
    hyphen_name = name |> Wrap.hyphen_name()
    image = [project, hyphen_name] |> Enum.join("/")

    "docker"
    |> System.cmd(
      [
        "push",
        "#{registry}/#{image}:latest"
      ],
      into: IO.stream(:stdio, :line)
    )
  end
end
