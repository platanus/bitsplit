class AddAuthenticationTokenToNotificationToken < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_reference :notification_tokens, :authentication_token, null: false, foreign_key: true, index: {algorithm: :concurrently}
  end
end
