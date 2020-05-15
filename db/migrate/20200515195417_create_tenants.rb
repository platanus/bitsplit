class CreateTenants < ActiveRecord::Migration[6.0]
  def change
    create_table :tenants do |t|
      t.string :name

      t.timestamps
    end

  # Tenant.create(:name => "Bitsplit")

  end
end
