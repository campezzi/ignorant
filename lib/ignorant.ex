defprotocol Ignorant do
  def ignore(data, fields)
  def extract_ignored(data)
  def merge_ignored(data_without_ignores, data_with_ignores)
end
