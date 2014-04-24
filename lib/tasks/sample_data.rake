namespace :db do
  desc "Fill the database with sample data"
  task populate: :environment do
    make_departments
    make_users
  end
end

def make_departments
  Department.create!(name: 'Accounting',
                     location: 'Chicago Headquarters',
                     phone: '312-555-1000')
  Department.create!(name: 'Information Technology',
                     location: 'San Diego Office',
                     phone: '619-555-1001')
  Department.create!(name: 'Office Services',
                     location: 'Chicago Headquarters',
                     phone: '312-555-1005')
  Department.create!(name: 'Human Resources',
                     location: "O'Brien Services",
                     phone: '312-555-1000')
  Department.create!(name: 'Finance',
                     location: 'Chicago Headquarters',
                     phone: '312-555-1000')
  Department.create!(name: 'Customer Service',
                     location: 'Las Vegas Office',
                     phone: '702-555-1000')
end

def make_users
  User.create!(first_name: 'Russ',
               last_name: 'Martin',
               department: Department.find_by(name: 'Information Technology'),
               phone: '312-562-8510',
               email: 'russ@russconsult.com',
               start_date: Chronic::parse('6-1-2013'),
               address: "1123 W. Hummingbird Way\nApt. 304\nChicago, IL 60644",
               birthday: Chronic::parse('5-4-1980'),
               user_type: 1,
               password: 'myfirstapp',
               password_confirmation: 'myfirstapp')
  400.times do |n|
    User.create!(first_name: Faker::Name.first_name,
                 last_name: Faker::Name.last_name,
                 department: retrieve_random_department,
                 phone: "312-555-#{Faker::Number.number(4)}",
                 email: Faker::Internet.email,
                 start_date: rand(7000).days.ago,
                 address: generate_address,
                 birthday: rand(9000..24000).days.ago,
                 user_type: 1,
                 password: 'september',
                 password_confirmation: 'september')
  end
end

def retrieve_random_department
  all_departments = Department.all
  random_index = rand(0..(all_departments.count - 1))
  return all_departments[random_index]
end

def generate_address
  Faker::Address.street_address + "\n" +
      Faker::Address.secondary_address + "\n" +
      Faker::Address.city + ', ' +
      Faker::Address.state_abbr + ' ' +
      Faker::Address.zip_code
end