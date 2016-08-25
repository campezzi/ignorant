defprotocol Ignorant do
@moduledoc """
Defines functions for data structures that may selectively ignore specific values they contain,
usually to simplify partial comparison in tests.
"""

  @doc """
  Given a data structure and a list of fields to ignore, returns a new data structure with the
  specified fields tagged as `:ignored`.
  """
  def ignore(data, fields)

  @doc """
  Given a data structure, extracts a list of all fields tagged with `:ignored`.
  """
  def extract_ignored(data)

  @doc """
  Returns a modified version of `data_without_ignores` where all fields tagged as `:ignored` in
  `data_with_ignores` are tagged as `:ignored`.

  This usually works by calling `extract_ignored` on `data_with_ignores` to get a list of fields
  that are ignored and then calling `ignore` on `data_without_igores`, passing in that list.

  The two data structures should have the same shape.
  """
  def merge_ignored(data_without_ignores, data_with_ignores)
end
