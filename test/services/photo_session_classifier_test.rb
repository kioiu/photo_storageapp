require 'test_helper'

class PhotoSessionClassifierTest < ActiveSupport::TestCase
  test 'assigns a non gps photo to a gps session in the same time window' do
    user = classifier_user
    gps_session = user.photo_sessions.create!(
      title: 'GPS morning',
      started_at: Time.zone.local(2026, 6, 12, 10, 0, 0),
      latitude: 35.0,
      longitude: 139.0,
      classification: 'gps'
    )
    photo = user.photos.new(
      captured_at: Time.zone.local(2026, 6, 12, 10, 45, 0),
      has_gps: false
    )

    assert_equal gps_session, PhotoSessionClassifier.new(user, photo).call
  end

  test 'uses a provided folder name for a gps session' do
    user = classifier_user
    gps_photo = user.photos.new(
      captured_at: Time.zone.local(2026, 6, 12, 10, 30, 0),
      latitude: 35.0,
      longitude: 139.0,
      has_gps: true
    )

    session = PhotoSessionClassifier.new(user, gps_photo, session_title: '益子 春の撮影').call

    assert_equal '益子 春の撮影', session.title
    assert_equal 'gps', session.classification
  end

  test 'assigns a non gps photo to date session when no gps session is nearby' do
    user = classifier_user
    photo = user.photos.new(
      captured_at: Time.zone.local(2026, 6, 12, 16, 30, 0),
      has_gps: false
    )

    session = PhotoSessionClassifier.new(user, photo).call

    assert_equal 'date', session.classification
    assert_equal Time.zone.local(2026, 6, 12).to_date, session.started_at.to_date
  end

  test 'moves existing non gps photos into a newly created gps session when times match' do
    user = classifier_user
    date_session = user.photo_sessions.create!(
      title: 'Date bucket',
      started_at: Time.zone.local(2026, 6, 12, 0, 0, 0),
      classification: 'date'
    )
    non_gps_photo = user.photos.new(
      photo_session: date_session,
      title: 'Nearby no gps',
      captured_at: Time.zone.local(2026, 6, 12, 11, 15, 0),
      has_gps: false
    )
    non_gps_photo.save!(validate: false)
    gps_photo = user.photos.new(
      captured_at: Time.zone.local(2026, 6, 12, 10, 30, 0),
      latitude: 35.0,
      longitude: 139.0,
      has_gps: true
    )

    gps_session = PhotoSessionClassifier.new(user, gps_photo).call

    assert_equal 'gps', gps_session.classification
    assert_equal gps_session, non_gps_photo.reload.photo_session
    assert_not PhotoSession.exists?(date_session.id)
  end

  test 'assigns a gps photo to an existing gps session within three kilometers' do
    user = classifier_user
    gps_session = user.photo_sessions.create!(
      title: 'Near GPS folder',
      started_at: Time.zone.local(2026, 6, 12, 10, 0, 0),
      latitude: 35.6812,
      longitude: 139.7671,
      classification: 'gps'
    )
    gps_photo = user.photos.new(
      captured_at: Time.zone.local(2026, 6, 12, 10, 30, 0),
      latitude: 35.6900,
      longitude: 139.7700,
      has_gps: true
    )

    assert_equal gps_session, PhotoSessionClassifier.new(user, gps_photo).call
  end

  test 'creates a new gps session when a gps photo is more than three kilometers away' do
    user = classifier_user
    gps_session = user.photo_sessions.create!(
      title: 'Far GPS folder',
      started_at: Time.zone.local(2026, 6, 12, 10, 0, 0),
      latitude: 35.6812,
      longitude: 139.7671,
      classification: 'gps'
    )
    gps_photo = user.photos.new(
      captured_at: Time.zone.local(2026, 6, 12, 10, 30, 0),
      latitude: 35.7300,
      longitude: 139.8200,
      has_gps: true
    )

    new_session = PhotoSessionClassifier.new(user, gps_photo).call

    assert_not_equal gps_session, new_session
    assert new_session.persisted?
    assert_equal 'gps', new_session.classification
    assert_equal gps_photo.latitude, new_session.latitude
    assert_equal gps_photo.longitude, new_session.longitude
  end

  test 'uses the user configured distance for gps folder assignment' do
    user = classifier_user
    user.update!(folder_distance_km: 8.0)
    gps_session = user.photo_sessions.create!(
      title: 'Custom distance folder',
      started_at: Time.zone.local(2026, 6, 12, 10, 0, 0),
      latitude: 35.6812,
      longitude: 139.7671,
      classification: 'gps'
    )
    gps_photo = user.photos.new(
      captured_at: Time.zone.local(2026, 6, 12, 10, 30, 0),
      latitude: 35.7300,
      longitude: 139.8200,
      has_gps: true
    )

    assert_equal gps_session, PhotoSessionClassifier.new(user, gps_photo).call
  end

  private

  def classifier_user
    User.create!(name: 'Classifier User', email: "classifier-#{SecureRandom.hex(8)}@example.com", password: 'password')
  end
end
