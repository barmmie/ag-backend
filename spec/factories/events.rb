FactoryGirl.define do
  factory :event do
    title Faker::Lorem.sentence
    artist Faker::Name.name
  end
end
