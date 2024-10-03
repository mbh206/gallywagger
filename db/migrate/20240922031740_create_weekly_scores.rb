class CreateWeeklyScores < ActiveRecord::Migration[7.2]
  def change
    create_table :weekly_scores do |t|
      t.references :user, null: false, foreign_key: true
      t.date :week_start
      t.date :week_end
      t.integer :score

      t.timestamps
    end
  end
end
