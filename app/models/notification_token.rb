class NotificationToken < ApplicationRecord
  belongs_to :user
  belongs_to :authentication_token
end
