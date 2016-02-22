json.array!(@fitments) do |fitment|
  json.extract! fitment, :id, :part_id, :vehicle_id, :discovery_id, :user_id
  json.url fitment_url(fitment, format: :json)
end
