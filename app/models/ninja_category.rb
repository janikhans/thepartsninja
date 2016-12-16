class NinjaCategory < Category
  has_many :subcategories, class_name: "NinjaCategory", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent_category, class_name: "NinjaCategory", foreign_key: "parent_id"
  accepts_nested_attributes_for :subcategories, reject_if: :all_blank, allow_destroy: true
end
