json.array!(@fitments) do |fitment|
  json.extract! fitment, :id, :vehicle_id, :part_id, :user_id, :oem, :verified
  json.url fitment_url(fitment, format: :json)
end
