require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    user_id_list = User.group(:id).pluck(:id)
    @user2 = User.find(user_id_list[20])
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'

    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select '#following', text: "2"
    assert_select '#followers', text: "2"
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end

    # フォローのカウント数表示が正しいかチェック
    @user.follow(@user2)
    assert_select '#following', text: "2"
    assert_select '#followers', text: "2"
    get user_path(@user)
    assert_select '#following', text: "3"
    assert_select '#followers', text: "2"

    @user2.follow(@user)
    assert_select '#following', text: "3"
    assert_select '#followers', text: "2"
    get user_path(@user)
    assert_select '#following', text: "3"
    assert_select '#followers', text: "3"
  end
end
