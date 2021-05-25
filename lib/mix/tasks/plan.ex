defmodule Mix.Tasks.Wrap.Plan do
  @moduledoc """
  Plan the terraform definition for presents published to the container registry

  mix wrap.plan present_a present_b
  """

  use Mix.Task

  @cli_config [
    name: "wrap.plan",
    description: "Display Terraform plan for presents",
    about: """
    Examples:

    mix wrap.plan my_present

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
        |> Wrap.Presents.query()
        |> Enum.each(&plan/1)
    end
  end

  defp plan(present) do
    "terraform"
    |> System.cmd(
      [
        "plan",
        "-var",
        "release_name=#{Wrap.Present.hyphenize(present.name)}"
      ],
      cd: "#{Wrap.present_release_path()}/#{present.name}",
      env: Wrap.Env.read(present),
      into: IO.stream(:stdio, :line)
    )
  end
end
