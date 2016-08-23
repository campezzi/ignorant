defmodule IgnorantMapTest do
  use ExUnit.Case, async: true

  describe "ignore/2" do
    test "returns the map with :ignored tags on specified fields" do
      map = %{name: "Jim", age: 28, company: "Dunder Mifflin"}
      expected = %{map | age: :ignored, company: :ignored}

      assert Ignorant.ignore(map, [:age, :company]) == expected
    end

    test "recursively adds :ignored tags on nested maps" do
      nested_map = %{email: "a@a.com", phone: "123456"}
      map = %{name: "Jim", age: 28, contacts: nested_map}
      expected = %{map | age: :ignored, contacts: %{nested_map | phone: :ignored}}

      assert Ignorant.ignore(map, [:age, contacts: [:phone]]) == expected
    end

    test "recursively adds :ignored tags on nested lists" do
      item = fn x -> %{title: x, details: x} end
      nested_list = [item.("a"), item.("b")]
      map = %{name: "Jim", age: 28, posts: nested_list}
      expected_nested_list = Enum.map(nested_list, fn item -> %{item | details: :ignored} end)
      expected = %{map | age: :ignored, posts: expected_nested_list}

      assert Ignorant.ignore(map, [:age, posts: [:details]]) == expected
    end
  end
end
