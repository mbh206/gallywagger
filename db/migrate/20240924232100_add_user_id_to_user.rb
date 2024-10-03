class AddUserIdToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :user_id, :bigint
  end
end
