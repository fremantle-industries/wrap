defmodule Wrap.Tree do
  defmodule Dir do
    @enforce_keys ~w(path depth children has_manifest)a
    defstruct ~w(path depth children has_manifest)a
  end

  defmodule PackageDir do
    def manifest_file, do: "manifest.json"

    def read_manifest(path) do
      path
      |> Path.join(PackageDir.manifest_file())
      |> File.read()
    end
  end

  @type tree :: map
  @type posix :: File.posix()

  @spec for_path(String.t()) :: {:ok, tree} | {:error, posix | :root_manifest}
  def for_path(path) do
    path
    |> build_dir()
    |> process_dir()
  end

  defp build_dir(path, depth \\ 0) do
    with {:ok, files} <- File.ls(path) do
      has_manifest = files |> Enum.member?(PackageDir.manifest_file())

      child_dirs =
        files
        |> Enum.map(fn f -> path |> Path.join(f) |> build_dir(depth + 1) end)
        |> Enum.filter(fn
          %Dir{} -> true
          _ -> false
        end)

      %Dir{
        path: path,
        depth: depth,
        children: child_dirs,
        has_manifest: has_manifest
      }
    end
  end

  defp process_dir(%Dir{has_manifest: false} = dir) do
    tree =
      dir.children
      |> Enum.reduce(
        %{},
        fn child_dir, new_tree ->
          child_dir
          |> process_dir()
          |> case do
            {:ok, subtree} ->
              package_name = child_dir.path |> Path.basename()
              Map.put(new_tree, package_name, subtree)

            _ ->
              new_tree
          end
        end
      )

    {:ok, tree}
  end

  defp process_dir(%Dir{has_manifest: true, depth: d}) when d <= 0, do: {:error, :root_manifest}

  defp process_dir(%Dir{has_manifest: true} = node) do
    {:ok, file_contents} = node.path |> PackageDir.read_manifest()
    {:ok, json} = file_contents |> Jason.decode()
    Mapail.map_to_struct(json, Wrap.Manifest)
  end

  defp process_dir({:error, :enoent} = error), do: error
end
