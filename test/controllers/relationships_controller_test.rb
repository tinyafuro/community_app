require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest

  # following、followersアクションに対するテスト

  # POSTリクエスト時にログインしていることを確認するテスト
  test "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to login_url
  end

  # DESTROYリクエスト時にログインしていることを確認するテスト
  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_url
  end

end
