json.array!(@parts) do |part|
  json.extract! part, :id, :part_number, :description, :product_id, :user_id
  json.url part_url(part, format: :json)
end
