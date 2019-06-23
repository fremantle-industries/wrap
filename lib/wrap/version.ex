defmodule Wrap.Version do
  @spec fetch!(term, atom | String.t()) :: String.t() | no_return
  def fetch!(config, name) when is_binary(name) do
    atom_name = name |> String.to_atom()
    fetch!(config, atom_name)
  end

  def fetch!(config, name) when is_atom(name) do
    config
    |> Map.fetch!(:releases)
    |> Map.fetch!(name)
    |> Map.fetch!(:version)
  end
end
