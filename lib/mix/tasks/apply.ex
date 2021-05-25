defmodule Mix.Tasks.Wrap.Apply do
  @moduledoc """
  Apply the terraform definition for presents published to the container registry
  """

  use Mix.Task

  @cli_config [
    name: "wrap.apply",
    description: "Deploy presents to the cloud with Terraform",
    about: """
    Examples:

    mix wrap.apply my_present

    NOTE: Juice query language https://github.com/rupurt/juice
    """,
    allow_unknown_args: true
  ]

  @shortdoc "Apply terraform definition"
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
        |> Enum.each(&apply/1)
    end
  end

  defp apply(present) do
    "terraform"
    |> System.cmd(
      [
        "apply",
        "-auto-approve",
        "-var",
        "release_name=#{Wrap.Present.hyphenize(present.name)}"
      ],
      cd: "#{Wrap.present_release_path()}/#{present.name}",
      env: Wrap.Env.read(present),
      into: IO.stream(:stdio, :line)
    )
  end
end
