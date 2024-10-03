# app/jobs/fetch_game_data_job.rb
class FetchGameDataJob < ApplicationJob
  queue_as :default

  def perform
    service = GameDataService.new
    %i[mlb nba wnba nfl nhl mls nwsl epl].each do |sport|
      service.fetch_games(sport)
    end
  end
end
