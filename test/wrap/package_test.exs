defmodule Wrap.PackageTest do
  use ExUnit.Case, async: true

  test ".image is a string with the hyphenized package name, namespaced by project" do
    package = struct(Wrap.Package, project: "my-project", name: "package_name")
    assert Wrap.Package.image(package) == "my-project/package-name"
  end

  test ".registry_image prepends the registry to the image" do
    package =
      struct(Wrap.Package, registry: "my-registry", project: "my-project", name: "package_name")

    assert Wrap.Package.registry_image(package) == "my-registry/my-project/package-name"
  end
end
