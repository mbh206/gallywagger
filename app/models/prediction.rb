class Prediction < ApplicationRecord
  belongs_to :user
  belongs_to :game

  CONFIDENCE_GAINS = { guessing: 1, hopeful: 2, certain: 3 }
  CONFIDENCE_LOSSES = { guessing: 0, hopeful: -2, certain: -4 }

  def calculate_score
    if game.completed? && game.winning_team == predicted_winner
      self.points_awarded = CONFIDENCE_GAINS[confidence_level.to_sym]
    else
      self.points_awarded = CONFIDENCE_LOSSES[confidence_level.to_sym]
    end
    save
  end
end
