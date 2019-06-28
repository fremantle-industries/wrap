defmodule Wrap.Config do
  @spec get :: {:ok, term}
  def get do
    opts = Mix.Tasks.Distillery.Release.parse_args([])
    Distillery.Releases.Config.get(opts)
  end
end
