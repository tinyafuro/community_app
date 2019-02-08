require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: users(:michael).id,
                                     followed_id: users(:archer).id)
  end

  # Relationshipモデルの有効性テスト
  test "should be valid" do
    assert @relationship.valid?
  end

  # Relationshipのfollower_id有効性テスト
  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  # Relationshipのfollowed_id有効性テスト
  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
