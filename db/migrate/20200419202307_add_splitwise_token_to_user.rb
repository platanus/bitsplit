class AddSplitwiseTokenToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :splitwise_token, :string
  end
end
