defimpl Ignorant, for: Map do
  def ignore(%{} = map, ignored_fields) do
    ignored_fields
    |> Enum.reduce(map, &do_ignore/2)
  end

  def do_ignore({key, ignored_fields}, acc) when is_list(ignored_fields) do
    ignored =
      case acc[key] do
        list when is_list(list) -> Enum.map(list, fn item -> ignore(item, ignored_fields) end)
        map when is_map(map) -> ignore(map, ignored_fields)
      end

    %{acc | key => ignored}
  end
  def do_ignore(ignored_field, acc) do
    %{acc | ignored_field => :ignored}
  end
end
