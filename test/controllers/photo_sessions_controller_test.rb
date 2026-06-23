require 'test_helper'

class PhotoSessionsControllerTest < ActionDispatch::IntegrationTest
  test 'redirects guests to login' do
    get photo_sessions_url
    assert_redirected_to login_url
  end
end
