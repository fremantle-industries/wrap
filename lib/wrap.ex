defmodule Wrap do
  @moduledoc """
  Application to build, publish & manage deployment of presents
  """

  @default_path "presents"
  @spec present_release_path :: String.t()
  def present_release_path do
    Application.get_env(:wrap, :present_release_path, Path.expand(@default_path))
  end
end
