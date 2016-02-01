json.array!(@compatibles) do |compatible|
  json.extract! compatible, :id, :part, :compatible_part, :backwards, :discovery_id, :user_id
  json.url compatible_url(compatible, format: :json)
end
