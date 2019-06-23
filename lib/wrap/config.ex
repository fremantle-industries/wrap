defmodule Wrap.Config do
  @spec get :: {:ok, term}
  def get do
    opts = Mix.Tasks.Release.parse_args([])
    Mix.Releases.Config.get(opts)
  end
end
