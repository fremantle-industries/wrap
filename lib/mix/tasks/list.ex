defmodule Mix.Tasks.Package.List do
  @moduledoc """
  List packages that can be deployed
  """

  use Mix.Task

  @shortdoc "List packages"
  def run(_), do: Package.list() |> Enum.map(&IO.puts/1)
end
