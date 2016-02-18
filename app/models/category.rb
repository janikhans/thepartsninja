class Category < ActiveRecord::Base
  belongs_to :parent
  has_many :products

  has_many :subcategories, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent_category, :class_name => "Category"

  validates :name, presence: true
end
