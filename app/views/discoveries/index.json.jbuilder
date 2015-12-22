json.array!(@discoveries) do |discovery|
  json.extract! discovery, :id, :user_id, :comment, :modifications
  json.url discovery_url(discovery, format: :json)
end
