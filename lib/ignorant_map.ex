defimpl Ignorant, for: Map do
  def ignore(%{} = map, ignored_fields) do
    ignored_fields
    |> Enum.reduce(map, &do_ignore/2)
  end

  def do_ignore({key, ignored_fields}, source_map) do
    ignored =
      case source_map[key] do
        list when is_list(list) -> Enum.map(list, fn item -> ignore(item, ignored_fields) end)
        map when is_map(map) -> ignore(map, ignored_fields)
      end

    %{source_map | key => ignored}
  end
  def do_ignore(ignored_field, source_map) do
    %{source_map | ignored_field => :ignored}
  end
end
