require 'spec_helper'

describe "Authentication pages" do

  describe "login page" do
    before { visit login_path }

    it_should_behave_like 'the login page'
    it_should_behave_like 'all pages with logged out users'
  end

  describe "logging in" do
    let(:admin_user) { create :user_admin }
    let(:non_admin_user) { create :user }

    context "with blank information" do
      before { log_in_user(admin_user, email: ' ', password: ' ') }

      it_should_behave_like 'the failed login page'
    end

    context "with incorrect password" do
      before do
        log_in_user(admin_user, password: 'incorrect')
      end

      it_should_behave_like 'the failed login page'

      context "when visiting another page afterward" do
        before do
          visit users_path
          visit login_path
        end

        it "no longer displays the login failure message" do
          expect(page).not_to have_selector('div.alert.alert-dismissable.alert-danger',
                    text: "Incorrect username/password combination. Please try again.")
        end
      end
    end

    context "admin user" do
      before { log_in_user admin_user }

      context "with correct password" do

        it_should_behave_like 'the home page'

        let(:path_to_test) { edit_user_path(admin_user) }
        it_should_behave_like 'all pages with logged in admin users'
      end
    end

    context "non-admin user" do
      before { log_in_user non_admin_user }

      context "with correct password" do

        it_should_behave_like 'the home page'

        let(:path_to_test) { edit_user_path(non_admin_user) }
        it_should_behave_like 'all pages with logged in non-admin users'
      end
    end
  end
end