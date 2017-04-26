require 'test_helper'

class ProductFormTest < UnitTest
  should validate_presence_of(:brand)
  should validate_presence_of(:product_name)
  should validate_presence_of(:root_category)
  should validate_presence_of(:category)
  should validate_length_of(:brand).is_at_most(100)
  should validate_length_of(:product_name).is_at_most(100)
  should validate_length_of(:category).is_at_most(100)

  setup do
    @product = ProductForm.new(brand: 'Acerbis',
                               product_name: 'SXS Skidplate',
                               root_category: 'Motorcycle Parts',
                               category: 'Body',
                               subcategory: 'Skidplate')
  end

  test 'should sanitize fields' do
    product = ProductForm.new(brand: '  Kawasaki  ',
                              product_name: '   big skidplate  ',
                              root_category: '  motorcycle Parts  ',
                              category: 'body',
                              subcategory: '   sKidplatE   ')
    assert product.valid?

    assert_equal product.brand, 'Kawasaki'
    assert_equal product.product_name, 'Big skidplate'
    assert_equal product.root_category, 'Motorcycle Parts'
    assert_equal product.category, 'Body'
    assert_equal product.subcategory, 'SKidplatE'
  end

  test 'product form should find and set brand if it exist' do
    product = @product
    product.brand = 'Yamaha'
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

    assert_equal Brand.last.name, 'Acerbis'
  end

  test 'should create product with only root_category and category' do
    product = @product
    product.subcategory = nil
    assert product.valid?

    assert_difference ['Product.count'] do
      product.save
    end
  end

  test 'product form should select existing parent, category AND subcategory if
    they exist' do
    product = @product
    product.root_category = 'Motorcycle Parts'
    product.category = 'Bearings'
    product.subcategory = 'Wheel Bearings'
    root_category = Category.roots.where(name: product.root_category).first
    category = root_category.children.where(name: product.category).first
    subcategory = category.children.where(name: product.subcategory).first
    assert_not_nil root_category
    assert_not_nil category
    assert_not_nil subcategory
    assert_includes category.children.map(&:name), product.subcategory

    assert product.valid?
    assert_no_difference ['Category.count'] do
      product.save
    end
  end

  test 'product form should find category and create subcategory if it does not
    exist' do
    product = @product
    root_category = Category.roots.where(name: product.root_category).first
    body_category = root_category.children.where(name: product.category).first
    assert_not_nil body_category
    assert_empty body_category.children

    assert product.valid?

    assert_difference ['Category.count'] do
      product.save
    end

    assert_not_empty body_category.children
  end

  test 'product form should create category and subcategory if both do not
    exist' do
    product = @product
    product.category = 'New Category'
    product.subcategory = 'New Subcategory'

    assert_nil Category.where(name: product.category).first

    assert product.valid?

    assert_difference ['Category.count'], 2 do
      product.save
    end

    new_category = Category.where(name: product.category).first
    assert_not_nil new_category
    assert_not_empty new_category.children

    assert_equal new_category.children.first.name, 'New Subcategory'
  end

  test 'should find product if it already exists' do
    product = ProductForm.new(brand: 'Tusk Racing',
                              product_name: 'Sealed ball bearings',
                              root_category: 'Motorcycle Parts',
                              category: 'Bearings',
                              subcategory: 'Wheel Bearings')

    assert_not_nil Product.where(name: product.product_name,
                                 brand: Brand.where(name: product.brand).first)
      .first
    assert product.valid?

    assert_no_difference ['Product.count'] do
      product.save
    end
  end

  test 'should create new product if it does not already exist' do
    product = @product
    assert product.valid?

    assert_difference ['Product.count'] do
      product.save
    end

    assert_equal Product.last, product.product
  end

  test 'should create brand, root_category, category, subcategory and product
    if none exist' do
    product = @product
    product.root_category = 'Tessstt'
    product.category = 'Test'
    product.subcategory = 'Moar Test'
    assert_empty Brand.where(name: product.brand.downcase)
    assert_empty Product.where(name: product.product_name.downcase)
    assert_empty Category.where(name: product.category.downcase ||
                                      product.subcategory.downcase ||
                                      product.root_category.downcase)

    assert product.valid?

    assert_differences [['Brand.count', 1], ['Product.count', 1],
                        ['Category.count', 3]] do
      product.save
    end
  end

  test 'should set user if user is given' do
    product = @product
    product.user = users(:janik)
    assert product.valid?

    product.save

    assert_equal product.product.user, users(:janik)
  end
end
