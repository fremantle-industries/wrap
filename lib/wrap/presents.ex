defmodule Wrap.Presents do
  @type present :: Wrap.Present.t()

  @spec query(String.t(), String.t()) :: [present]
  def query(query, present_release_path \\ Wrap.present_release_path()) do
    present_release_path
    |> Wrap.Tree.for_path()
    |> case do
      {:ok, tree} ->
        tree
        |> Juice.squeeze(query)
        |> flatten_presents()

      {:error, _} ->
        []
    end
  end

  defp flatten_presents(tree), do: tree |> flatten_presents([], "")

  defp flatten_presents(tree, presents, namespace) do
    tree
    |> Enum.reduce(
      presents,
      fn
        {name, %Wrap.Manifest{} = manifest}, acc ->
          full_name = namespace |> Path.join(name)
          version = Wrap.Release.version!(full_name)

          present = %Wrap.Present{
            name: full_name,
            version: version,
            project: manifest.project,
            registry: manifest.registry,
            dockerfile: manifest.dockerfile
          }

          [present | acc]

        {_name, children}, acc ->
          children |> flatten_presents(acc, "")
      end
    )
  end
end
