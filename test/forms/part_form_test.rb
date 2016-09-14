require 'test_helper'

class PartFormTest < UnitTest
  should validate_presence_of(:brand)
  should validate_presence_of(:product_name)
  should validate_presence_of(:category)
  should validate_presence_of(:subcategory)
  should validate_length_of(:brand).is_at_most(75)
  should validate_length_of(:product_name).is_at_most(75)
  should validate_length_of(:category).is_at_most(75)
  should validate_length_of(:subcategory).is_at_most(75)
  should validate_length_of(:part_number).is_at_most(75)

  setup do
    @new_part = PartForm.new(brand: "Acerbis",
                         product_name: "SXS Skidplate",
                         parent_category: "Motorcycle Parts",
                         category: "Body",
                         subcategory: "Skidplate",
                         part_number: "12345")
    @existing_part = PartForm.new(brand: "Yamaha",
                        product_name: "OEM Wheel Assembly",
                        parent_category: "Motorcycle Parts",
                        category: "Wheels",
                        subcategory: "Complete Wheel Assembly",
                        part_number: "06-yz-250-front-wheel")
  end

  test "should sanitize fields" do
    part = PartForm.new(brand: "  Kawasaki  ",
                        product_name: "   big skidplate  ",
                        parent_category: "   motorcycle Parts   ",
                        category: "body",
                        subcategory: "   sKidplatE   ",
                        part_number: "  Blahh-34534-  ")
    assert part.valid?

    assert_equal part.brand, "Kawasaki"
    assert_equal part.product_name, "Big skidplate"
    assert_equal part.parent_category, "Motorcycle Parts"
    assert_equal part.category, "Body"
    assert_equal part.subcategory, "SKidplatE"
    assert_equal part.part_number, "Blahh-34534-"
  end

  test "PartForm should accept integer or string epid attribute" do
    part = @new_part
    assert part.valid?

    part.epid = "123456"
    assert part.valid?
    assert_equal part.epid, 123456

    part.epid = 123456
    assert part.valid?
  end

  test "should only validate part_number if vehicle is not given" do
    part = @new_part
    assert part.valid?

    part.part_number = nil
    assert_not part.valid?

    part.vehicle = vehicles(:yz250)
    assert part.valid?
  end

  test "should create new product if doesn't exist" do
    part = @new_part
    assert part.valid?

    assert_difference ['Product.count'] do
      part.save
    end

    assert_equal part.product, Product.last
  end

  test "should find and set product if already exist" do
    part = @existing_part
    # TODO if a part_number is also given, check to see if product exists
    assert part.valid?

    assert_no_difference ['Product.count'] do
      part.save
    end

    assert_equal part.product, products(:wheel)
  end


  test "should create brand, category, subcategory, product and part if none exist" do
    part = @new_part
    part.part_number = "12345"
    part.parent_category = "Tessttt"
    part.category = "Test"
    part.subcategory = "Moar Test"
    assert_empty Brand.where(name: part.brand.downcase)
    assert_empty Product.where(name: part.product_name.downcase)
    assert_empty Part.where(part_number: part.part_number)
    assert_empty Category.where(name: part.category.downcase || part.subcategory.downcase || part.parent_category.downcase)

    assert part.valid?

    assert_differences [['Brand.count', 1], ['Product.count', 1], ['Category.count', 3], ['Part.count', 1]] do
      part.save
    end
  end

  test "should create fitment when vehicle is given/exists and fitment doesn't exist" do
    part = @existing_part
    part.vehicle = vehicles(:lariat)
    assert_empty vehicles(:lariat).oem_parts
    assert part.valid?

    assert_differences [['Fitment.count', 1], ['Product.count', 0], ['Part.count',0]] do
      part.save
    end

    assert_not_empty vehicles(:lariat).oem_parts
    assert_includes vehicles(:lariat).oem_parts, part.part
    assert_equal part.product, products(:wheel)
    assert_equal part.part, parts(:wheel06yz)
  end

  test "should return part when vehicle, product, fitment and part exists" do
    part = @existing_part
    part.vehicle = vehicles(:yz250)
    assert part.valid?

    assert_no_difference ['Product.count', 'Part.count', 'Fitment.count'] do
      part.save
    end

    assert_equal part.product, products(:wheel)
    assert_equal part.part, parts(:wheel06yz)
  end

  test "should create product, part, fitment when none exist" do
    part = @new_part
    part.vehicle = vehicles(:te300)
    assert part.valid?

    assert_difference ['Product.count', 'Part.count', 'Fitment.count'] do
      part.save
    end
  end

  test "should only create part and product when vehicle isn't given and part/product don't exist" do
    part = @new_part
    assert_nil part.vehicle
    assert part.valid?

    assert_differences [['Product.count', 1], ['Part.count', 1], ['Fitment.count', 0]] do
      part.save
    end
  end

  test "should only create part when product exists and part doesn't" do
    part = @existing_part
    part.part_number = "Testttt"
    assert_nil part.vehicle
    assert part.valid?

    assert_differences [['Product.count', 0], ['Part.count', 1], ['Fitment.count', 0]] do
      part.save
    end
  end

  test "should create a new part with nil part_number if part_number is nil but vehicle is given" do
    part = @new_part
    part.part_number = nil
    assert_not part.valid?
    part.vehicle = vehicles(:lariat)

    assert part.valid?

    assert_difference ['Product.count', 'Part.count', 'Fitment.count'] do
      part.save
    end

    new_part = PartForm.new(brand: "Acerbis",
                         product_name: "SXS Skidplate",
                         parent_category: "Motorcycle Parts",
                         category: "Body",
                         subcategory: "Skidplate",
                         part_number: "12345")
    new_part.part_number = nil
    new_part.vehicle = vehicles(:te300)

    assert_differences [['Product.count',0], ['Part.count', 1], ['Fitment.count', 1]] do
      new_part.save
    end

    assert_not_equal new_part.part, part.part
    assert_nil new_part.part.part_number
  end

  test "PartForm should set epid if given" do
    part = @new_part
    part.epid = 123456
    assert part.valid?

    part.save
    assert_equal part.epid, 123456
  end

  test "PartForm should be invalid if epid already exists" do
    part = PartForm.new(brand: "Acerbis",
                      product_name: "SXS Skidplate",
                      parent_category: "Motorycle Parts",
                      category: "Body",
                      subcategory: "Skidplate",
                      part_number: "12345")
    part.epid = 123456
    assert part.valid?

    part.save
    assert_equal part.epid, 123456

    new_part = PartForm.new(brand: "Bad",
                         product_name: "Example",
                         parent_category: " -- ",
                         category: "With",
                         subcategory: "Existing",
                         part_number: "EPID")
    new_part.epid = 123456
    assert_not new_part.valid?
  end
end
