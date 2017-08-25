FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  sequence :name do |n|
    "Name #{n}"
  end

  factory :user do
    email
    name
    phone Faker::PhoneNumber.phone_number
    password Faker::Internet.password
  end
end