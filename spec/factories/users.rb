require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.department_id 1
    f.phone '312-555-1212'
    f.email { Faker::Internet.email }
    f.address { Faker::Address.street_address + "\n" +
                Faker::Address.secondary_address + "\n" +
                Faker::Address.city + ', ' +
                Faker::Address.state_abbr + ' ' +
                Faker::Address.zip_code }
    f.start_date { rand(7000).days.ago }
    f.birthday { rand(9000..24000).days.ago }
    f.user_type 0
  end
end