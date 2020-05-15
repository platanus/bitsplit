class Tenant < ApplicationRecord
    include LedgerizerTenant

    def vault_account
        accounts.find_by(name: :vault)
    end
end
