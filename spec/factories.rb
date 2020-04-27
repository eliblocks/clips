FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    full_name  { Faker::Name.name }
    password { "password" }
    confirmed_at { Time.new('2019-05-01') }
  end

  factory :video do
    user
  end

  factory :play do
    video
    user
    duration { 10 }
  end
end
