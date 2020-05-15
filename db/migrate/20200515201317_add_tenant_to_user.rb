class AddTenantToUser < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_reference :users, :tenant, index: {algorithm: :concurrently}
  end
end

