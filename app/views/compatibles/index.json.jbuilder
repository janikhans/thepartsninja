json.array!(@compatibles) do |compatible|
  json.extract! compatible, :id, :fitment, :compatible_fitments, :backwards, :discovery_id, :user_id
  json.url compatible_url(compatible, format: :json)
end
