defmodule Wrap.Mix.Support do
  @spec setup :: no_return
  def setup do
    # make sure we've compiled latest
    Mix.Task.run("compile", [])
    # make sure loadpaths are updated
    Mix.Task.run("loadpaths", [])
  end
end
