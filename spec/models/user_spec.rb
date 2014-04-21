require 'spec_helper'

describe User do

  let(:user) { build :user }

  it "has a valid factory" do
    expect(user).to be_valid
  end

  subject { user }

  context "when responding to instance methods" do
    it { should respond_to(:first_name) }
    it { should respond_to(:last_name) }
    it { should respond_to(:department_id) }
    it { should respond_to(:phone) }
    it { should respond_to(:email) }
    it { should respond_to(:address) }
    it { should respond_to(:start_date) }
    it { should respond_to(:birthday) }
    it { should respond_to(:user_type) }
  end

  context "when assigning values to attributes" do

    shared_examples_for "a valid date field" do
      it "does not allow invalid dates" do
        invalid_dates = ["3/31S/2013", "3/0/2012", "3/1/20234", "1/32/2013",
                         "2/30/2013", "3/32/2013", "4/31/2013", "5/32/2013",
                         "6/31/2013", "7/32/2013", "8/32/2013", "9/31/2013",
                         "10/32/2013", "11/31/2013","12/32/2013", "0/15/2013",
                         "-1/15/2013", "13/15/2013", "12 31/2013", "2/29/2003"]
        invalid_dates.each do |invalid_date|
          subject.__send__("#{field}=", Chronic::parse(invalid_date))
          if blank_ok? && Chronic::parse(invalid_date).nil?
            expect(subject).to be_valid
          else
            expect(subject).not_to be_valid
          end
        end
      end

      it "allows a variety of valid dates" do
        valid_dates = %w[1/31/2013 2/29/2004 2/29/2000]
        valid_dates.each do |valid_date|
          subject.__send__("#{field}=", Chronic::parse(valid_date))
          expect(subject).to be_valid
        end
      end
    end

    it "is invalid without a first_name" do
      expect(build :user, first_name: ' ').not_to be_valid
    end

    it "does not allow a first_name longer than 50" do
      expect(build :user, first_name: 'X' * 51).not_to be_valid
    end

    it "is invalid without a last_name" do
      expect(build :user, last_name: ' ').not_to be_valid
    end

    it "does not allow a last_name longer than 50" do
      expect(build :user, last_name: 'X' * 51).not_to be_valid
    end

    it "is invalid without a department_id" do
      expect(build :user, department_id: nil).not_to be_valid
    end

    it "is invalid without a phone" do
      expect(build :user, phone: ' ').not_to be_valid
    end

    it "does not allow invalid phone numbers" do
      bad_numbers = ["123", "123 444 1212", "312 454 5765", "(122) 223-2332",
                     "232-2323232","(122) 444 1212", "232-233-293S", "232-232-232",
                     "2223331212", "22212312344", "112-654-5557"]
      bad_numbers.each do |number|
        expect(build :user, phone: number).not_to be_valid
      end
    end

    it "is invalid without an email" do
      expect(build :user, email: ' ').not_to be_valid
    end

    it "does not allow invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com
                  foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        expect(build :user, email: invalid_address).not_to be_valid
      end
    end

    it "allows a variety of valid email formats" do
      addresses = %w[user@foo.COM A-US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        expect(build :user, email: valid_address).to be_valid
      end
    end

    it "does not allow a duplicate email" do
      create :user, email: 'jdoe@example.com'
      expect(build :user, email: 'jdoe@example.com').not_to be_valid
    end

    it "does not allow an address longer than 200" do
      expect(build :user, address: 'X' * 201).not_to be_valid
    end

    it "is invalid without a start_date" do
      expect(build :user, start_date: ' ').not_to be_valid
    end

    context "when providing a start_date" do
      let(:field) { :start_date }
      let(:blank_ok?) { false }
      it_should_behave_like "a valid date field"
    end

    it "does not require a birthday" do
      expect(build :user, birthday: ' ').to be_valid
    end

    context "when providing a birthday" do
      let(:field) { :birthday }
      let(:blank_ok?) { true }
      it_should_behave_like "a valid date field"
    end

    it "is invalid without a user_type" do
      expect(build :user, user_type: nil).not_to be_valid
    end

    it "does not allow an invalid user_type" do
      invalid_types = [-1, 3]
      invalid_types.each do |invalid_type|
        expect(build :user, user_type: invalid_type).not_to be_valid
      end
    end

    it "allows each of the valid user_types" do
      valid_types = (0..2).to_a
      valid_types.each do |valid_type|
        expect(build :user, user_type: valid_type).to be_valid
      end
    end
  end
end

