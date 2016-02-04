FactoryGirl.define do
  factory :brand do
    name        'Acerbis'
    website     'www.acerbis.com'

    trait :yamaha do
      name      'Yamaha'
      website   'www.yamaha.com'
    end

    trait :random do
      name      { Faker::Company.name }
      website   { Faker::Internet.url }
    end
  end
end