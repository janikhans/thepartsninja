require 'test_helper'

class CompatibilityTest < UnitTest
  should validate_presence_of(:part)
  should belong_to(:part)
  should validate_presence_of(:compatible_part)
  should belong_to(:compatible_part)
  should validate_uniqueness_of(:compatible_part).scoped_to(:part_id, :discovery_id)
  should belong_to(:discovery)
  should validate_presence_of(:discovery)

  setup do
    @one = compatibilities(:one)
    @two = compatibilities(:two)
    @three = compatibilities(:three)
    @four = compatibilities(:four)
    @five = compatibilities(:five)
    @six = compatibilities(:six)
  end

  test "should create a second compatibility when backwards is true" do
    compatibility = Compatibility.new(part: parts(:wheel06yz), compatible_part: parts(:wheel15yz), backwards: true, discovery: discoveries(:one))
    assert compatibility.valid?

    assert_difference 'Compatibility.count', 2 do
      compatibility.save
      compatibility.make_backwards_compatible!
    end
    last_compatibility = Compatibility.last

    assert_equal compatibility.compatible_part, last_compatibility.part
  end

  test "compatible should have votes" do
    User.all.each do |u|
      @one.upvote_by u
      @six.downvote_by u
    end
    compatibility = @one
    bad_compatibility = @six

    assert_equal compatibility.cached_votes_score, 10
    assert_equal bad_compatibility.cached_votes_score, -10
  end
end
