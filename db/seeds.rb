# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Whitelist countries in redis
good_countries = %w[IT ES UK US]

# Make sure to store the countries in lowercase
good_countries.map!(&:downcase)
RedisStorage.instance.client.call('SADD', 'countries:whitelist', good_countries)

# Create the default ban status
BanStatus.find_or_create_by!(
  name: 'not_banned',
  pretty_name: 'Not banned',
  description: 'User is not banned',
  default: true
)

# Add other ban statuses
BanStatus.find_or_create_by!(
  name: 'banned',
  pretty_name: 'Banned',
  description: 'User is banned'
)