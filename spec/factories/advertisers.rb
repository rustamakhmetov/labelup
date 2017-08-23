FactoryGirl.define do
  sequence :organization do |n|
    "Company #{n}"
  end

  sequence :position do |n|
    "Position #{n}"
  end

  factory :advertiser do
    user
    organization
    position
  end
end
