require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'new user page renders' do
    get new_user_url
    assert_response :success
  end
end
