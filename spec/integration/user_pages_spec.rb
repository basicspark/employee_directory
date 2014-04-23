require 'spec_helper'

describe "User pages" do

  describe "index" do

    before do
      @user = create :user
      visit users_path
    end

    context "when not signed in" do

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
    end

    describe "pagination" do

      before(:all) { 20.times { create :user } }

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
