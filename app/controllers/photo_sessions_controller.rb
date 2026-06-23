class PhotoSessionsController < ApplicationController
  before_action :require_login

  def index
    @photo_sessions = current_user.photo_sessions.with_photo_images.recent
  end

  def show
    @photo_session = current_user.photo_sessions.find(params[:id])
    @photos = @photo_session.photos.with_attached_image.recent
  end
end
