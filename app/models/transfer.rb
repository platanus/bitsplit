class Transfer < ApplicationRecord
  include LedgerizerDocument
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  def satoshis_in_transfer
    Money.from_amount(self[:satoshis], 'SAT')
  end
end
