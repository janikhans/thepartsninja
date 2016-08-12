require 'test_helper'

class ProfileTest < UnitTest
  should belong_to(:user)
  should validate_presence_of(:user)
  should validate_uniqueness_of(:user)

  setup do
    @janik = profiles(:janik)
    @hans = profiles(:hans)
    @sensei = profiles(:sensei)
  end

  test "fixtures should be valid" do
    assert @janik.valid?
    assert @hans.valid?
    assert @sensei.valid?
  end

  test "location can't be too long" do
    profile = @janik

    profile.location = "a"*101
    assert_not profile.valid?
  end

  test "bio can't be too long" do
    profile = @janik

    profile.bio = "a"*201
    assert_not profile.valid?
  end
end
