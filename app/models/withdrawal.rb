class Withdrawal < ApplicationRecord
  include LedgerizerDocument
  belongs_to :user

  def satoshis_in_withdrawal
    Money.from_amount(self[:satoshis], 'SAT')
  end
end
