# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Sport.destroy_all

sports = [
  { name: 'baseball', abbreviation: 'MLB', logo_url: 'https://a.espncdn.com/i/teamlogos/leagues/500/mlb.png' },
  { name: 'football', abbreviation: 'NFL', logo_url: 'https://a.espncdn.com/i/teamlogos/leagues/500/nfl.png' },
  { name: 'basketball', abbreviation: 'NBA', logo_url: 'https://a.espncdn.com/i/teamlogos/leagues/500/nba.png' },
  { name: 'basketball', abbreviation: 'WNBA', logo_url: 'https://a.espncdn.com/i/teamlogos/leagues/500/wnba.png' },
  { name: 'hockey', abbreviation: 'NHL', logo_url: 'https://a.espncdn.com/i/teamlogos/leagues/500/nhl.png' },
  { name: 'soccer', abbreviation: 'MLS', logo_url: 'https://a.espncdn.com/i/teamlogos/leagues/500/mls.png' },
  { name: 'soccer', abbreviation: 'NWSL', logo_url: 'https://a.espncdn.com/i/leaguelogos/soccer/500/2323.png' },
  { name: 'soccer', abbreviation: 'EPL', logo_url: 'https://a.espncdn.com/i/leaguelogos/soccer/500/23.png' }
]

sports.each do |sport|
  Sport.create!(sport)
end
