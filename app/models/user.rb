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
  PORTFOLIO_GUEST_EMAIL = 'portfolio-guest@example.local'

  def folder_distance_km_value
    folder_distance_km.presence || DEFAULT_FOLDER_DISTANCE_KM
  end

  def self.create_guest!
    user = portfolio_guest!
    SamplePortfolioBuilder.new(user).ensure!
    user
  end

  def self.portfolio_guest!
    find_or_create_by!(email: PORTFOLIO_GUEST_EMAIL) do |user|
      user.name = 'Portfolio Guest'
      user.password = SecureRandom.urlsafe_base64(18)
      user.guest = true
    end.tap do |user|
      user.update!(name: 'Portfolio Guest', guest: true) unless user.name == 'Portfolio Guest' && user.guest?
    end
  end
end
