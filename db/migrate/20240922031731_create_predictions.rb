class CreatePredictions < ActiveRecord::Migration[7.2]
  def change
    create_table :predictions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.string :predicted_winner
      t.integer :confidence_level

      t.timestamps
    end
  end
end
