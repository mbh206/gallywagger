class CreateSeasonScores < ActiveRecord::Migration[7.2]
  def change
    create_table :season_scores do |t|
      t.references :user, null: false, foreign_key: true
      t.date :season_start
      t.date :season_end
      t.integer :score

      t.timestamps
    end
  end
end
