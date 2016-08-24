defimpl Ignorant, for: Map do
  def ignore(map, ignored_fields) do
    ignored_fields
    |> Enum.reduce(map, &do_ignore/2)
  end

  def extract_ignored_fields(map) do
    map
    |> Enum.reduce([], &do_extract_ignored_fields/2)
  end

  defp do_ignore({key, ignored_fields}, source_map) do
    {k, v} = fetch(source_map, key)

    ignored =
      case v do
        list when is_list(list) -> Enum.map(list, fn item -> ignore(item, ignored_fields) end)
        map when is_map(map) -> ignore(map, ignored_fields)
      end

    %{source_map | k => ignored}
  end
  defp do_ignore(ignored_field, source_map) do
    %{source_map | ignored_field => :ignored}
  end

  defp do_extract_ignored_fields({key, :ignored}, ignored_fields), do: [key | ignored_fields]
  defp do_extract_ignored_fields({key, [value | _]}, ignored_fields) do
    do_extract_ignored_fields({key, value}, ignored_fields)
  end
  defp do_extract_ignored_fields({key, map}, ignored_fields) when is_map(map) do
    child_node_fields = extract_ignored_fields(map)
    [{:"#{key}", child_node_fields} | ignored_fields]
  end
  defp do_extract_ignored_fields(_, ignored_fields), do: ignored_fields

  defp fetch(map, key) do
    case map[key] do
      nil -> {to_string(key), map[to_string(key)]}
      value -> {key, value}
    end
  end
end
