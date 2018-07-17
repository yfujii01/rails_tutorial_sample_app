require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'the truth' do
    get login_path

    assert_template 'sessions/new'

    post login_path, params: { session: { email: '',
                                          password: '' } }

    assert_template 'sessions/new'

    assert_not flash.empty?
    assert flash[:danger]

    get root_path

    assert flash.empty?
    assert_not flash[:danger]
  end

  test 'login with valid information' do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }

    assert_redirected_to @user
    # ユーザーページへリダイレクト
    follow_redirect!

    # レイアウト確認
    assert_template 'users/show'

    # ログインが行われてログイン画面へのリンクが無いことの確認
    assert_select 'a[href=?]', login_path, count: 0

    # ログアウトのリンクが存在すること
    assert_select 'a[href=?]', logout_path

    # ユーザーページへのリンクが存在すること
    assert_select 'a[href=?]', user_path(@user)
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url

    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path

    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

end
