defprotocol Ignorant do
  def ignore(data, fields)
  def extract_ignored(data)
end
