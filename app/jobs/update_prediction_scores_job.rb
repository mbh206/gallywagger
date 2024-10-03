class UpdatePredictionScoresJob < ApplicationJob
  queue_as :default

  def perform(game)
    game.predictions.each(&:calculate_score)
  end
end
