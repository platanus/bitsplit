class RemoveAuthenticationTokenFromUsers < ActiveRecord::Migration[6.0]
  def change

    safety_assured { remove_column :users, :authentication_token, :string }
  end
end
