require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do

    # パスワード初期化画面に遷移
    get new_password_reset_path

    # レイアウト確認
    assert_template 'password_resets/new'

    # 無効なメールアドレスを入力してpost
    post password_resets_path, params: { password_reset: { email: "" } }

    # flashに文言が登録されていること
    assert_not flash.empty?

    # レイアウト確認
    assert_template 'password_resets/new'

    # 有効なメールアドレスを入力してpost
    post password_resets_path,
         params: { password_reset: { email: @user.email } }

    # reset_digestが更新されていること
    assert_not_equal @user.reset_digest, @user.reload.reset_digest

    # メールが1通作成されること
    assert_equal 1, ActionMailer::Base.deliveries.size

    # flashに文言が登録されていること
    assert_not flash.empty?

    # rootページに遷移すること
    assert_redirected_to root_url

    # パスワード再設定フォームのテスト
    #
    # 直前に作られたインスタンス変数のユーザー取得
    user = assigns(:user)

    # 無効なメールアドレスのURLを指定してget
    get edit_password_reset_path(user.reset_token, email: "")

    # rootページが表示されること
    assert_redirected_to root_url

    # アクティベートフラグを変更し無効なユーザーにする
    user.toggle!(:activated)

    # メールアドレスもトークンも有効get
    get edit_password_reset_path(user.reset_token, email: user.email)

    # rootページが表示されること
    assert_redirected_to root_url

    # アクティベートフラグを戻す
    user.toggle!(:activated)

    # メールアドレスが有効で、トークンが無効
    get edit_password_reset_path('wrong token', email: user.email)

    # rootページへ
    assert_redirected_to root_url

    # メールアドレスもトークンも有効
    get edit_password_reset_path(user.reset_token, email: user.email)

    # パスワードリセットページが表示されること
    assert_template 'password_resets/edit'

    # emailがhidden項目に設定されていること
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # 無効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }

    # エラーになること
    assert_select 'div#error_explanation'

    # パスワードが空
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }

    # エラーになること
    assert_select 'div#error_explanation'

    # 有効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }

    # ログイン状態になっていること
    assert is_logged_in?

    # flashに文言が登録されていること
    assert_not flash.empty?

    # ユーザーページが表示されること
    assert_redirected_to user
  end
end
