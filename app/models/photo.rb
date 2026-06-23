class Photo < ApplicationRecord
  belongs_to :user
  belongs_to :photo_session
  has_one_attached :image

  validates :image, presence: true

  scope :recent, -> { order(captured_at: :desc, created_at: :desc) }

  def gps?
    has_gps?
  end

  def display_title
    title.presence || image.filename.to_s
  end

  def captured_on
    (captured_at || created_at).to_date
  end

  def display_latitude
    latitude.presence || photo_session&.display_latitude
  end

  def display_longitude
    longitude.presence || photo_session&.display_longitude
  end

  def display_location?
    display_latitude.present? && display_longitude.present?
  end

  def inherited_session_location?
    !has_gps? && display_location?
  end
end
