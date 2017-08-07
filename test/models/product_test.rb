require 'test_helper'

class ProductTest < UnitTest
  should validate_presence_of(:name)
  should belong_to(:brand)
  should validate_presence_of(:brand)
  should belong_to(:category)
  should belong_to(:ebay_category)
  should belong_to(:user) # is this really necessary?
  should have_many(:parts)

  setup do
    @new_product = Product.new(
      name: 'Forever Roll',
      category: categories(:wheel_bearings),
      brand: brands(:tusk)
    )
    @wheel = products(:wheel)
    @brake_pads = products(:brake_pads)
    @wheel_bearings = products(:wheel_bearings)
    @speedowheel = products(:speedowheel)
  end

  test 'slug for url should be friendly' do
    assert @new_product.valid?
    @new_product.save

    assert_equal @new_product.slug, 'tusk-racing-forever-roll'
  end
end
