class AddOauthSecretToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :oauth_secret, :string
  end
end
