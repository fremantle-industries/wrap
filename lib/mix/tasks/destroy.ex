defmodule Mix.Tasks.Wrap.Destroy do
  @moduledoc """
  Destroy the cloud resources used in the deployment for each present
  """

  use Mix.Task

  @cli_config [
    name: "wrap.destroy",
    description: "Destroy cloud resources for deployed presents",
    about: """
    Examples:

    mix wrap.destroy my_present

    NOTE: Juice query language https://github.com/rupurt/juice
    """,
    allow_unknown_args: true
  ]

  @shortdoc "Destroy presents"
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
        |> Enum.each(&destroy/1)
    end
  end

  defp destroy(present) do
    "terraform"
    |> System.cmd(
      [
        "destroy",
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
