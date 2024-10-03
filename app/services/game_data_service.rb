require "net/http"
require "json"

class GameDataService
  API_ENDPOINTS = {
    mlb: "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard?limit=1000",
    nfl: "https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard?limit=1000&dates=#{Date.current.year}0801-#{Date.current.year + 1}0301",
    nhl: "https://site.api.espn.com/apis/site/v2/sports/hockey/nhl/scoreboard?limit=1000&dates=#{Date.current.year}1001-#{Date.current.year + 1}0501",
    nba: "https://site.api.espn.com/apis/site/v2/sports/basketball/nba/scoreboard?limit=1000&dates=#{Date.current.year}1001-#{Date.current.year + 1}0601",
    wnba: "https://site.api.espn.com/apis/site/v2/sports/basketball/wnba/scoreboard?limit=1000&dates=#{Date.current.year}1001-#{Date.current.year + 1}0601",
    mls: "https://site.api.espn.com/apis/site/v2/sports/soccer/usa.1/scoreboard?limit=1000&dates=#{Date.current.year}",
    nwsl: "https://site.api.espn.com/apis/site/v2/sports/soccer/usa.nwsl/scoreboard?limit=1000&dates=#{Date.current.year}",
    epl: "https://site.api.espn.com/apis/site/v2/sports/soccer/eng.1/scoreboard?limit=1000&dates=#{Date.current.year}0801-#{Date.current.year + 1}0601"
  }

  # Main entry point for fetching and updating games for a specific sport
  def self.fetch_and_update_games(sport)
    service = new # Create an instance of GameDataService
    service.fetch_games(sport) # Fetch games based on sport
  end

  # Fetch games based on sport, with special handling for MLB
  def fetch_games(sport)
    if sport == :mlb
      fetch_mlb_games
    else
      url = URI(API_ENDPOINTS[sport])
      response = make_api_call(url)
      update_games(response, sport) if response
    end
  end

  private

  # Fetch MLB games in monthly batches to avoid API limit issues
  def fetch_mlb_games
    current_year = Date.current.year
    date_ranges = [
      "&dates=#{current_year}0201-#{current_year}0229", # February
      "&dates=#{current_year}0301-#{current_year}0331", # March
      "&dates=#{current_year}0401-#{current_year}0430", # April
      "&dates=#{current_year}0501-#{current_year}0531", # May
      "&dates=#{current_year}0601-#{current_year}0630", # June
      "&dates=#{current_year}0701-#{current_year}0731", # July
      "&dates=#{current_year}0801-#{current_year}0831", # August
      "&dates=#{current_year}0901-#{current_year}0930", # September
      "&dates=#{current_year}1001-#{current_year}1031"  # October
    ]

    date_ranges.each do |dates|
      url = "#{API_ENDPOINTS[:mlb]}&dates=#{dates}"
      response = make_api_call(URI.parse(url))
      update_games(response, :mlb) if response
    end
  end

  # Make an API call and parse the JSON response
  def make_api_call(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)

    response = http.request(request)
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  rescue StandardError => e
    Rails.logger.error "Failed to fetch data from API: #{e.message}"
    nil
  end

  # Update games in the database based on fetched data
  def update_games(data, sport)
    unless data && data["events"].is_a?(Array)
      Rails.logger.error "Unexpected response structure or missing 'events': #{data.inspect}"
      return
    end

    data["events"].each do |game_data|
      game = ::Game.find_or_initialize_by(id: game_data["id"])
      api_status = game_data.dig("status", "type", "description") || "scheduled"
      mapped_status = Game.map_api_status(api_status)

      if game.new_record?
        game.assign_attributes(
          home_team: game_data.dig("competitions", 0, "competitors", 0, "team", "displayName"),
          away_team: game_data.dig("competitions", 0, "competitors", 1, "team", "displayName"),
          start_time: game_data["date"],
          status: mapped_status,
          winning_team: game_data.dig("competitions", 0, "competitors").find { |team| team["winner"] }&.dig("team", "displayName"),
          sport: sport.to_s.upcase
        )
        game.save!
      else
        if game.status != mapped_status
          game.update(status: mapped_status)
          Rails.logger.info "Updated status of game #{game.id}: #{game.status}"
        end
      end

      trigger_prediction_updates(game) if game.status == "completed" || game.status == "final"
    end
  end

  # Trigger prediction updates after game completion
  def trigger_prediction_updates(game)
    UpdatePredictionScoresJob.perform_later(game)
  end
end
