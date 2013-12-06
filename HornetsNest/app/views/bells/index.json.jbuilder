json.array!(@bells) do |bell|
  json.extract! bell, :id, :name
  json.url bell_url(bell, format: :json)
end
