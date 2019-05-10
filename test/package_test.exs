defmodule PackageTest do
  use ExUnit.Case
  doctest Package

  test "greets the world" do
    assert Package.hello() == :world
  end
end
