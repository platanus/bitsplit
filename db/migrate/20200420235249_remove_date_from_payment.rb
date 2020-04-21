class RemoveDateFromPayment < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_column :payments, :date, :datetime }
  end
end
