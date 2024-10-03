class AddTimeZoneToGames < ActiveRecord::Migration[7.2]
  def change
    add_column :games, :time_zone, :string
  end
end
