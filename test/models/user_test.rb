require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_uniqueness_of(:username)
  should validate_presence_of(:username)
  should validate_uniqueness_of(:email)
  should validate_presence_of(:email)
  should validate_presence_of(:password)
  should accept_nested_attributes_for(:profile)
  should have_one(:profile)
  should have_many(:discoveries)
  should have_many(:products)
  should have_many(:parts)
  should have_many(:fitments)
  should have_many(:compatibles).through(:discoveries)
  should have_many(:searches)

  setup do
    @new_user = User.new(username: "Test", email: "test@test.com", password: "password", password_confirmation: "password")
    @janik = users(:janik)
    @hans = users(:hans)
    @sensei = users(:sensei)
  end

  test "fixtures should be valid and correct attributes" do
    assert @janik.valid?
    assert @janik.admin?

    assert @hans.valid?
    assert_not @hans.admin?

    assert @sensei.valid?
    assert @sensei.admin?

    assert_equal User.count, 10
  end

  test "username should be acceptable" do
    user = @new_user

    user.username = nil
    assert_not user.valid? # username needs to be present

    user.username = "Janik"
    assert_not user.valid? # breaks uniqueness

    user.username = "janik"
    assert_not user.valid? # breaks uniquness without case sensitive

    user.username = "jup"
    assert_not user.valid? # username too short

    user.username = "a"*21
    assert_not user.valid? # username too long
  end

  test "password should be acceptable" do
    user = @new_user

    user.password = nil
    user.password_confirmation = nil
    assert_not user.valid?

    user.password = "short"
    user.password_confirmation = "short"
    assert_not user.valid?

    user.password = "password"
    user.password_confirmation = "password_not_equal"
    assert_not user.valid?

    # FIXME this shouldn't be valid ... or should it?
    # user.password = "         g"
    # user.password_confirmation = "         g"
    # assert_not user.valid?
  end

  test "email should be acceptable" do
    user = @new_user

    user.email = nil
    assert_not user.valid? # email needs to be present

    user.email = "janik@thepartsninja.com"
    assert_not user.valid? # email must be unique

    user.email = "test"
    assert_not user.valid? # invalid syntax

    user.email = "test@test"
    assert_not user.valid? # invalid syntax

    user.email = "test@@test.com"
    assert_not user.valid? # invalid syntax

    user.email = "@test.com"
    assert_not user.valid? # invalid syntax

    user.email = "test" + "a"*243 + "@test.com"
    assert_not user.valid? # email too long

    # FIXME is this actually a valid email?
    # user.email = ".@test.com"
    # assert_not user.valid? # invalid syntax
  end

  test "new user role should be set to user" do
    user = @new_user

    assert user.valid?
    user.skip_confirmation!
    user.save

    assert_equal user.role, "user"
    assert_not user.admin?
  end

  test "should build new profile on creation" do
    user = @new_user
    profile_count = Profile.count

    assert user.valid?
    user.skip_confirmation!
    user.save

    assert user.profile
    assert_equal Profile.count, profile_count + 1
  end

end
