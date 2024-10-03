class CreateSports < ActiveRecord::Migration[7.2]
  def change
    create_table :sports do |t|
      t.string :name
      t.string :abbreviation
      t.string :logo_url

      t.timestamps
    end
  end
end
