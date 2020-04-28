class AddSplitwiseUserIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :splitwise_user_id, :integer
  end
end
