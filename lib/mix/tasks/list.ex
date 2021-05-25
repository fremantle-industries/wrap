defmodule Mix.Tasks.Wrap.List do
  @moduledoc """
  List namespaced presents that can be deployed
  """

  use Mix.Task

  @shortdoc "List presents"
  @spec run(term) :: no_return
  def run(_) do
    Wrap.Mix.Support.setup()

    "*"
    |> Wrap.Presents.query()
    |> Enum.map(& &1.name)
    |> Enum.map(&IO.puts/1)
  end
end
