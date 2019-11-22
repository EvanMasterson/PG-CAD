require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not save a user when password does not meet requirements" do
    user = User.new(email: "email@email.com", password: "password")
    assert_equal(false, user.save)
  end

  test "should save a user when password does meet requirements" do
    user = User.new(email: "email@email.com", password: "P@ssword1!")
    assert_equal(true, user.save)
  end
end
