require 'spec_helper'

describe User do

  before do
    @user = User.new(first_name: 'John', last_name: 'Doe', department_id: 1,
                     phone: '312-555-1212', email: 'john@example.com',
                     address: "123 Somewhere St.\nLittletown, IL 60606",
                     start_date: '3/1/2004', birthday: '8/1', user_type: 0)

  end

  subject { @user }

  describe "response to methods" do
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

  describe "field validations" do

    shared_examples_for "a valid date field" do
      describe "when date is invalid" do
        it "should be invalid" do
          invalid_dates = ["3", "331", "3/31S/2013", "3/0/2012", "3/1/20234",
                           "3/1/1", "1/32/2013", "2/30/2013", "3/32/2013",
                           "4/31/2013", "5/32/2013", "6/31/2013", "7/32/2013",
                           "8/32/2013", "9/31/2013", "10/32/2013", "11/31/2013",
                           "12/32/2013", "0/15/2013", "-1/15/2013", "13/15/2013",
                           "12 31/2013", "3/2013", "2/29/2003"]
          invalid_dates.each do |invalid_date|
            subject.__send__("#{field}=", invalid_date)
            expect(subject).not_to be_valid
          end
        end
      end

      describe "when date is valid" do
        it "should be valid" do
          valid_dates = %w[1/31/2013 2/29/2004 2/29/2000]
          valid_dates.each do |valid_date|
            subject.__send__("#{field}=", valid_date)
            expect(subject).to be_valid
          end
        end
      end
    end

    describe "when first_name is missing" do
      before { @user.first_name = ' ' }
      it { should_not be_valid }
    end

    describe "when first_name is too long" do
      before { @user.first_name = 'X' * 51 }
      it { should_not be_valid }
    end

    describe "when last_name is missing" do
      before { @user.last_name = ' ' }
      it { should_not be_valid }
    end

    describe "when last_name is too long" do
      before { @user.last_name = 'X' * 51 }
      it { should_not be_valid }
    end

    describe "when department_id is missing" do
      before { @user.department_id = nil }
      it { should_not be_valid }
    end

    describe "when phone is missing" do
      before { @user.phone = ' ' }
      it { should_not be_valid }
    end

    describe "when phone format is invalid" do
      it "should be invalid" do
        bad_numbers = ["123", "123 444 1212", "312 454 5765", "(122) 223-2332",
                       "232-2323232","(122) 444 1212", "232-233-293S", "232-232-232",
                       "2223331212", "22212312344", "112-654-5557"]
        bad_numbers.each do |number|
          @user.phone = number
          expect(@user).not_to be_valid
        end
      end
    end

    describe "when phone format is valid" do
      before { @user.phone = '312-555-1212' }
      it { should be_valid }
    end

    describe "when email is missing" do
      before { @user.email = ' ' }
      it { should_not be_valid }
    end

    describe "when email format is invalid" do
      it "should be invalid" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com
                    foo@bar+baz.com foo@bar..com]
        addresses.each do |invalid_address|
          @user.email = invalid_address
          expect(@user).not_to be_valid
        end
      end
    end

    describe "when email format is valid" do
      it "should be valid" do
        addresses = %w[user@foo.COM A-US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          @user.email = valid_address
          expect(@user).to be_valid
        end
      end
    end

    describe "when email is already taken" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
      end

      it { should_not be_valid }
    end

    describe "when address is too long" do
      before { @user.address = 'X' * 201 }
      it { should_not be_valid }
    end

    describe "when start_date is missing" do
      before { @user.start_date = ' ' }
      it { should_not be_valid }
    end

    describe "when start_date is invalid" do
      let(:field) { :start_date }
      it_should_behave_like "a valid date field"
    end

    describe "when birthday is invalid" do
      let(:field) { :birthday }
      it_should_behave_like "a valid date field"
    end

    describe "when user_type is missing" do
      before { @user.user_type = nil }
      it { should_not be_valid }
    end

    describe "when user_type is invalid" do
      it "should be invalid" do
        invalid_types = [-1, 3]
        invalid_types.each do |invalid_type|
          @user.user_type = invalid_type
          expect(@user).not_to be_valid
        end
      end
    end

    describe "when user_type is valid" do
      it "should be valid" do
        valid_types = (0..2).to_a
        valid_types.each do |valid_type|
          @user.user_type = valid_type
          expect(@user).to be_valid
        end
      end
    end
  end
end

