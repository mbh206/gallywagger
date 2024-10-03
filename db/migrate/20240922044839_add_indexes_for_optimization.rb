class AddIndexesForOptimization < ActiveRecord::Migration[7.2]
  def change
    add_index :games, :start_time
    add_index :predictions, [ :user_id, :game_id ]
  end
end
