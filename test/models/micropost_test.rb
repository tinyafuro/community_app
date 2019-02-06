require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  # マイクロポストの有効性テスト
  test "should be valid" do
    assert @micropost.valid?
  end

  # user_idの存在性のバリデーションに対するテスト
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  # contentの空データに対するテスト
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  # contentの文字数テスト
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  # マイクロポストの順序づけテスト
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
