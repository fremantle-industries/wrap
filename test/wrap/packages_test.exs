defmodule Wrap.PackagesTest do
  use ExUnit.Case, async: true

  @fixtures Path.expand("test/fixtures/valid_packages")

  test ".query returns a filtered list of packages" do
    all_packages = Wrap.Packages.query("*", @fixtures)
    assert Enum.count(all_packages) == 3

    two_packages = Wrap.Packages.query("* -a", @fixtures)
    assert Enum.count(two_packages) == 2

    assert [namespaced_package | []] = Wrap.Packages.query("* -a -b", @fixtures)
    assert namespaced_package.name == "c/within_c"

    assert [flat_package | []] = Wrap.Packages.query("* -b -c", @fixtures)
    assert flat_package.name == "a"
  end
end
