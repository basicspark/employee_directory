# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :department do
    sequence(:name) { |n| "Department-#{n}" }
    location { Faker::Address.city }

    factory :department_with_phone do
      phone "312-555-1212"
    end
  end
end
