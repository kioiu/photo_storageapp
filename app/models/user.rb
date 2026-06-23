class User < ApplicationRecord
  has_secure_password

  has_many :photos, dependent: :destroy
  has_many :photo_sessions, dependent: :destroy

  normalizes :email, with: ->(email) { email.to_s.strip.downcase }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :folder_distance_km, numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  DEFAULT_FOLDER_DISTANCE_KM = 3.0

  def folder_distance_km_value
    folder_distance_km.presence || DEFAULT_FOLDER_DISTANCE_KM
  end

  def self.create_guest!
    timestamp = Time.current.to_i

    create!(
      name: 'Guest',
      email: "guest-#{timestamp}-#{SecureRandom.hex(4)}@example.local",
      password: SecureRandom.urlsafe_base64(18),
      guest: true
    )
  end
end
