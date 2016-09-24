require 'test_helper'

class EbayPartImportFormTest < UnitTest
  should validate_presence_of(:brand)
  should validate_presence_of(:product_name)
  should validate_presence_of(:category)
  should validate_presence_of(:epid)
  should validate_length_of(:brand).is_at_most(75)
  should validate_length_of(:product_name).is_at_most(75)
  should validate_length_of(:category).is_at_most(75)
  should validate_length_of(:part_number).is_at_most(75)

  setup do
    @new_part = EbayPartImportForm.new(brand: "Acerbis",
                         product_name: "SXS Skidplate",
                         parent_category: "Motorcycle Parts",
                         category: "Body",
                         subcategory: "Skidplate",
                         part_number: "12345",
                         epid: 12345)
    @existing_part = EbayPartImportForm.new(brand: "Yamaha",
                        product_name: "OEM Wheel Assembly",
                        parent_category: "Motorcycle Parts",
                        category: "Wheels",
                        subcategory: "Complete Wheel Assembly",
                        part_number: "06-yz-250-front-wheel",
                        epid: 12345)
  end

  test "should sanitize fields" do
    part = EbayPartImportForm.new(brand: "  Kawasaki  ",
                        product_name: "   big skidplate  ",
                        parent_category: "   motorcycle Parts   ",
                        category: "body",
                        subcategory: "   sKidplatE   ",
                        part_number: "  Blahh-34534-  ",
                        epid: "12345  ")
    assert part.valid?

    assert_equal part.brand, "Kawasaki"
    assert_equal part.product_name, "Big skidplate"
    assert_equal part.parent_category, "Motorcycle Parts"
    assert_equal part.category, "Body"
    assert_equal part.subcategory, "SKidplatE"
    assert_equal part.part_number, "Blahh-34534-"
    assert_equal part.epid, 12345
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
    assert_empty Category.where(name: part.category.downcase || part.subcategory.downcase || part.parent_category.downcase )

    assert part.valid?

    assert_differences [['Brand.count', 1], ['Product.count', 1], ['Category.count', 3], ['Part.count', 1]] do
      part.save
    end
  end

  test "should not create new Part and Product if they already exist" do
    part = @existing_part
    assert part.valid?

    assert_no_difference ['Product.count', 'Part.count'] do
      part.save
    end

    assert_equal part.product, products(:wheel)
    assert_equal part.part, parts(:wheel06yz)
  end

  test "should create product and part when none exist" do
    part = @new_part
    assert part.valid?

    assert_difference ['Product.count', 'Part.count'] do
      part.save
    end
  end

  test "should only create part when product exists and part doesn't" do
    part = @existing_part
    part.part_number = "Testttt"
    assert part.valid?

    assert_differences [['Product.count', 0], ['Part.count', 1]] do
      part.save
    end
  end

  test "PartForm should set epid if given" do
    part = @new_part
    part.epid = 123456
    assert part.valid?

    part.save
    assert_equal part.epid, 123456
  end

  test "PartForm should be invalid if epid already exists" do
    part = EbayPartImportForm.new(brand: "Acerbis",
                      product_name: "SXS Skidplate",
                      parent_category: "Motorycle Parts",
                      category: "Body",
                      subcategory: "Skidplate",
                      part_number: "12345")
    part.epid = 123456
    assert part.valid?

    part.save
    assert_equal part.epid, 123456

    new_part = EbayPartImportForm.new(brand: "Bad",
                         product_name: "Example",
                         parent_category: " -- ",
                         category: "With",
                         subcategory: "Existing",
                         part_number: "EPID")
    new_part.epid = 123456
    assert_not new_part.valid?
  end

  test "should update part if already exists" do
    # form should eventually update parts/product/attributes
  end

  test "should save note if exists" do
    part = @new_part
    part.note = "This is a note"
    assert part.valid?
    part.save

    assert_equal Part.last.note, "This is a note"
  end

  test "should create new and then set attributes" do
    part = @new_part
    part.attributes = [{parent_attribute: "Color", attribute: "Red"}]
    assert part.valid?

    assert_differences [['PartAttribute.count', 2], ['PartTrait.count', 1]] do
      part.save
    end

    assert_includes part.part.part_attributes, PartAttribute.where(name: "Red").first
  end

  test "should correctly find and set attributes" do
    part = @new_part
    part.attributes = [{parent_attribute: "Location", attribute: "Front"}]
    assert part.valid?

    assert_differences [['PartAttribute.count', 0], ['PartTrait.count', 1]] do
      part.save
    end

    assert_includes part.part.part_attributes, PartAttribute.where(name: "Front").first
  end

  test "should correctly find and set multiple attributes" do
    part = @new_part
    part.attributes = [{parent_attribute: "Color", attribute: "Red"},
                       {parent_attribute: "Size", attribute: "Large"}]
    assert part.valid?

    assert_differences [['PartAttribute.count', 4], ['PartTrait.count', 2]] do
      part.save
    end

    assert_includes part.part.part_attributes, PartAttribute.where(name: "Red").first
  end

end
