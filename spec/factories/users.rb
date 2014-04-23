require 'faker'

FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    department
    sequence(:phone, 1000) { |n| "312-555-#{n}" }
    email { Faker::Internet.email }
    start_date { rand(7000).days.ago }
    user_type 0

    factory :user_with_address_and_birthday do
      address { Faker::Address.street_address + "\n" +
          Faker::Address.secondary_address + "\n" +
          Faker::Address.city + ', ' +
          Faker::Address.state_abbr + ' ' +
          Faker::Address.zip_code }
      birthday { rand(9000..24000).days.ago }
    end
  end
end