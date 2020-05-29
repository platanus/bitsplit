class CreateTenants < ActiveRecord::Migration[6.0]
  def change
    create_table :tenants do |t|
      t.string :name
      t.timestamps
    end
    if !Tenant.exists?(1)
      Tenant.create(:name => "Bitsplit")
    end
  end
end
