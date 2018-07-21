require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "index including pagination" do
    # ログイン
    log_in_as(@user)

    # ユーザー一覧ページを表示
    get users_path

    # 要素確認
    assert_template 'users/index'
    assert_select 'div.pagination'

    # ページネーション確認
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end
end