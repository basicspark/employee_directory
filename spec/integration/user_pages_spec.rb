require 'spec_helper'

describe "User pages" do

  describe "index" do

    before do
      @user = create :user_with_address_and_birthday
      visit users_path
    end

    it "displays the user list table" do
      expect(page).to have_selector('table.table-striped.table-hover')
    end

    it "contains the user's last_name" do
      expect(page).to have_selector('td', text: @user.last_name)
    end

    it "contains the user's first_name" do
      expect(page).to have_selector('td', text: @user.first_name)
    end

    it "contains the user's department name" do
      expect(page).to have_selector('td', text: @user.department.name)
    end

    it "contains the user's phone number" do
      expect(page).to have_selector('td', text: @user.phone)
    end

    describe "pagination" do

      before(:all) do
        40.times { create :user }
      end

      after(:all) do
        User.delete_all
        Department.delete_all
      end

      it "contains the pagination selector" do
        expect(page).to have_selector('ul.pagination')
      end

      it "lists each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('td', text: user.last_name)
        end
      end
    end
  end
end
