FactoryGirl.define do
  factory :ticket do
    association :event
    price { Faker::Number.decimal(2) }
    quantity { Faker::Number.between(1, 10) }
    source { Faker::Lorem.word }
  end
end
