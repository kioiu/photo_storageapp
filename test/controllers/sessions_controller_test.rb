require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'login page renders' do
    get login_url
    assert_response :success
  end

  test 'guest login prepares sample portfolio data without duplicates' do
    post guest_login_url
    assert_redirected_to photos_url

    guest = User.find_by!(email: User::PORTFOLIO_GUEST_EMAIL)
    assert_equal 5, guest.photo_sessions.count
    assert_equal 5, guest.photos.count
    assert guest.photos.all? { |photo| photo.image.attached? }

    post logout_url
    post guest_login_url

    guest.reload
    assert_equal 5, guest.photo_sessions.count
    assert_equal 5, guest.photos.count
  end
end
