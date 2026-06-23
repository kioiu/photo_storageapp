require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'login page renders' do
    get login_url
    assert_response :success
  end
end
