require 'spec_helper'

describe "Authentication pages" do

  describe "login page" do
    before { visit login_path }

    it_should_behave_like 'the login page'
    it_should_behave_like 'all pages with logged out users'
  end

  describe "logging in" do
    let(:user_to_log_in) { create :user, password: 'letmein',
                                  password_confirmation: 'letmein' }

    context "with blank information" do
      before { log_in_user(user_to_log_in, email: ' ', password: ' ') }

      it_should_behave_like 'the failed login page'
    end

    context "with incorrect password" do
      before do
        log_in_user(user_to_log_in, password: 'incorrect')
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

    context "with correct password" do
      before { log_in_user(user_to_log_in) }

      it_should_behave_like 'the home page'

      let(:path_to_test) { edit_user_path(user_to_log_in) }
      it_should_behave_like 'all pages with logged in users'
    end
  end
end