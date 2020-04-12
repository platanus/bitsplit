class AddLoggedToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :logged, :bool, default: false
  end
end
