defmodule Wrap.Env do
  @type package :: Wrap.Package.t()

  @spec read(package, atom) :: map
  def read(package, env) do
    [Wrap.package_release_path(), package.name, ".env.#{env}"]
    |> Path.join()
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.replace(&1, "export ", ""))
    |> Enum.map(&String.split(&1, "="))
    |> Enum.into(%{}, &List.to_tuple/1)
  end

  @spec read(package) :: map
  def read(package), do: read(package, Mix.env())
end
