defmodule Wrap.TreeTest do
  use ExUnit.Case

  test ".for_path constructs a nested map of package directories with the contents of their manifest" do
    assert {:ok, tree} = "test/fixtures/valid_packages" |> Path.expand() |> Wrap.Tree.for_path()

    assert %Wrap.Manifest{} = manifest_a = tree |> Map.fetch!("a")
    assert manifest_a.project == "project_a"
    assert %Wrap.Manifest{} = manifest_b = tree |> Map.fetch!("b")
    assert manifest_b.project == "project_b"
    assert subtree = tree |> Map.fetch!("c")
    assert %Wrap.Manifest{} = manifest_c = subtree |> Map.fetch!("within_c")
    assert manifest_c.project == "project_within_c"
  end

  test ".for_path returns an error when the path doesn't exist" do
    assert "test/fixtures/i_dont_exit" |> Path.expand() |> Wrap.Tree.for_path() ==
             {:error, :enoent}
  end

  test ".for_path returns an error when the root has a manifest" do
    assert "test/fixtures/root_manifest" |> Path.expand() |> Wrap.Tree.for_path() ==
             {:error, :root_manifest}
  end
end
