FactoryBot.define do
  factory :user_withdrawal do
    user_id { 1 }
    amount { 1.5 }
    completed { false }
    invoice { "MyString" }
  end
end
