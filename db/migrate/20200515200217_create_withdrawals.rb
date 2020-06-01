class CreateWithdrawals < ActiveRecord::Migration[6.0]
  def change
    create_table :withdrawals do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :satoshis

      t.timestamps
    end
  end
end
