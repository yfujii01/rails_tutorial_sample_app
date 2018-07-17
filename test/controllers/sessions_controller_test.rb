require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    # get sessions_new_url
    # get sessions_new_url
    get login_url
    assert_response :success
  end

end
