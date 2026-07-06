# Idempotent portfolio sample data. Safe to run in development or production:
#   bin/rails db:seed

guest = User.portfolio_guest!
SamplePortfolioBuilder.new(guest).ensure!

puts "Seeded #{guest.photo_sessions.count} sample folders and #{guest.photos.count} sample photos for #{guest.email}"
