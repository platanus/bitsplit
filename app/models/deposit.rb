class Deposit < ApplicationRecord
  include LedgerizerDocument
  belongs_to :user

  def satoshis_in_deposit
    Money.from_amount(self[:satoshis], 'SAT')
  end
end
