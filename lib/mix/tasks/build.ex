defmodule Mix.Tasks.Wrap.Build do
  @moduledoc """
  Build docker images from distillery releases. Images can be
  published for consumption to a container registry.
  """

  use Mix.Task

  @cli_config [
    name: "wrap.build",
    description: "Build docker images for OTP releases",
    about: """
    Examples:

    mix wrap.build my_present

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
        |> Wrap.Presents.query()
        |> Enum.each(&build/1)
    end
  end

  defp build(present) do
    "docker"
    |> System.cmd(
      [
        "image",
        "build",
        ".",
        "-f",
        present.dockerfile,
        "-t",
        "#{Wrap.Present.image(present)}:latest",
        "-t",
        "#{Wrap.Present.registry_image(present)}:latest",
        "--build-arg",
        "release_name=#{present.name}",
        "--build-arg",
        "version=#{present.version}",
        "--no-cache"
      ],
      into: IO.stream(:stdio, :line)
    )
  end
end
