class AddCompletedToPayments < ActiveRecord::Migration[6.0]
  def change
    add_column :payments, :completed, :boolean
  end
end
