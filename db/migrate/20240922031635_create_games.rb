class CreateGames < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.string :home_team
      t.string :away_team
      t.datetime :game_date
      t.string :sport
      t.string :status

      t.timestamps
    end
  end
end
