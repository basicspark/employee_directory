require 'spec_helper'

describe "User pages" do
  let(:admin_user) { create :user_admin }
  let(:non_admin_user) { create :user }

  describe "directory" do

    before do
      @user = create :user_with_address_and_birthday
      visit directory_path
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
        @users_to_delete = []
        @departments_to_delete = []
        15.times do
          @users_to_delete << (create :user)
          @departments_to_delete << @users_to_delete.last.department
        end
      end

      after(:all) do
        @users_to_delete.each do |user|
          user.delete
        end

        @departments_to_delete.each do |department|
          department.delete
        end
      end

      it "contains the pagination selector" do
        expect(page).to have_selector('ul.pagination.pagination-sm')
      end

      it "lists each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('td', text: user.last_name)
        end
      end
    end
  end

  describe "index" do
    before do
      log_in_user admin_user
      @user = create :user
      visit users_path
    end

    it "displays the User Maintenance list form" do
      expect(page).to have_selector('h3.panel-title', text: 'User Maintenance')
    end

    it "displays the user list table" do
      expect(page).to have_selector('table.table-striped.table-hover')
    end

    it "contains the user's first_name" do
      expect(page).to have_selector('td', text: @user.first_name)
    end

    it "contains the user's last_name" do
      expect(page).to have_selector('td', text: @user.last_name)
    end

    it "contains the user's department" do
      expect(page).to have_selector('td', text: @user.department.name)
    end

    it "does not contain the user's phone number" do
      expect(page).not_to have_selector('td', text: @user.phone)
    end

    it "contains the user's id as the id of the row" do
      expect(page).to have_selector("tr##{@user.id}")
    end

    describe "pagination" do
      before do
        @users_to_delete = []
        20.times do
          @users_to_delete << (create :user)
        end
        visit users_path
      end

      after do
        @users_to_delete.each do |user|
          User.delete(user)
        end
      end

      it "contains the small pagination selector" do
        expect(page).to have_selector('ul.pagination.pagination-sm')
      end

      it "lists each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('td', text: user.first_name)
        end
      end
    end
  end

  describe "maintenance" do
    before do
      log_in_user admin_user
      @user = create :user
      visit users_path
    end

    context "adding" do

      context "clicking the Create New User link" do
        before do
          create :department, name: 'Information Technology'
          click_link 'Create New User'
        end

        it "displays the Create User form" do
          expect(page).to have_selector('legend', text: 'Create User')
        end

        it "displays the blank First Name field" do
          expect(page).to have_selector('input#user_first_name.form-control', text: nil)
        end

        it "displays the blank Last Name field" do
          expect(page).to have_selector('input#user_last_name.form-control', text: nil)
        end

        it "displays the Department select list" do
          expect(page).to have_selector('select#user_department_id.form-control')
        end

        it "displays the blank Phone field" do
          expect(page).to have_selector('input#user_phone.form-control', text: nil)
        end

        it "displays the blank Email field" do
          expect(page).to have_selector('input#user_email.form-control', text: nil)
        end

        it "displays the blank Address field" do
          expect(page).to have_selector('textarea#user_address.form-control', text: nil)
        end

        it "displays the blank Start Date field" do
          expect(page).to have_selector('input#user_start_date.form-control', text: nil)
        end

        it "displays the blank Birthday field" do
          expect(page).to have_selector('input#user_birthday.form-control', text: nil)
        end

        it "displays the Admin option with No checked" do
          expect(find '#user_admin_0').to be_checked
        end

        it "displays the Admin option with Yes unchecked" do
          expect(find '#user_admin_1').not_to be_checked
        end

        context "then submitting with no populated fields" do
          before { click_button 'Create User' }

          it "displays the error summary box" do
            expect(page).to have_selector('div.panel.panel-danger',
                                          text: 'Please correct the following:')
          end

          it "shows the name can't be blank error" do
            expect(page).to have_selector('li', text: "First name can't be blank")
          end

          it "highlights the First Name field as being in error" do
            expect(page).to have_selector('div.form-group.has-error',
                                          text: 'First Name')
          end
        end

        context "then submitting a valid record" do
          before do
            fill_in 'First Name', with: 'John'
            fill_in 'Last Name', with: 'Doe'
            select 'Information Technology', from: 'Department'
            fill_in 'Phone Number', with: '312-555-1234'
            fill_in 'Email', with: 'jdoe@myurl.com'
            fill_in 'Password', with: 'foobar'
            fill_in 'Confirm Password', with: 'foobar'
            fill_in 'Address', with: "123 Somewhere St.\nApt. 123\nAnytown, CA 90101"
            fill_in 'Start Date', with: '2001-03-01'
            fill_in 'Birthday', with: '1976-06-01'
            find(:css, "#user_admin_0[value='0']").set(true)
            click_button 'Create User'
          end

          it "saves and displays the new user name" do
            expect(page).to have_selector('legend', text: 'John Doe' )
          end

          it "saves and displays the new user department" do
            expect(page).to have_selector('p.form-control-static',
                                          text: 'Information Technology')
          end

          it "saves and displays the new user phone number" do
            expect(page).to have_selector('p.form-control-static',
                                          text: '312-555-1234')
          end

          it "saves and displays the new user email" do
            expect(page).to have_selector('p.form-control-static',
                                          text: 'jdoe@myurl.com')
          end

          it "saves and displays the new user address" do
            expect(page).to have_selector('p.form-control-static',
                                          text: '123 Somewhere St.' )
          end

          it "saves and displays the new user start_date" do
            expect(page).to have_selector('p.form-control-static',
                                          text: '3/1/2001' )
          end

          it "saves and displays the new user birthday" do
            expect(page).to have_selector('p.form-control-static',
                                          text: '6/1/1976')
          end

          it "saves and displays the administrator option" do
            expect(page).to have_selector('p.form-control-static',
                                          text: 'No')
          end

          it "displays a success message" do
            expect(page).to have_selector('div.alert.alert-dismissable.alert-success',
                                          text: 'User was successfully created.')
          end
        end

        context "then clicking the Go Back link" do
          before do
            click_link 'Go Back'
          end

          it "displays the User Maintenance list form" do
            expect(page).to have_selector('h3.panel-title', text: 'User Maintenance')
          end
        end
      end
    end
    #
    # context "editing" do
    #
    #   context "clicking the edit link in table" do
    #     before do
    #       within(:css, "tr##{@department.id}") { click_link 'Edit' }
    #     end
    #
    #     it "displays the Edit Department form" do
    #       expect(page).to have_selector('legend', text: 'Edit Department')
    #     end
    #
    #     it "displays the correct Department Name field" do
    #       expect(find_field('department_name').value).to eq(@department.name)
    #     end
    #
    #     it "displays the correct Location field" do
    #       expect(find_field('department_location').value).to eq(@department.location)
    #     end
    #
    #     it "displays the correct Phone field" do
    #       expect(find_field('department_phone').value).to eq(@department.phone)
    #     end
    #
    #     context "then submitting with a blanked out Department Name" do
    #       before do
    #         fill_in 'Department Name', with: ' '
    #         click_button 'Update Department'
    #       end
    #
    #       it "displays the error summary box" do
    #         expect(page).to have_selector('div.panel.panel-danger',
    #                                       text: 'Please correct the following:')
    #       end
    #
    #       it "shows the name can't be blank error" do
    #         expect(page).to have_selector('li', text: "Name can't be blank")
    #       end
    #
    #       it "highlights the Department Name field as being in error" do
    #         expect(page).to have_selector('div.form-group.has-error',
    #                                       text: 'Department Name')
    #       end
    #     end
    #
    #     context "then changing all of the fields" do
    #       before do
    #         fill_in 'Department Name', with: 'New Department Name'
    #         fill_in 'Location', with: 'New Location'
    #         fill_in 'Phone', with: '888-888-7777'
    #         click_button 'Update Department'
    #         @department.reload
    #       end
    #
    #       it "saves the updated name to the database" do
    #         expect(@department.name).to eq('New Department Name')
    #       end
    #
    #       it "saves the updated location to the database" do
    #         expect(@department.location).to eq('New Location')
    #       end
    #
    #       it "saves the updated phone number to the database" do
    #         expect(@department.phone).to eq('888-888-7777')
    #       end
    #
    #       it "returns to the department list page" do
    #         expect(page).to have_selector('h3.panel-title', text: 'Department Maintenance')
    #       end
    #
    #       it "displays a success message" do
    #         expect(page).to have_selector('div.alert.alert-dismissable.alert-success',
    #                                       text: 'Department was successfully updated.')
    #       end
    #
    #       it "displays the updated department name on the list screen" do
    #         within(:css, "tr##{@department.id}") do
    #           expect(page).to have_selector('td', text: 'New Department Name')
    #         end
    #       end
    #
    #       it "displays the updated department location on the list screen" do
    #         within(:css, "tr##{@department.id}") do
    #           expect(page).to have_selector('td', text: 'New Location')
    #         end
    #       end
    #
    #       it "displays the updates department phone on the list screen" do
    #         within(:css, "tr##{@department.id}") do
    #           expect(page).to have_selector('td', text: '888-888-7777')
    #         end
    #       end
    #     end
    #
    #     context "then clicking the Go Back link" do
    #       before do
    #         click_link 'Go Back'
    #       end
    #
    #       it "displays the Department Maintenance list form" do
    #         expect(page).to have_selector('h3.panel-title', text: 'Department Maintenance')
    #       end
    #     end
    #   end
    # end
    #
    # context "deleting" do
    #   before do
    #     within(:css, "tr##{@department.id}") do
    #       click_link('Delete')
    #     end
    #   end
    #
    #   it "deletes the correct department from the database" do
    #     expect { @department.reload }.to raise_error(ActiveRecord::RecordNotFound)
    #   end
    #
    #   it "no longer shows the deleted department in the list" do
    #     expect(page).not_to have_selector('td', text: @department.name)
    #   end
    #
    #   context "a department with assigned users" do
    #     before do
    #       @user_with_department = create :user
    #       @department_to_delete = @user_with_department.department
    #       visit departments_path
    #       within(:css, "tr##{@department_to_delete.id}") do
    #         click_link('Delete')
    #       end
    #     end
    #
    #     it "does not delete the department" do
    #       expect { @department_to_delete.reload }.not_to raise_error ActiveRecord::RecordNotFound
    #     end
    #   end
    # end
  end

  describe "authorized actions" do
    let(:existing_user) { create :user }
    let(:new_department) { build :department }

    shared_examples_for 'a non-logged in action' do
      it_should_behave_like 'the login page'

      it "displays a please login message" do
        expect(page).to have_selector('div.alert.alert-dismissable.alert-info',
                                      text: 'Please log in.')
      end
    end

    context "when not logged in" do
      context "and accessing the user maintenance list" do
        before { visit users_path }

        it_should_behave_like 'a non-logged in action'
      end

      context "and posting to the create users path" do
        before { post users_path }

        it "redirects to the login path" do
          expect(response).to redirect_to(login_url)
        end
      end

      context "and accessing the new user path" do
        before { visit new_user_path }

        it_should_behave_like 'a non-logged in action'
      end

      context "and accessing the edit user path" do
        before { visit edit_user_path(existing_user) }

        it_should_behave_like 'a non-logged in action'
      end

      context "and patching to the user path" do
        before { patch user_path(existing_user) }

        it "redirects to the login path" do
          expect(response).to redirect_to(login_url)
        end
      end

      context "and deleting to the user path" do
        before { delete user_path(existing_user) }

        it "redirects to the login path" do
          expect(response).to redirect_to(login_url)
        end

        it "doesn't delete the record" do
          expect { existing_user.reload }.not_to raise_error
        end
      end
    end

    context "when logged in as a non-admin user" do
      before { log_in_user(non_admin_user, no_capybara: true) }

      context "and accessing the user maintenance list" do
        before { get users_path }

        it "redirects to the root url" do
          expect(response).to redirect_to(root_url)
        end
      end

      context "and posting to the create users path" do
        before { post users_path }

        it "redirects to the root url" do
          expect(response).to redirect_to(root_url)
        end
      end

      context "and accessing the new user path" do
        before { get new_user_path }

        it "redirects to the root url" do
          expect(response).to redirect_to(root_url)
        end
      end

      context "and accessing the edit user path" do
        before { get edit_user_path(existing_user) }

        it "redirects to the root url" do
          expect(response).to redirect_to(root_url)
        end
      end

      context "and patching to the user path" do
        before { patch user_path(existing_user) }

        it "redirects to the root url" do
          expect(response).to redirect_to(root_url)
        end
      end

      context "and deleting to the user path" do
        before { delete user_path(existing_user) }

        it "redirects to the root url" do
          expect(response).to redirect_to(root_url)
        end

        it "doesn't delete the record" do
          expect { existing_user.reload }.not_to raise_error
        end
      end
    end
  end
end