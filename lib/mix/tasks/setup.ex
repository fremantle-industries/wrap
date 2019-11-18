defmodule Mix.Tasks.Wrap.Setup do
  @moduledoc """
  """

  use Mix.Task

  @shortdoc "Setup wrap"
  @spec run([String.t()]) :: no_return
  def run(_argv) do
    Mix.Generator.create_directory("packages/modules")
    Mix.Generator.create_directory("packages/releases")
    Mix.Generator.create_file("packages/modules/.gitkeep", "")
    Mix.Generator.create_file("packages/releases/.gitkeep", "")
  end
end
