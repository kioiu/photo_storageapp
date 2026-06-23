class PhotosController < ApplicationController
  before_action :require_login
  before_action :set_photo, only: %i[show destroy]

  def index
    @photo_sessions = current_user.photo_sessions.with_photo_images.recent
  end

  def new
    @photo = current_user.photos.new
  end

  def create
    images = Array(params[:images]).reject(&:blank?)

    if images.empty?
      redirect_to new_photo_path, alert: '写真を選んでください'
      return
    end

    created = create_photos_from(images)
    redirect_to photos_path, notice: "#{created.size}枚の写真を追加しました"
  rescue ActiveRecord::RecordInvalid => error
    redirect_to new_photo_path, alert: error.record.errors.full_messages.to_sentence
  end

  def show
  end

  def destroy
    photo_session = @photo.photo_session
    @photo.image.purge if @photo.image.attached?
    @photo.destroy!
    photo_session.destroy! if photo_session.photos.reload.empty?

    redirect_to photos_path, notice: '写真を削除しました', status: :see_other
  end

  private

  def set_photo
    @photo = current_user.photos.with_attached_image.find(params[:id])
  end

  def create_photos_from(images)
    prepared_photos = images.map { |image| build_photo_from(image) }
    gps_photos, non_gps_photos = prepared_photos.partition(&:has_gps?)

    (gps_photos + non_gps_photos).each do |photo|
      photo.photo_session = PhotoSessionClassifier.new(current_user, photo, session_title: params[:photo_session_title]).call
      photo.save!
    end
  end

  def build_photo_from(image)
    photo = current_user.photos.new
    photo.image.attach(image)
    PhotoMetadataExtractor.new(photo, image).apply!
    photo
  end
end
