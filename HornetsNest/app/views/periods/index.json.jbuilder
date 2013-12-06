json.array!(@periods) do |period|
  json.extract! period, :id, :name, :start_time, :end_time, :bell_cycle_id
  json.url period_url(period, format: :json)
end
