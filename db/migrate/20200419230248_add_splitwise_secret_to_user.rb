class AddSplitwiseSecretToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :splitwise_secret, :string
  end
end
