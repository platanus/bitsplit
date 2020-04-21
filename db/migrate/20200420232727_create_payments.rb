class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.references :sender, null: false, foreign_key:{ to_table:'users'}
      t.references :receiver, null: false, foreign_key:{ to_table:'users'}
      t.float :amount
      t.datetime :date
      t.integer :state
      t.integer :invoice_id

      t.timestamps
    end
  end
end
