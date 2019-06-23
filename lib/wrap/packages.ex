defmodule Wrap.Packages do
  @type package :: Wrap.Package.t()

  @spec query(String.t(), String.t()) :: [package]
  def query(query, package_release_path \\ Wrap.package_release_path()) do
    {:ok, config} = Wrap.Config.get()

    package_release_path
    |> Wrap.Tree.for_path()
    |> case do
      {:ok, tree} ->
        tree
        |> Juice.squeeze(query)
        |> flatten_packages(config)

      {:error, _} ->
        []
    end
  end

  defp flatten_packages(tree, config), do: tree |> flatten_packages(config, [], "")

  defp flatten_packages(tree, config, packages, namespace) do
    tree
    |> Enum.reduce(
      packages,
      fn
        {name, %Wrap.Manifest{} = manifest}, acc ->
          full_name = namespace |> Path.join(name)
          version = Wrap.Version.fetch!(config, full_name)

          package = %Wrap.Package{
            name: full_name,
            version: version,
            project: manifest.project,
            registry: manifest.registry,
            dockerfile: manifest.dockerfile
          }

          [package | acc]

        {name, children}, acc ->
          new_namespace = namespace |> Path.join(name)
          children |> flatten_packages(config, acc, new_namespace)
      end
    )
  end
end
