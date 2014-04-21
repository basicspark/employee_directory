require 'spec_helper'

describe "User pages" do

  before { @user = create :user }

  describe "index" do

    context "when not signed in" do
      before(:each) { visit users_path }

      it "displays the user list table" do
        expect(page).to have_selector('table.table-striped.table-hover')
      end

      it "contains the user's last_name" do
        expect(page).to have_selector('td', text: @user.last_name)
      end

      it "contains the user's first_name" do
        expect(page).to have_selector('td', text: @user.first_name)
      end

      it "contains the user's department" do
        expect(page).to have_selector('td', text: @user.department_id)
      end

      it "contains the user's phone number" do
        expect(page).to have_selector('td', text: @user.phone)
      end
    end
  end
end
