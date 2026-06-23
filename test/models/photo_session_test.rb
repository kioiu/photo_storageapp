require 'test_helper'

class PhotoSessionTest < ActiveSupport::TestCase
  test 'thumbnail photo is the first uploaded photo in the session' do
    session = photo_sessions(:one)
    first = photos(:one)
    second = photos(:two)
    first.update_columns(photo_session_id: session.id, created_at: 2.days.ago)
    second.update_columns(photo_session_id: session.id, created_at: 1.day.ago)

    assert_equal first, session.thumbnail_photo
  end
  test 'captured time range uses first and last photo capture times' do
    session = photo_sessions(:one)
    first = photos(:one)
    second = photos(:two)
    first.update_columns(photo_session_id: session.id, captured_at: Time.zone.local(2026, 6, 23, 9, 15, 0))
    second.update_columns(photo_session_id: session.id, captured_at: Time.zone.local(2026, 6, 23, 11, 45, 0))

    assert_equal [first.reload.captured_at, second.reload.captured_at], session.captured_time_range
  end

  test 'captured time range falls back to session start when there are no photos' do
    session = photo_sessions(:one)
    session.photos.update_all(photo_session_id: photo_sessions(:two).id)

    assert_equal [session.started_at, session.started_at], session.captured_time_range
  end

  test 'classification label and badge class are display friendly' do
    gps_session = photo_sessions(:one)
    date_session = photo_sessions(:two)

    gps_session.update!(classification: 'gps')
    date_session.update!(classification: 'date')

    assert_equal 'GPS', gps_session.classification_label
    assert_equal 'gps', gps_session.classification_badge_class
    assert_equal '日付', date_session.classification_label
    assert_equal 'date', date_session.classification_badge_class
  end

end
