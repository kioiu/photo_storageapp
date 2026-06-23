require 'test_helper'

class PhotosControllerTest < ActionDispatch::IntegrationTest
  test 'redirects guests to login' do
    get photos_url
    assert_redirected_to login_url
  end

  test 'shows folders on index' do
    post guest_login_url
    user = User.order(:created_at).last
    session = user.photo_sessions.create!(
      title: 'テストフォルダ',
      started_at: Time.zone.local(2026, 6, 22, 10, 0, 0),
      classification: 'gps'
    )
    user.photos.create!(
      photo_session: session,
      title: 'first',
      captured_at: Time.zone.local(2026, 6, 22, 10, 15, 0),
      has_gps: false
    ) { |photo| photo.image.attach(fixture_file_upload('sample.jpg', 'image/jpeg')) }
    user.photos.create!(
      photo_session: session,
      title: 'last',
      captured_at: Time.zone.local(2026, 6, 22, 12, 45, 0),
      has_gps: false
    ) { |photo| photo.image.attach(fixture_file_upload('sample.jpg', 'image/jpeg')) }

    get photos_url

    assert_response :success
    assert_includes response.body, 'フォルダ一覧'
    assert_includes response.body, 'folder-list'
    assert_includes response.body, 'サムネイル'
    assert_includes response.body, 'テストフォルダ'
    assert_includes response.body, '2026-06-22 10:15 JST 〜 2026-06-22 12:45 JST'
  end

  test 'uploads a photo and classifies it by date when gps is missing' do
    post guest_login_url
    assert_difference -> { Photo.count }, 1 do
      assert_difference -> { PhotoSession.count }, 1 do
        post photos_url, params: {
          images: [fixture_file_upload('sample.jpg', 'image/jpeg')]
        }
      end
    end

    photo = Photo.order(:created_at).last
    assert_redirected_to photos_url
    assert photo.image.attached?
    assert_equal false, photo.has_gps?
    assert_equal 'date', photo.photo_session.classification
  end

  test 'uploads multiple photos at once' do
    post guest_login_url

    assert_difference -> { Photo.count }, 2 do
      post photos_url, params: {
        images: [
          fixture_file_upload('sample.jpg', 'image/jpeg'),
          fixture_file_upload('sample.jpg', 'image/jpeg')
        ]
      }
    end

    assert_redirected_to photos_url
    assert_equal '2枚の写真を追加しました', flash[:notice]
    assert Photo.order(:created_at).last(2).all? { |photo| photo.image.attached? }
  end

  test 'upload form allows selecting multiple image files' do
    post guest_login_url
    get new_photo_url

    assert_response :success
    assert_includes response.body, 'name="images[]"'
    assert_includes response.body, 'multiple="multiple"'
    assert_includes response.body, '複数枚まとめて選択できます'
  end

  test 'destroys a photo and removes its empty session' do
    post guest_login_url
    post photos_url, params: {
      images: [fixture_file_upload('sample.jpg', 'image/jpeg')]
    }
    photo = Photo.order(:created_at).last
    photo_session = photo.photo_session
    blob = photo.image.blob

    assert_difference -> { Photo.count }, -1 do
      assert_difference -> { PhotoSession.count }, -1 do
        delete photo_url(photo)
      end
    end

    assert_redirected_to photos_url
    assert_not ActiveStorage::Blob.exists?(blob.id)
    assert_not PhotoSession.exists?(photo_session.id)
  end
end
