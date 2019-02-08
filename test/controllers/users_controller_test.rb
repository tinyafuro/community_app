require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  # indexアクションのリダイレクトをテスト
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  # editアクションの未ログイン時の保護テスト
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # updateアクションの未ログイン時の保護テスト
  # ログインしていない状態でユーザー情報（名前、メール）を変更しようとしても変更できない
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # 間違ったユーザーがユーザー情報を編集しようとしたとき（GETリクエスト）のテスト
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  # 間違ったユーザーがユーザー情報を編集しようとしたとき（PATCHリクエスト）のテスト
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  # admin属性の変更が禁止されていることをテストする
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              @other_user.password,
                                            password_confirmation: @other_user.password,
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end

  # ログインしていないユーザーはユーザーを削除できないテスト
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  # ログインしていても管理者権限のないユーザーは削除できないテスト
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  # フォローページ表示の際、ログインを求められるテスト
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  # フォロワーページ表示の際、ログインを求められるテスト
  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end

end
