class PhotoSession < ApplicationRecord
  CLASSIFICATION_LABELS = {
    'gps' => 'GPS',
    'date' => '日付'
  }.freeze

  belongs_to :user
  has_many :photos, dependent: :nullify

  validates :title, presence: true
  validates :started_at, presence: true
  validates :classification, presence: true

  scope :recent, -> { order(started_at: :desc, created_at: :desc) }
  scope :gps, -> { where(classification: 'gps') }
  scope :with_photo_images, -> { includes(photos: { image_attachment: :blob }) }

  def gps?
    classification == 'gps'
  end

  def date?
    classification == 'date'
  end

  def classification_label
    CLASSIFICATION_LABELS.fetch(classification, classification.to_s)
  end

  def classification_badge_class
    gps? ? 'gps' : 'date'
  end

  def display_latitude
    latitude.presence || first_photo_latitude
  end

  def display_longitude
    longitude.presence || first_photo_longitude
  end

  def display_location?
    display_latitude.present? && display_longitude.present?
  end

  def captured_time_range
    times = photos_for_display_time.filter_map { |photo| photo.captured_at || photo.created_at }
    return [started_at, started_at] if times.empty?

    [times.min, times.max]
  end

  def thumbnail_photo
    return photos.with_attached_image.order(:created_at, :id).first unless photos.loaded?

    photos
      .select { |photo| photo.image.attached? }
      .min_by { |photo| [photo.created_at || Time.zone.at(0), photo.id || 0] }
  end

  private

  def photos_for_display_time
    photos.loaded? ? photos.to_a : photos.select(:captured_at, :created_at)
  end

  def first_photo_with_location
    @first_photo_with_location ||= photos.where.not(latitude: nil, longitude: nil).order(:captured_at, :created_at).first
  end

  def first_photo_latitude
    first_photo_with_location&.latitude
  end

  def first_photo_longitude
    first_photo_with_location&.longitude
  end
end
