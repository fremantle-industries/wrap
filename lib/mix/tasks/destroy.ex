defmodule Mix.Tasks.Wrap.Destroy do
  @moduledoc """
  Destroy the cloud resources used in the deployment for each package

  mix package.destroy package_a package_b
  """

  use Mix.Task

  @shortdoc "Destroy packages"
  def run([]) do
    :stderr |> IO.puts(IO.ANSI.format([:red, "one or more package names are required"]))
    :stderr |> IO.puts("usage: mix package.destroy package_a package_b")
  end

  @terraform "terraform"
  def run(packages) do
    packages
    |> Enum.each(fn name ->
      hyphenated = name |> hyphen_name()
      env = name |> Wrap.read_env()

      @terraform
      |> System.cmd(
        [
          "destroy",
          "-auto-approve",
          "-var",
          "release_name=#{hyphenated}"
        ],
        cd: "./packages/releases/#{name}",
        env: env,
        into: IO.stream(:stdio, :line)
      )
    end)
  end

  defp hyphen_name(name), do: name |> String.replace("_", "-")
end
