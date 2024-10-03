class RankingsController < ApplicationController
  def index
    @weekly_rankings = User.weekly_rankings
    @season_rankings = User.season_rankings
    @lifetime_rankings = User.lifetime_rankings
  end
end
