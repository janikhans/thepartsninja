json.array!(@compatibles) do |compatible|
  json.extract! compatible, :id, :original_id, :replaces_id, :discovery_id, :user_id
  json.url compatible_url(compatible, format: :json)
end
