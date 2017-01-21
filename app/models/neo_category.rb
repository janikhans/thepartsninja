class NeoCategory
  include Neo4j::ActiveNode

  id_property :category_id

  has_many :out, :subcategories, type: :HAS_SUBCATEGORY, model_class: :NeoCategory
  has_many :out, :neo_parts, type: :HAS_CATEGORY_PART
end
