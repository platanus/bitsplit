class AddTenantToTenants < ActiveRecord::Migration[6.0]
  def up
    if !Tenant.exists?(1)
      Tenant.create(:name => "Bitsplit")
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
