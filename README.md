# Ignorant

Because sometimes ignorance is bliss.

Ignorant defines a protocol for data structures that may selectively ignore specific values they
contain, usually to simplify partial comparison in tests.

## Motivation
Sometimes it's useful to compare data structures in tests while ignoring pieces of data that are not
deterministic - auto-generated primary keys, calculated timestamps, and so on. Ignoring certain bits
ensures the _shape_ of the data is correct when it's not possible to enforce its values.

## Example

An implementation for `Map` is provided with that package for the purpose described above. Suppose
you have an API endpoint that fetches a record from the database and returns JSON data which
translates to this `response` map:

```elixir
%{
  id: 37,
  name: "Jim"
}
```

Now let's say you want to write a test to ensure that it returns the right data. Problem is, the
`id` field is auto-generated and therefore has no deterministic value between test runs. You could
use pattern matching...

```elixir%{a}
assert %{id: _, name: "Jim"} = response
```

...but you can't assign the value on the left side to a variable (or module attribute) and reuse it,
and if the match fails you don't get a nice diff message. That's where `Ignorant` comes in:

```elixir
assert %{id: :ignored, name: "Jim"} == Ignorant.ignore(response, [:id])
```

The left side is now a proper value that can be put in a variable or attribute and reused. Also note
the `==` (equality) assertion instead of `=` (match) assertion. That gives us a pretty diff that
highlights exactly what doesn't look the same on both sides, and is also stricter (which is a good
idea in tests).

It quickly becomes annoying and error-prone to tag things as `:ignored` in one side of the
comparison and include the corresponding field on the second parameter in the call to `ignore/2` on
the other side, so we can clean that up by using `merge_ignored/2`:

```elixir
expected = %{id: :ignored, name: "Jim"}
assert expected == Ignorant.merge_ignored(response, expected)
```

`merge_ignored` will walk through the `expected` map extracting all fields tagged as `:ignored`, and
then apply those to `response` while keeping all other values intact. The resulting map should be
equal to `expected`. If not, you'll get a pretty diff explaining what's different.


## Installation

1. Add `ignorant` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:ignorant, "~> 0.1.0"}]
  end
  ```

2. Ensure `ignorant` is started before your application:

  ```elixir
  def application do
    [applications: [:ignorant]]
  end
  ```
