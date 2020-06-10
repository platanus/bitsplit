FactoryBot.define do
  factory :user_deposit do
    user_id { "" }
    amount { "" }
    completed { false }
  end
end
