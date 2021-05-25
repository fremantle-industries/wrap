defmodule Wrap.PresentTest do
  use ExUnit.Case, async: true

  test ".image is a string with the hyphenized present name, namespaced by project" do
    present = struct(Wrap.Present, project: "my-project", name: "present_name")
    assert Wrap.Present.image(present) == "my-project/present-name"
  end

  test ".registry_image prepends the registry to the image" do
    present =
      struct(Wrap.Present, registry: "my-registry", project: "my-project", name: "present_name")

    assert Wrap.Present.registry_image(present) == "my-registry/my-project/present-name"
  end
end
