defmodule Wrap.PresentsTest do
  use ExUnit.Case, async: true

  @fixtures Path.expand("test/fixtures/valid_presents")

  test ".query returns a filtered list of presents" do
    all_presents = Wrap.Presents.query("*", @fixtures)
    assert Enum.count(all_presents) == 3

    two_presents = Wrap.Presents.query("* -a", @fixtures)
    assert Enum.count(two_presents) == 2

    assert [namespaced_present | []] = Wrap.Presents.query("* -a -b", @fixtures)
    assert namespaced_present.name == "within_c"

    assert [flat_present | []] = Wrap.Presents.query("* -b -c", @fixtures)
    assert flat_present.name == "a"
  end
end
