defmodule Mix.Tasks.Package.Apply do
  @moduledoc """
  Apply the terraform definition for packages published to the container registry

  mix package.apply package_a package_b
  """

  use Mix.Task

  @shortdoc "Apply terraform definition"
  def run([]), do: Package.list() |> apply_each()
  def run(packages), do: packages |> Package.list_only() |> apply_each()

  defp apply_each(packages), do: packages |> Enum.each(&apply/1)

  defp apply(name) do
    hyphen_name = name |> Package.hyphen_name()
    env = name |> Package.read_env()

    "terraform"
    |> System.cmd(
      [
        "apply",
        "-auto-approve",
        "-var",
        "release_name=#{hyphen_name}"
      ],
      cd: "./packages/releases/#{name}",
      env: env,
      into: IO.stream(:stdio, :line)
    )
  end
end
