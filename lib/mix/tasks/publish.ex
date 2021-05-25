defmodule Mix.Tasks.Wrap.Publish do
  @moduledoc """
  Publish the latest docker images that have been built on the local docker instance
  """

  use Mix.Task

  @cli_config [
    name: "wrap.publish",
    description:
      "Publish the latest docker images that have been built on the local docker instance",
    about: """
    Examples:

    mix wrap.publish my_present

    NOTE: Juice query language https://github.com/rupurt/juice
    """,
    allow_unknown_args: true
  ]

  @shortdoc "Publish latest docker images"
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
        "push",
        "#{Wrap.Present.registry_image(present)}:latest"
      ],
      into: IO.stream(:stdio, :line)
    )
  end
end
