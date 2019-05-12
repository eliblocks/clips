FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    full_name  { Faker::Name.name }
    password { "mygh554d" }
    confirmed_at { Time.new('2019-05-01') }
  end

  factory :account do
    user
    balance { 5000 }
  end

  factory :video do
    account
  end

  factory :play do
    video
    account
    duration { 10 }
  end
end
