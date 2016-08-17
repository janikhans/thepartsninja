require 'test_helper'

class BrandTest < UnitTest
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name).with_message("brand already exists")
  should have_many(:vehicle_models).dependent(:destroy)
  should have_many(:products).dependent(:destroy)

  setup do
    @new_brand = Brand.new(name: "Test")
    @yamaha = brands(:yamaha)
    @honda = brands(:honda)
    @ford = brands(:ford)
    @husqvarna = brands(:husqvarna)
    @tusk = brands(:tusk)
  end

  test "name should be sanitized with capital first letter, remaining unchanged" do
    brand = @new_brand

    assert brand.valid?
    brand.name = "TEST"
    brand.save
    assert brand.name = "TEST"

    brand.name = "tESt"
    brand.save
    assert brand.name = "TESt"

    brand.name = "test"
    brand.save
    assert brand.name = "Test"
  end

  test "slug for url should be friendly" do
    brand = @new_brand

    assert brand.valid?
    brand.save

    assert_equal brand.slug, "test"
  end

  # TODO this and more tests
  # test "website should only take correct website format" do
  #   this test needs to be done
  # end
end
