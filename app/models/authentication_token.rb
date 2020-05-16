class AuthenticationToken < ApplicationRecord
  belongs_to :user
end

# == Schema Information
#
# Table name: authentication_tokens
#
#  id           :bigint(8)        not null, primary key
#  body         :string
#  user_id      :bigint(8)        not null
#  last_used_at :datetime
#  expires_in   :integer
#  ip_address   :string
#  user_agent   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_authentication_tokens_on_body     (body)
#  index_authentication_tokens_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
