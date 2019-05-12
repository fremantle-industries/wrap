defmodule Wrap do
  @moduledoc """
  Application to build, publish & management deployment of packages
  """

  @path "packages/releases"

  @spec list :: [String.t()]
  def list, do: @path |> File.ls!() |> Enum.sort()

  @spec list_only([String.t()]) :: [String.t()]
  def list_only(packages), do: list() |> Enum.filter(fn p -> Enum.member?(packages, p) end)

  @spec hyphen_name(String.t()) :: String.t()
  def hyphen_name(name), do: name |> String.replace("_", "-")

  @spec version(atom | String.t()) :: String.t() | no_return
  def version(name) when is_binary(name), do: name |> String.to_atom() |> version

  def version(name) when is_atom(name) do
    {:ok, config} =
      ["name=#{name}"]
      |> Mix.Tasks.Release.parse_args()
      |> Mix.Releases.Config.get()

    config
    |> Map.fetch!(:releases)
    |> Map.fetch!(name)
    |> Map.fetch!(:version)
  end

  @spec read_env(String.t(), atom) :: map
  def read_env(name, env) do
    [@path, name, ".env.#{env}"]
    |> Path.join()
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.replace(&1, "export ", ""))
    |> Enum.map(&String.split(&1, "="))
    |> Enum.into(%{}, &List.to_tuple/1)
  end

  @spec read_env(String.t()) :: map
  def read_env(name), do: read_env(name, :prod)
end
