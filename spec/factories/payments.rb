FactoryBot.define do
  factory :payment do
    sender { nil }
    receiver { nil }
    amount { 1.5 }
    date { "2020-04-20 19:27:27" }
    state { 1 }
    invoice_id { 1 }
  end
end
