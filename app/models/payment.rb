class Payment < ApplicationRecord
  belongs_to :sender, :class_name => 'User'
  belongs_to :receiver, :class_name => 'User'
  self.ignored_columns = ["date"]


end

# == Schema Information
#
# Table name: payments
#
#  id          :bigint(8)        not null, primary key
#  sender_id   :bigint(8)        not null
#  receiver_id :bigint(8)        not null
#  amount      :float
#  state       :integer
#  invoice_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_payments_on_receiver_id  (receiver_id)
#  index_payments_on_sender_id    (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (receiver_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
