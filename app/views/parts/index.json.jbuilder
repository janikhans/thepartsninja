json.array!(@parts) do |part|
  json.extract! part, :id, :name, :description, :brand_id, :user_id
  json.url part_url(part, format: :json)
end
