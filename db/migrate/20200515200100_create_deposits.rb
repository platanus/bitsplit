class CreateDeposits < ActiveRecord::Migration[6.0]
  def change
    create_table :deposits do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :satoshis

      t.timestamps
    end
  end
end
