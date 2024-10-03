class UpdateGameStatusJob < ApplicationJob
  queue_as :default

  def perform
    Game.where(status: "inprogress").each do |game|
      api_data = fetch_game_from_api(game)
      game.update_game_outcome(api_data) if api_data.present?
    end
  end

  private

  def fetch_game_from_api(game)
    Rails.logger.info "Game: #{game}"
    Rails.logger.info "This should be the sport abbreviation ... #{game.sport} ..."
    game_sport = case game.sport
    when "NFL" then "football/nfl"
    when "MLB" then "baseball/mlb"
    when "NHL" then "hockey/nhl"
    when "WNBA" then "basketball/wnba"
    when "NBA" then "basketball/nba"
    when "MLS" then "soccer/usa.1"
    when "NWSL" then "soccer/usa.nwsl"
    when "EPL" then "soccer/eng.1"
    else game.sport.downcase
    end

    Rails.logger.info "This should be the sport type ... #{game_sport} ..."
    # add api call logic
    # https://site.api.espn.com/apis/site/v2/sports/football/nfl/summary?event=
    url = URI("https://site.api.espn.com/apis/site/v2/sports/#{game_sport}/summary?event=#{game.id}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)

    Rails.logger.info "Fetching game data for #{game.id} from URL: #{url}"

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      body = response.body.force_encoding("UTF-8")
      Rails.logger.info "Successfully fetched data for game #{game.id}"
      JSON.parse(body)
    else
      Rails.logger.error "Failed to fetch data for game #{game.id}: #{response.message}"
      nil
    end
  rescue StandardError => e
    Rails.logger.error "Error fetching data for game #{game.id}: #{e.message}"
    nil
  end
end
