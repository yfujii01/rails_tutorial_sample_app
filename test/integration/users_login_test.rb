require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
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
end
