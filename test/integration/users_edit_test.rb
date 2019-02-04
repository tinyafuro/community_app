require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  # 編集の失敗に対するテスト
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:                  "", 
                                              email:                 "", 
                                              password:              "foo", 
                                              password_confirmation: "bar"}}
    assert_template 'users/edit'
    assert_select "div.alert", "The form contains 5 errors."
  end

  # # 編集の成功に対するテスト
  # test "successful edit" do
  #   log_in_as(@user)
  #   get edit_user_path(@user)
  #   assert_template 'users/edit'
  #   name  = "Foo Bar"
  #   email = "foo@bar.com"
  #   patch user_path(@user), params: { user: { name:  name,
  #                                             email: email,
  #                                             password:              "",
  #                                             password_confirmation: "" } }
  #   assert_not flash.empty?
  #   assert_redirected_to @user
  #   @user.reload
  #   assert_equal name,  @user.name
  #   assert_equal email, @user.email
  # end

  # フレンドリーフォワーディングのテスト
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], edit_user_url(@user) # <-追加
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    assert_nil session[:forwarding_url] # <-追加
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

end
