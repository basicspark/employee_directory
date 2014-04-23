require 'spec_helper'

describe Department do

  let(:department) { build :department }

  it "has a valid factory" do
    expect(department).to be_valid
  end

  subject { department }

  context "when responding to instance methods" do
    it { should respond_to(:name) }
    it { should respond_to(:location) }
    it { should respond_to(:phone) }
    it { should respond_to(:users) }
  end

  context "when assigning values to attributes" do

    it "is invalid without a name" do
      expect(build :department, name: ' ').not_to be_valid
    end

    it "does not allow a name longer than 50" do
      expect(build :department, name: 'X' * 51).not_to be_valid
    end

    it "does not allow duplicate names" do
      create :department, name: 'Test Dept.'
      expect(build :department, name: 'Test Dept.'.upcase).not_to be_valid
    end

    it "does not allow a location longer than 50" do
      expect(build :department, location: 'X' * 51).not_to be_valid
    end

    it_should_behave_like "a record with valid phone number"
  end

end
