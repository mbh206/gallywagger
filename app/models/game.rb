class Game < ApplicationRecord
  has_many :predictions

  STATUSES = %w[scheduled inprogress completed final].freeze

  # def start_time_in_central
  #   start_time.in_time_zone("America/Chicago")
  # end

  def self.today_games
    where(start_time: Date.current.all_day)
  end

  def update_game_outcome(api_data)
    # Extract the game result status correctly from the API data
    game_result = api_data.dig("boxscore", "form", 0, "events", 0, "gameResult")

    # Determine the new status based on the game result
    new_status = case game_result
    when "W", "L", "D"
                   "completed"  # Adjust status based on the result (Win, Loss, Draw)
    else
                   "inprogress"
    end

    # Update the status of the game
    self.status = new_status

    # Determine the winning team if applicable
    winner_data = game_result
    if winner_data == "W" || winner_data == "L"
      self.winning_team = api_data.dig("boxscore", "form", 0, "team", "displayName")
    elsif winner_data == "D"
      self.winning_team = "Draw"  # Set the winning team to "Draw" if the game ended in a draw
    end

    # Save the updates to the game record
    save!
  rescue StandardError => e
    Rails.logger.error "Failed to update game outcome for game #{id}: #{e.message}"
  end

  def self.map_api_status(api_status)
    case api_status.downcase
    when "scheduled"
      "scheduled"
    when "inprogress", "status_inprogress"
      "inprogress"
    when "completed", "status_final", "final"
      "completed"
    else
      "scheduled" # Default to scheduled if unknown
    end
  end
end
