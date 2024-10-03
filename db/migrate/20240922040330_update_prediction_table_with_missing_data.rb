class UpdatePredictionTableWithMissingData < ActiveRecord::Migration[7.2]
  def change
    change_column :predictions, :confidence_level, :string
    add_column :predictions, :points_awarded, :integer
  end
end
