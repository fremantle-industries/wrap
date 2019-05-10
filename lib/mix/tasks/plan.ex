defmodule Mix.Tasks.Package.Plan do
  @moduledoc """
  Plan the terraform definition for packages published to the container registry

  mix package.plan package_a package_b
  """

  use Mix.Task

  @shortdoc "Plan terraform definition"
  def run([]), do: Package.list() |> plan_each()
  def run(packages), do: packages |> Package.list_only() |> plan_each()

  defp plan_each(packages), do: packages |> Enum.each(&plan/1)

  defp plan(name) do
    hyphen_name = name |> Package.hyphen_name()
    env = name |> Package.read_env()

    "terraform"
    |> System.cmd(
      [
        "plan",
        "-var",
        "release_name=#{hyphen_name}"
      ],
      cd: "./packages/releases/#{name}",
      env: env,
      into: IO.stream(:stdio, :line)
    )
  end
end
