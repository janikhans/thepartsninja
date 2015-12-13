json.array!(@vehicles) do |vehicle|
  json.extract! vehicle, :id, :model, :year, :brand_id
  json.url vehicle_url(vehicle, format: :json)
end
