class GamesController < ApplicationController
  before_action :authenticate_user!
  # before_action :update_game_statuses
  def index
    @sports = Sport.all
    @current_sport = params[:sport] || @sports.first&.abbreviation
    @games = Game.today_games.where(sport: @current_sport) if @current_sport
    @weekly_score = current_user.latest_weekly_score
    @season_score = current_user.latest_season_score
    @lifetime_score = current_user.lifetime_score
  end

  def update_game_statuses
    # This will update the status of all games that should be in progress
    Game.where(status: "scheduled").where("start_time <= ?", Time.current).update_all(status: "inprogress")
    head :ok
  end

  def update_statuses
    # Logic to update statuses of games
    Game.where(status: "scheduled").where("start_time <= ?", Time.current).update_all(status: "inprogress")
    render json: { message: "Statuses updated" }
  end

  def select_team
    respond_to do |format|
      format.html { redirect_to games_path, notice: "Team selected." }
      format.js
      format.json { render json: { message: "Team selected successfully" }, status: :ok }
    end
  rescue StandardError => e

    respond_to do |format|
      format.html { redirect_to games_path, alert: "Error selecting team." }
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  end
end
