require 'test_helper'

class SearchFormTest < ActiveSupport::TestCase
  should validate_presence_of(:brand)
  should validate_presence_of(:model)
  should validate_presence_of(:part)
  should validate_presence_of(:year)
  should validate_length_of(:brand).is_at_most(75)
  should validate_length_of(:model).is_at_most(75)
  should validate_length_of(:submodel).is_at_most(75)
  should validate_length_of(:part).is_at_most(75)
  should validate_numericality_of(:year).with_message("needs to be between 1900-#{Date.today.year+1}")
  should validate_inclusion_of(:year).in_range(1900..Date.today.year+1).with_message("needs to be between 1900-#{Date.today.year+1}")
  # should validate_inclusion_of(:type).in_array(VehicleType.all)

  setup do
    @search = SearchForm.new(brand: "Kawasaki", model: "KX450F", year: 2008, part: "Complete Wheel Assembly")
    @user = users(:janik)
  end

  test "search form should sanitize inputs before searching" do
    search = SearchForm.new(brand: "  Kawasaki  ", model: "   KX450F  ", submodel: "Test    ", year: "2008", part: "  Complete Wheel Assembly")
    assert search.valid?

    assert_equal search.brand, "Kawasaki"
    assert_equal search.model, "KX450F"
    assert_equal search.submodel, "Test"
    assert_equal search.year, 2008
    assert_equal search.part, "Complete Wheel Assembly"
  end

  test "strange inputs should not break form" do
    search = SearchForm.new(brand: "234  ", model: "  ", submodel: "35Blah", year: 2017, part: "")
    assert_not search.valid?

    assert_no_difference ["Search.count"] do
      search.results(@user)
    end
  end

  test "search form should save a new record after searching" do
    search = @search
    assert search.valid?

    assert_difference ["Search.count"] do
      search.results(@user)
    end
  end

  test "should correctly set attributes when saved with and without user" do
    search = @search
    assert search.valid?

    search.results(@user)
    assert_equal search.search_record.user, @user

    assert_not search.search_record.vehicle
    assert_equal search.search_record.brand, "Kawasaki"
    assert_equal search.search_record.model, "KX450F"

    new_search = @search
    assert new_search.valid?

    search.results(nil)
    assert_equal search.search_record.user, nil
  end

  test "should find and set vehicle if vehicle exists" do
    search = SearchForm.new(brand: "Yamaha", model: "yz250", year: 2006, part: "Complete Wheel Assembly")
    assert search.valid?

    search.results(nil)
    assert_equal search.search_record.vehicle, vehicles(:yz250)
  end

  test "should find and set vehicle if vehicle exists and submodel is given" do
    search = SearchForm.new(brand: "Ford", model: "f150", submodel: "lariat", year: 2017, part: "Brake Pads")
    assert search.valid?

    search.results(nil)
    assert_equal search.search_record.vehicle, vehicles(:lariat)
    assert_equal search.search_record.compatibles, 0.0
  end

  test "should set potentials and compatibles only if vehicle exists" do
    vehicle = vehicles(:yz250)
    part = parts(:wheel06yz)
    part_compatibles_count = part.compatible_parts.count
    part_potentials_count = part.find_potentials.count
    search = SearchForm.new(brand: "Yamaha", model: "yz250", year: 2006, part: "Complete Wheel Assembly")
    assert search.valid?

    search.results(nil)
    assert_equal search.search_record.vehicle, vehicle
    assert_equal search.search_record.compatibles, part_compatibles_count
    assert_equal search.search_record.potentials, part_potentials_count

    new_search = @search
    assert new_search.valid?

    new_search.results(nil)
    assert_nil new_search.search_record.vehicle

    # FIXME The default for these currently is 0. They should probably be nil
    assert_equal new_search.search_record.compatibles, 0.0
    assert_equal new_search.search_record.potentials, 0.0
  end

  # TODO more tests to test individual input cases
  # tests to check for valid type
  # tests for benchmarking maybe?
  # whatever else we're forgetting....
end
