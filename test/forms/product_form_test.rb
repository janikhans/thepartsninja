require 'test_helper'

class ProductFormTest < UnitTest
  should validate_presence_of(:brand)
  should validate_presence_of(:product_name)
  should validate_presence_of(:parent_category)
  should validate_presence_of(:category)
  should validate_length_of(:brand).is_at_most(75)
  should validate_length_of(:product_name).is_at_most(75)
  should validate_length_of(:category).is_at_most(75)

  setup do
    @product = ProductForm.new(brand: "Acerbis",
                               product_name: "SXS Skidplate",
                               parent_category: "Motorcycle Parts",
                               category: "Body",
                               subcategory: "Skidplate")
  end

  test "should sanitize fields" do
    product = ProductForm.new(brand: "  Kawasaki  ",
                        product_name: "   big skidplate  ",
                        parent_category: "  motorcycle Parts  ",
                        category: "body",
                        subcategory: "   sKidplatE   ")
    assert product.valid?

    assert_equal product.brand, "Kawasaki"
    assert_equal product.product_name, "Big skidplate"
    assert_equal product.parent_category, "Motorcycle Parts"
    assert_equal product.category, "Body"
    assert_equal product.subcategory, "SKidplatE"
  end

  test "product form should find and set brand if it exist" do
    product = @product
    product.brand = "Yamaha"
    assert_equal product.brand, brands(:yamaha).name
    assert product.valid?

    assert_no_difference ['Brand.count'] do
      product.save
    end
  end

  test "product form should create new brand if it doesn't exist" do
    product = @product
    assert_empty Brand.where(name: product.brand)
    assert product.valid?

    assert_difference ['Brand.count'] do
      product.save
    end

    assert_equal Brand.last.name, "Acerbis"
  end

  test "should create product with only parent_category and category" do
    product = @product
    product.subcategory = nil
    assert product.valid?

    assert_difference ['Product.count'] do
      product.save
    end
  end

  test "product form should select existing parent, category AND subcategory if they exist" do
    product = @product
    product.parent_category = "Motorcycle Parts"
    product.category = "Bearings"
    product.subcategory = "Wheel Bearings"
    parent_category = Category.where(name: product.parent_category).first
    category = parent_category.subcategories.where(name: product.category).first
    subcategory = category.subcategories.where(name: product.subcategory).first
    assert_not_nil parent_category
    assert_not_nil category
    assert_not_nil subcategory
    assert_includes category.subcategories.map { |s| s.name }, product.subcategory

    assert product.valid?
    assert_no_difference ['Category.count'] do
      product.save
    end
  end

  test "product form should find category and create subcategory if it doesn't exist" do
    product = @product
    parent_category = Category.where(name: product.parent_category, parent_id: nil).first
    body_category = parent_category.subcategories.where(name: product.category).first
    assert_not_nil body_category
    assert_empty body_category.subcategories

    assert product.valid?

    assert_difference ['Category.count'] do
      product.save
    end

    assert_not_empty body_category.subcategories
  end

  test "product form should create category and subcategory if both don't exist" do
    product = @product
    product.category = "New Category"
    product.subcategory = "New Subcategory"

    assert_nil Category.where(name: product.category).first

    assert product.valid?

    assert_difference ['Category.count'], 2 do
      product.save
    end

    new_category = Category.where(name: product.category).first
    assert_not_nil new_category
    assert_not_empty new_category.subcategories

    assert_equal new_category.subcategories.first.name, "New Subcategory"
  end

  test "should find product if it already exists" do
    product = ProductForm.new(brand: "Tusk Racing",
                        product_name: "Sealed ball bearings",
                        parent_category: "Motorcycle Parts",
                        category: "Bearings",
                        subcategory: "Wheel Bearings")

    assert_not_nil Product.where(name: product.product_name, brand: Brand.where(name: product.brand).first).first
    assert product.valid?

    assert_no_difference ['Product.count'] do
      product.save
    end
  end

  test "should create new product if it doesn't already exist" do
    product = @product
    assert product.valid?

    assert_difference ['Product.count'] do
      product.save
    end

    assert_equal Product.last, product.product
  end

  test "should create brand, parent_category, category, subcategory and product if none exist" do
    product = @product
    product.parent_category = "Tessstt"
    product.category = "Test"
    product.subcategory = "Moar Test"
    assert_empty Brand.where(name: product.brand.downcase)
    assert_empty Product.where(name: product.product_name.downcase)
    assert_empty Category.where(name: product.category.downcase || product.subcategory.downcase || product.parent_category.downcase)

    assert product.valid?

    assert_differences [['Brand.count', 1], ['Product.count', 1], ['Category.count', 3]] do
      product.save
    end
  end

  test "should set user if user is given" do
    product = @product
    product.user = users(:janik)
    assert product.valid?

    product.save

    assert_equal product.product.user, users(:janik)
  end
end
