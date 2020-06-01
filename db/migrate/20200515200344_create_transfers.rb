class CreateTransfers < ActiveRecord::Migration[6.0]
  def change
    create_table :transfers do |t|
      t.references :sender, null: false, foreign_key: {to_table:'users'}
      t.references :receiver, null: false, foreign_key: {to_table:'users'}
      t.bigint :satoshis

      t.timestamps
    end
  end
end
