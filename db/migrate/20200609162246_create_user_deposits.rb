class CreateUserDeposits < ActiveRecord::Migration[6.0]
  def change
    create_table :user_deposits do |t|
      t.integer, :user_id
      t.float, :amount
      t.boolean :completed

      t.timestamps
    end
  end
end
