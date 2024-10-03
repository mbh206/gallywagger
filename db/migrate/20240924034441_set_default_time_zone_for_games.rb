class SetDefaultTimeZoneForGames < ActiveRecord::Migration[7.2]
  def change
    Game.update_all(time_zone: 'America/Chicago')
  end
end
