require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: users(:michael).id,
                                     followed_id: users(:archer).id)
  end

  test "should b valide" do
    assert @relationship.valid?
  end

  test "should require a folower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a folowed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
