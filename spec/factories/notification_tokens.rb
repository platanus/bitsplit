FactoryBot.define do
  factory :notification_token do
    token { "MyString" }
    user { nil }
  end
end
