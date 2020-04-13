class AddApiSecretToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :api_secret, :string
  end
end
