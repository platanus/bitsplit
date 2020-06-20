class CreateUserWithdrawals < ActiveRecord::Migration[6.0]
  def change
    create_table :user_withdrawals do |t|
      t.integer :user_id
      t.float :amount
      t.boolean :completed
      t.string :invoice

      t.timestamps
    end
  end
end
