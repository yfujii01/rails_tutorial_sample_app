require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'

    # ヘッダ
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", helf_path
    assert_select "a[href=?]", login_path

    # ボディ
    assert_select "a[href=?]", signup_path

    # フッタ
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  test "login_layout links" do
    log_in_as(@user)

    get root_path
    assert_template 'static_pages/home'

    # ヘッダ
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", helf_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", '#'
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path

    # ボディ
    assert_select "a[href=?]", signup_path

    # フッタ
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

end
