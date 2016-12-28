json.descendants @category.has_children?
json.fitment_notes @category.fitment_notes.count(:all) > 0
json.part_attributes @category.part_attributes.count(:all) > 0
json.subcategories @subcategories do |subcategory|
  json.id subcategory.id
  json.name subcategory.name
end
