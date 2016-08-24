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

      expected_nested_map = %{nested_map | phone: :ignored}
      expected = %{map | age: :ignored, contacts: expected_nested_map}

      assert Ignorant.ignore(map, [:age, contacts: [:phone]]) == expected
    end

    test "recursively adds :ignored tags on nested lists" do
      nested_list = [%{title: "a", details: "a"}, %{title: "b", details: "b"}]
      map = %{name: "Jim", age: 28, posts: nested_list}

      expected_nested_list = Enum.map(nested_list, fn item -> %{item | details: :ignored} end)
      expected = %{map | age: :ignored, posts: expected_nested_list}

      assert Ignorant.ignore(map, [:age, posts: [:details]]) == expected
    end

    test "works if the map has strings as keys" do
      map = %{"name" => "Jim", "age" => 28, "company" => "Dunder Mifflin"}

      expected = %{map | "age" => :ignored, "company" => :ignored}

      assert Ignorant.ignore(map, ["age", "company"]) == expected
    end

    test "recursion works if the map has string as keys" do
      nested_map = %{"email" => "a@a.com", "phone" => "123456"}
      nested_list = [%{"title" => "a", "details" => "a"}, %{"title" => "b", "details" => "b"}]
      map = %{"name" => "Jim", "age" => 28, "contacts" => nested_map, "posts" => nested_list}

      expected_nested_map = %{nested_map | "phone" => :ignored}
      expected_nested_list = Enum.map(nested_list, fn item -> %{item | "details" => :ignored} end)
      expected = %{map | "age" => :ignored, "contacts" => expected_nested_map, "posts" => expected_nested_list}

      assert Ignorant.ignore(map, ["age", "contacts": ["phone"], "posts": ["details"]]) == expected
    end
  end
end
