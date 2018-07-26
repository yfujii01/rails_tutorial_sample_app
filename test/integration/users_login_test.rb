require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @no_activate_user = users(:lana)
  end

  test 'no active user' do

    # ログイン画面へ遷移
    get login_path

    # ログインする(正常)
    post login_path, params: { session: { email: @no_activate_user.email,
                                          password: 'password' } }

    # アクティベートされていないユーザーの場合
    # rootページへリダイレクトされていること
    assert_redirected_to root_url
    follow_redirect!

    # レイアウト確認
    assert_template root_path

    # ログインページヘのリンクがあること
    assert_select 'a[href=?]', login_path

    # ログアウトのリンクが無いこと
    assert_select 'a[href=?]', logout_path, count: 0

    # ユーザーページへのリンクが無いこと
    assert_select 'a[href=?]', user_path(@user), count: 0

    # ユーザー一覧ページへのリンクが無いこと
    assert_select 'a[href=?]', users_path, count: 0
  end

  test 'the truth' do

    # ログイン画面へ遷移
    get login_path

    # レイアウト確認
    assert_template 'sessions/new'

    # ログインする(エラー)(emailとパスワードを空白)
    post login_path, params: { session: { email: '',
                                          password: '' } }

    # ログインページが表示されていること
    assert_template 'sessions/new'

    # フラッシュが空白ではないこと(エラーメッセージが表示されている)
    assert_not flash.empty?
    assert flash[:danger]

    # rootページへ遷移する
    get root_path

    # フラッシュが表示されていないこと(画面遷移でメッセージが消えることの確認)
    assert flash.empty?
    assert_not flash[:danger]
  end

  test 'login with valid information' do
    # ログインページヘ遷移する
    get login_path

    # ログインする(正常)
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }

    # ユーザーページへリダイレクトされていること
    assert_redirected_to @user
    follow_redirect!

    # レイアウト確認
    assert_template 'users/show'

    # ログインが行われてログイン画面へのリンクが無いことの確認
    assert_select 'a[href=?]', login_path, count: 0

    # ログアウトのリンクが存在すること
    assert_select 'a[href=?]', logout_path

    # ユーザーページへのリンクが存在すること
    assert_select 'a[href=?]', user_path(@user)

    # ユーザー一覧ページへのリンクが存在すること
    assert_select 'a[href=?]', users_path
  end

  test 'login with valid information followed by logout' do

    # ログインページヘ遷移
    get login_path

    # ログインする(正常)
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }

    # ログインできていることの確認(sessionに登録できているか)
    assert is_logged_in?

    # ユーザーページへリダイレクトされていることの確認
    assert_redirected_to @user
    follow_redirect!

    # レイアウト確認
    assert_template 'users/show'

    # ログインページヘのリンクが無いこと
    assert_select 'a[href=?]', login_path, count: 0

    # ログアウトリンクがあること
    assert_select 'a[href=?]', logout_path

    # ユーザーページへのリンクがあること
    assert_select 'a[href=?]', user_path(@user)

    # ユーザー一覧ページへのリンクが存在すること
    assert_select 'a[href=?]', users_path

    # ログアウトする
    delete logout_path

    # ログアウトされていること(sessionが削除されていること)
    assert_not is_logged_in?

    # rootページへ遷移すること
    assert_redirected_to root_url

    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!

    # ログインページヘのリンクがあること
    assert_select 'a[href=?]', login_path

    # ログアウトのリンクが無いこと
    assert_select 'a[href=?]', logout_path, count: 0

    # ユーザーページへのリンクが無いこと
    assert_select 'a[href=?]', user_path(@user), count: 0

    # ユーザー一覧ページへのリンクが無いこと
    assert_select 'a[href=?]', users_path, count: 0
  end

  test 'login with remembering' do
    # cookieのremember_tokenに値が設定されていないこと
    assert_nil cookies['remember_token']

    # ログイン状態を記憶してログイン
    log_in_as(@user, remember_me: '1')

    # 直前に作られたインスタンス変数のemailが一致すること
    assert_equal @user.email, assigns(:user).email

    # cookieのremember_tokenに値が設定されていること
    assert_not_empty cookies['remember_token']
  end

  test 'login without remembering' do
    # cookieのremember_tokenに値が設定されていないこと
    assert_nil cookies['remember_token']

    # ログイン状態を記憶してログイン
    log_in_as(@user, remember_me: '1')

    # ログアウトする
    delete logout_path

    # cookieのremember_tokenに値が設定されていないこと
    assert_empty cookies['remember_token']

    # ログイン状態を記憶せずにログイン
    log_in_as(@user, remember_me: '0')

    # cookieのremember_tokenに値が設定されていないこと
    assert_empty cookies['remember_token']
  end
end
