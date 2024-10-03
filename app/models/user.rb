class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :predictions
  has_one :score, class_name: "Score"
  has_many :weekly_scores
  has_many :season_scores

  # Fetch the most recent weekly score
  def latest_weekly_score
    weekly_scores.order("week_end DESC").first&.score || 0
  end

  # Fetch the most recent season score
  def latest_season_score
    season_scores.order("season_end DESC").first&.score || 0
  end

  # Fetch the total lifetime score
  def lifetime_score
    score&.total_score
  end

  def predicted?(game)
    predictions.exists?(game_id: game.id)
  end

  # Fetch the user's prediction for a given game
  def prediction_for(game)
    predictions.find_by(game_id: game.id)&.predicted_winner
  end

  def confidence_for(game)
    predictions.find_by(game_id: game.id)&.confidence_level
  end

  # Fetch weekly rankings
  def self.weekly_rankings
    select("users.*, MAX(weekly_scores.score) AS weekly_score")
      .joins(:weekly_scores)
      .group("users.id")
      .order("weekly_score DESC")
  end

  # Fetch season rankings
  def self.season_rankings
    select("users.*, MAX(season_scores.score) AS season_score")
      .joins(:season_scores)
      .group("users.id")
      .order("season_score DESC")
  end

  # Fetch lifetime rankings
  def self.lifetime_rankings
    select("users.*, COALESCE(MAX(scores.total_score), 0) AS lifetime_score")
      .left_joins(:score)
      .group("users.id")
      .order("lifetime_score DESC")
  end

  # Highlight current user in rankings
  def highlight_current_user?(current_user)
    self == current_user
  end
end
