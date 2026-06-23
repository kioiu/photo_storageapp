require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  test 'uses its own location when gps is present' do
    photo = photos(:one)

    assert_equal photo.latitude, photo.display_latitude
    assert_equal photo.longitude, photo.display_longitude
    assert photo.display_location?
    assert_not photo.inherited_session_location?
  end

  test 'uses session location when photo has no gps' do
    photo = photos(:two)
    photo.photo_session.update!(latitude: 36.1, longitude: 140.2, classification: 'gps')
    photo.update_columns(latitude: nil, longitude: nil, has_gps: false)

    assert_equal photo.photo_session.latitude, photo.display_latitude
    assert_equal photo.photo_session.longitude, photo.display_longitude
    assert photo.display_location?
    assert photo.inherited_session_location?
  end

  test 'session uses the first photo location when session location is missing' do
    session = photo_sessions(:two)
    session.update_columns(latitude: nil, longitude: nil)
    photo = photos(:two)
    photo.update_columns(latitude: 36.2, longitude: 140.3, has_gps: true)

    assert_equal photo.latitude, session.display_latitude
    assert_equal photo.longitude, session.display_longitude
    assert session.display_location?
  end

  test 'photo uses another photo location through its session' do
    session = photo_sessions(:two)
    session.update_columns(latitude: nil, longitude: nil)
    source_photo = photos(:one)
    source_photo.update_columns(photo_session_id: session.id, latitude: 36.2, longitude: 140.3, has_gps: true)
    target_photo = photos(:two)
    target_photo.update_columns(latitude: nil, longitude: nil, has_gps: false)

    assert_equal source_photo.latitude, target_photo.display_latitude
    assert_equal source_photo.longitude, target_photo.display_longitude
    assert target_photo.inherited_session_location?
  end
end
