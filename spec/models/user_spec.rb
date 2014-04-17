require 'spec_helper'

describe User do

  before do
    @user = User.new(first_name: 'John', last_name: 'Doe', department_id: 1,
                     phone: '312-555-1212', email: 'john@example.com',
                     address: "123 Somewhere St.\nLittletown, IL 60606",
                     start_date: '3/1/2004', birthday: '8/1', user_type: 0)

  end

  subject { @user }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:department_id) }
  it { should respond_to(:phone) }
  it { should respond_to(:email) }
  it { should respond_to(:address) }
  it { should respond_to(:start_date) }
  it { should respond_to(:birthday) }
  it { should respond_to(:user_type) }

  it { should be_valid }

end