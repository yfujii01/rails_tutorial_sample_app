require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @admin = users(:michael)
    @non_admin = users(:archer)
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

      # アクティベートされている場合だけ表示する
      if user.activated?
        # ユーザーページへのリンク確認
        assert_select 'a[href=?]', user_path(user), text: user.name
      else
        # 非アクティベートユーザーへのリンクが存在しないこと
        assert_select 'a[href=?]', user_path(user), count: 0
      end
    end
  end

  test "index as admin including pagination and delete links" do
    # 管理者ユーザーでログイン
    log_in_as(@admin)

    # ユーザー一覧ページへ遷移
    get users_path

    # レイアウト確認
    assert_template 'users/index'
    assert_select 'div.pagination'

    # DBから1ページ分のユーザー情報取得
    first_page_of_users = User.paginate(page: 1)

    # ユーザー数分繰り返し
    first_page_of_users.each do |user|

      # ユーザーがアクティベートされているか確認
      if user.activated?

        # ユーザーページへの遷移リンク確認
        assert_select 'a[href=?]', user_path(user), text: user.name

        # 表示ユーザーがログインしたユーザー自身ではない場合
        unless user == @admin
          # 表示ユーザーのdeleteリンク確認
          assert_select 'a[href=?]', user_path(user), text: 'delete'
        end

      else

        # 非アクティベートユーザーへのリンクが存在しないこと
        assert_select 'a[href=?]', user_path(user), count: 0

      end
    end

    # DBから削除されることの確認
    assert_difference 'User.count', -1 do

      # ユーザーを一人deleteリンクから削除
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do

    # 非管理者ユーザーでログイン
    log_in_as(@non_admin)

    # ユーザー一覧ページへ遷移
    get users_path

    # deleteリンクが存在しないこと
    assert_select 'a', text: 'delete', count: 0
  end

end