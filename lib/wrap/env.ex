defmodule Wrap.Env do
  @type present :: Wrap.Present.t()

  @spec read(present, atom) :: map
  def read(present, env) do
    [Wrap.present_release_path(), present.name, ".env.#{env}"]
    |> Path.join()
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.replace(&1, "export ", ""))
    |> Enum.map(&String.split(&1, "="))
    |> Enum.into(%{}, &List.to_tuple/1)
  end

  @spec read(present) :: map
  def read(present), do: read(present, Mix.env())
end
