defmodule Wrap do
  @moduledoc """
  Application to build, publish & manage deployment of packages
  """

  @default_path "packages/releases"
  @spec package_release_path :: String.t()
  def package_release_path,
    do: Application.get_env(:wrap, :package_release_path, Path.expand(@default_path))
end
