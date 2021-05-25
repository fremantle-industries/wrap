defmodule Mix.Tasks.Wrap.Setup do
  @moduledoc """
  """

  use Mix.Task

  @shortdoc "Setup wrap"
  @spec run([String.t()]) :: no_return
  def run(_argv) do
    Mix.Generator.create_directory("presents")
    Mix.Generator.create_directory("wrappers")
    Mix.Generator.create_file("presents/.gitkeep", "")
    Mix.Generator.create_file("wrappers/.gitkeep", "")
  end
end
