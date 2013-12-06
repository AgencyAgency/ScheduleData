json.array!(@cycles) do |cycle|
  json.extract! cycle, :id, :name
  json.url cycle_url(cycle, format: :json)
end
