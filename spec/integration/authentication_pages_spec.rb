require 'spec_helper'

describe "Authentication pages" do

  subject { page }

  describe "login page" do
    before { visit login_path }

    it "displays the login page" do
      expect(page).to have_selector('h2.form-signin-heading',
                                    text: 'Please log in')
    end

    it "shows the Login link in the top menu" do
      expect(page).to have_link('Login', href: login_path)
    end

    it "shows the Login link as active" do
      expect(page).to have_selector('li.active', text: 'Login')
    end
  end

  describe "logging in" do
    before { visit login_path }
    let(:user_to_log_in) { create :user, password: 'letmein',
                                  password_confirmation: 'letmein' }

    context "with blank information" do
      before { click_button 'Log in'}

      it "continues to display the login page" do
        expect(page).to have_selector('h2.form-signin-heading',
                                      text: 'Please log in')
      end

      it "displays the login error message" do
        expect(page).to have_selector('div.alert.alert-dismissable.alert-danger',
              text: "Incorrect username/password combination. Please try again.")
      end

      it "does not show the Home link in the top menu" do
        expect(page).not_to have_link('Home', href: users_path)
      end

      it "does not show the Edit My Profile link in the top menu" do
        expect(page).not_to have_link('Edit My Profile')
      end

      it "shows the Login link in the top menu" do
        expect(page).to have_link('Login', href: login_path)
      end

      it "shows the Login link as active" do
        expect(page).to have_selector('li.active', text: 'Login')
      end
    end

    context "with incorrect password" do
      before do
        fill_in "email", with: user_to_log_in.email
        fill_in "password", with: 'incorrect'
        click_button 'Log in'
      end

      it "continues to display the login page" do
        expect(page).to have_selector('h2.form-signin-heading',
                                      text: 'Please log in')
      end

      it "displays the login error message" do
        expect(page).to have_selector('div.alert.alert-dismissable.alert-danger',
              text: "Incorrect username/password combination. Please try again.")
      end

      it "does not show the Home link in the top menu" do
        expect(page).not_to have_link('Home', href: users_path)
      end

      it "does not show the Edit My Profile link in the top menu" do
        expect(page).not_to have_link('Edit My Profile')
      end

      it "shows the Login link in the top menu" do
        expect(page).to have_link('Login', href: login_path)
      end

      it "shows the Login link as active" do
        expect(page).to have_selector('li.active', text: 'Login')
      end

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
      before do
        fill_in "email", with: user_to_log_in.email.upcase
        fill_in "password", with: user_to_log_in.password
        click_button 'Log in'
      end

      it "displays the user list screen" do
        expect(page).to have_selector('th', text: 'Last Name')
      end

      it "shows the Home link in the top menu" do
        expect(page).to have_link('Home', href: users_path)
      end

      it "shows the Home link as active" do
        expect(page).to have_selector('li.active', text: 'Home')
      end

      it "shows the Edit My Profile link in the top menu" do
        expect(page).to have_link('Edit My Profile',
                                  href: edit_user_path(user_to_log_in))
      end

      it "shows the Logout link in the top menu" do
        expect(page).to have_link('Logout', href: logout_path)
      end

      context "followed by logging out" do
        before { click_link 'Logout' }

        it "returns to the user list screen" do
          expect(page).to have_selector('th', text: 'Last Name')
        end

        it "does not show the Home link in the top menu" do
          expect(page).not_to have_link('Home', href: users_path)
        end

        it "does not show the Edit My Profile link in the top menu" do
          expect(page).not_to have_link('Edit My Profile')
        end

        it "shows the Login link in the top menu" do
          expect(page).to have_link('Login', href: login_path)
        end
      end
    end
  end
end