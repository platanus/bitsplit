class RemoveStateFromPayments < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_column :payments, :state, :integer }
  end
end
