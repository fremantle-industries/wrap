defmodule Wrap.Release do
  @spec version!(String.t()) :: String.t()
  def version!(release_name) do
    config = Mix.Project.config()
    lookup_name = release_name |> String.to_atom()
    release = Mix.Release.from_config!(lookup_name, config, [])
    release.version
  end
end
