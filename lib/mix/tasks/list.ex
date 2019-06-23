defmodule Mix.Tasks.Wrap.List do
  @moduledoc """
  List namespaced packages that can be deployed
  """

  use Mix.Task

  @shortdoc "List packages"
  @spec run(term) :: no_return
  def run(_) do
    "*"
    |> Wrap.Packages.query()
    |> Enum.map(& &1.name)
    |> Enum.map(&IO.puts/1)
  end
end
