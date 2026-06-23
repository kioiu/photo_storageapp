require 'test_helper'

class SettingsControllerTest < ActionDispatch::IntegrationTest
  test 'redirects guests to login' do
    get edit_settings_url

    assert_redirected_to login_url
  end

  test 'renders settings page' do
    post guest_login_url
    get edit_settings_url

    assert_response :success
    assert_includes response.body, 'フォルダ分け距離'
    assert_includes response.body, 'name="user[folder_distance_km]"'
  end

  test 'updates folder distance setting' do
    post guest_login_url
    user = User.order(:created_at).last

    patch settings_url, params: { user: { folder_distance_km: 5.5 } }

    assert_redirected_to edit_settings_url
    assert_equal 5.5, user.reload.folder_distance_km.to_f
  end

  test 'rejects invalid folder distance setting' do
    post guest_login_url
    user = User.order(:created_at).last

    patch settings_url, params: { user: { folder_distance_km: 0 } }

    assert_response :unprocessable_entity
    assert_equal 3.0, user.reload.folder_distance_km.to_f
  end
end
