class EbayCategory < Category
  has_many :subcategories, class_name: "EbayCategory", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent_category, class_name: "EbayCategory", foreign_key: "parent_id"
end
