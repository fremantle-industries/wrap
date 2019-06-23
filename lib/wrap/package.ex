defmodule Wrap.Package do
  @type t :: %Wrap.Package{
          name: String.t(),
          dockerfile: String.t(),
          project: String.t(),
          registry: String.t(),
          version: String.t()
        }

  @enforce_keys ~w(name dockerfile project registry version)a
  defstruct ~w(name dockerfile project registry version)a

  @spec image(t) :: String.t()
  def image(%Wrap.Package{project: project, name: name}) do
    name
    |> hyphenize()
    |> namespace(project)
  end

  @spec registry_image(t) :: String.t()
  def registry_image(%Wrap.Package{} = package) do
    package
    |> image()
    |> namespace(package.registry)
  end

  @spec hyphenize(String.t()) :: String.t()
  def hyphenize(name), do: name |> String.replace("_", "-")

  defp namespace(name, namespace), do: [namespace, name] |> Enum.join("/")
end
