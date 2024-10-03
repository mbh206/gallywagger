class UpdateGameTableWithMissingData < ActiveRecord::Migration[7.2]
  def change
    add_column :games, :winning_team, :string
    rename_column :games, :game_date, :start_time
  end
end
