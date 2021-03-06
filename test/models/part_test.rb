require 'test_helper'

class PartTest < UnitTest
  should validate_presence_of(:product)
  # should validate_uniqueness_of(:epid)
  # should validate_uniqueness_of(:part_number).scoped_to(:product_id)
  should belong_to(:product)
  should belong_to(:user)
  should have_many(:fitments)
  should have_many(:oem_vehicles).through(:fitments).source(:vehicle)
  should have_many(:part_attributions).dependent(:destroy)
  should have_many(:part_attributes).through(:part_attributions).source(:part_attribute)
  should have_many(:compatibilities).dependent(:destroy)
  should accept_nested_attributes_for(:part_attributions)

  setup do
    @new_part = Part.new(product: products(:wheel), part_number: "1234", note: "More test info")
    @wheel06yz = parts(:wheel06yz)
    @wheel05yz = parts(:wheel05yz)
    @wheel08yz = parts(:wheel08yz)
    @wheel15yz = parts(:wheel15yz)
    @brakepadste300 = parts(:brakepadste300)
    @speedowheel17wr = parts(:speedowheel17wr)
  end

  test "should find compatible parts" do
    part = @wheel06yz
    assert_includes part.compatible_parts, @wheel05yz
  end

  test "should find potential parts" do
    part = @wheel06yz
    actual_potentials = [@wheel08yz, @wheel15yz, @speedowheel17wr]
    potentials = part.find_potentials

    potentials.each do |p|
      assert_includes actual_potentials, p[:part]
    end
  end

  test "first potential should have the highest rating" do
    part = @wheel06yz
    potentials = part.find_potentials

    assert_equal potentials.first[:score], 0.5
    assert_equal potentials.last[:score], 0.25
  end
end

# TODO we're going to need additoional fixtures that add up when they share similar parts
# make an associated set for a 4th level of potentials

# <---- THIS IS THE COMPATIBILITY SETUP IN THE TEST DB ----> #
# wheel06yz = wheel05yz
# wheel05yz = wheel08yz
# wheel08yz = wheel15yz
# speedowheel17wr === wheel08yz
# wheel08yz === speedowheel17wr
# wheel06yz = brakepadste300 <- this one is purposely bad
# <---- ---- ---- ---- ---- ---- ---- > #

# <---- DISTANCE FROM ONE PART TO ANOTHER ----> #
# wheel06yz -> wheel05yz == 1 (compatible)
# wheel06yz -> wheel08yz == 2 (first level potential) .5 score
# wheel06yz -> wheel15yz == 3 (second level potential) .25 score
# wheel06yz -> speedowheel17wr == 3(second level potential) .25 score
# wheel06yz -> brakepadste300 == 1 (compatible this one is purposely bad)
# <---- ---- ---- ---- ---- ---- ---- > #
