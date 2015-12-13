json.array!(@manufacturers) do |manufacturer|
  json.extract! manufacturer, :id, :name, :website
  json.url manufacturer_url(manufacturer, format: :json)
end
