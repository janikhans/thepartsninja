require 'test_helper'

class CompatibleTest < UnitTest
  should validate_presence_of(:part)
  should belong_to(:part)
  should validate_presence_of(:compatible_part)
  should belong_to(:compatible_part)
  should validate_uniqueness_of(:compatible_part).scoped_to(:part_id, :discovery_id)
  should belong_to(:discovery)
  should validate_presence_of(:discovery)

  setup do
    @one = compatibles(:one)
    @two = compatibles(:two)
    @three = compatibles(:three)
    @four = compatibles(:four)
    @five = compatibles(:five)
    @six = compatibles(:six)
  end

  test "should create a second compatible when backwards is true" do
    compatible = Compatible.new(part: parts(:wheel06yz), compatible_part: parts(:wheel15yz), backwards: true, discovery: discoveries(:one))
    assert compatible.valid?

    compatible_count = Compatible.count
    compatible.save
    compatible.make_backwards_compatible
    last_compatible = Compatible.last

    assert_equal Compatible.count, compatible_count + 2
    assert_equal compatible.part, last_compatible.compatible_part
    assert_equal compatible.compatible_part, last_compatible.part
  end

  test "compatible should have votes" do
    User.all.each do |u|
      @one.upvote_by u
      @six.downvote_by u
    end
    compatible = @one
    bad_compatible = @six

    assert_equal compatible.cached_votes_score, 10
    assert_equal bad_compatible.cached_votes_score, -10
  end
end
