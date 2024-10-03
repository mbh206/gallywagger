class PredictionsController < ApplicationController
  def index
    @predictions = current_user.predictions
  end

  def submit
    # Ensure params[:games] exists and is not nil
    if params[:games].present?
      params[:games].each do |game_id, prediction_data|
        game = Game.find(game_id)
        prediction = current_user.predictions.find_or_initialize_by(game: game)
        prediction.update(
          predicted_winner: prediction_data[:team],
          confidence_level: prediction_data[:confidence]
        )
      end
      redirect_to root_path, notice: "Predictions submitted successfully!"
    else
      redirect_to root_path, alert: "No games were selected for prediction."
    end
  end
end
