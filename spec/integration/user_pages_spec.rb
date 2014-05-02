require 'spec_helper'

describe "User pages" do
  before do
    create :department, name: 'Information Technology'
    create :department, name: 'New Department'
  end

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

    it "has a link on first_name to the detail view" do
      expect(page).to have_link(@user.first_name, href: user_path(@user))
    end

    it "has a link on the last_name to the details view" do
      expect(page).to have_link(@user.last_name, href: user_path(@user))
    end

    describe "user detail screen" do
      context "when not logged in" do
        before { within("tr##{@user.id}") { click_link @user.last_name } }

        it "displays the user's name" do
          expect(page).to have_selector('legend',
                                        text: "#{@user.first_name} #{@user.last_name}")
        end

        it "displays the user's department" do
          expect(page).to have_selector('p.form-control-static',
                                        text: @user.department.name)
        end

        it "displays the user's phone number" do
          expect(page).to have_selector('p.form-control-static', text: @user.phone)
        end

        it "does not display the user's email" do
          expect(page).not_to have_content(@user.email)
        end

        it "does not display the user's address" do
          expect(page).not_to have_content(@user.address)
        end

        it "does not display the user's start_date" do
          expect(page).not_to have_content(@user.start_date.strftime("%-m/%-d/%Y"))
        end

        it "does not display the user's birthday" do
          expect(page).not_to have_content(@user.birthday.strftime("%-m/%-d/%Y"))
        end

        it "does not display the user's admin option" do
          expect(page).not_to have_content('Administrator')
        end

        it "displays the user's gravatar imagage" do
          expect(page).to have_selector('img.user-gravatar')
        end
      end

      context "when logged in as a non-admin" do
        before do
          log_in_user non_admin_user
          within("tr##{@user.id}") { click_link @user.last_name }
        end

        it "displays the user's name" do
          expect(page).to have_selector('legend',
                                        text: "#{@user.first_name} #{@user.last_name}")
        end

        it "displays the user's department" do
          expect(page).to have_selector('p.form-control-static',
                                        text: @user.department.name)
        end

        it "displays the user's phone number" do
          expect(page).to have_selector('p.form-control-static', text: @user.phone)
        end

        it "displays the user's email" do
          expect(page).to have_selector('p.form-control-static', text: @user.email)
        end

        it "displays the user's address" do
          expect(page).to have_selector('p', text: @user.address)
        end

        it "displays the user's start_date" do
          expect(page).to have_selector('p.form-control-static',
                                        text: @user.start_date.strftime("%-m/%-d/%Y"))
        end

        it "displays the user's birthday" do
          expect(page).to have_selector('p.form-control-static',
                                text: @user.birthday.strftime("%B %-d"))
        end

        it "does not display the user's birth year" do
          expect(page).not_to have_content(@user.birthday.strftime("%-m/%-d/%Y"))
        end

        it "does not display the user's admin option" do
          expect(page).not_to have_content('Administrator')
        end

        it "displays the user's gravatar imagage" do
          expect(page).to have_selector('img.user-gravatar')
        end
      end

      context "when logged in as an admin" do
        before do
          log_in_user admin_user
          within("tr##{@user.id}") { click_link @user.last_name }
        end

        it "displays the user's name" do
          expect(page).to have_selector('legend',
                                        text: "#{@user.first_name} #{@user.last_name}")
        end

        it "displays the user's department" do
          expect(page).to have_selector('p.form-control-static',
                                        text: @user.department.name)
        end

        it "displays the user's phone number" do
          expect(page).to have_selector('p.form-control-static', text: @user.phone)
        end

        it "displays the user's email" do
          expect(page).to have_selector('p.form-control-static', text: @user.email)
        end

        it "displays the user's address" do
          expect(page).to have_selector('p', text: @user.address)
        end

        it "displays the user's start_date" do
          expect(page).to have_selector('p.form-control-static',
                                        text: @user.start_date.strftime("%-m/%-d/%Y"))
        end

        it "displays the user's birthday with year" do
          expect(page).to have_selector('p.form-control-static',
                                        text: @user.birthday.strftime("%-m/%-d/%Y"))
        end

        it "displays the user's admin option" do
          expect(page).to have_selector('p.form-control-static',
                                        text: 'No')
        end

        it "displays the user's gravatar imagage" do
          expect(page).to have_selector('img.user-gravatar')
        end
      end
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

    describe "filtering" do
      before do
        @sales_department =  create :department, name: 'Sales'
        @marketing_department = create :department, name: 'Marketing'
        @user_in_sales = create :user, department: @sales_department,
                                last_name: 'guyinsales'
        @user_in_marketing = create :user, department: @marketing_department,
                                last_name: 'guyinmarketing'
        visit directory_path
      end

      context "when all selected" do
        before do
          within('div.panel.panel-default.visible-md.visible-lg') {
            find(:css, "#_user_view_all[value='all']").set(true)
            click_button 'Apply'
          }
        end

        it "displays the user in sales" do
          within("tr##{@user_in_sales.id}") { expect(page).to have_selector('td',
                                                text: @user_in_sales.last_name) }
        end

        it "displays the user in marketing" do
          within("tr##{@user_in_marketing.id}") { expect(page).to have_selector('td',
                                                text: @user_in_marketing.last_name) }
        end
      end

      # Testing this one directly since it uses JS within the UI
      context "when one department selected" do
        before do
          post directory_path, user_view: 'dep',
               view_department_id: @marketing_department.id.to_s
        end

        it "displays the user in marketing" do
          expect(response.body).to include(@user_in_marketing.last_name)
        end

        it "does not display the user in sales" do
          expect(response.body).not_to include(@user_in_sales.last_name)
        end
      end
    end

    describe "searching" do
      before do
        @user_john = create :user, first_name: 'johniswaycool'
        @user_jane = create :user, first_name: 'janerulestheschool'
      end

      context "when the search box is empty" do
        before do
          within('div.panel.panel-default.visible-md.visible-lg') {
            fill_in 'user_search', with: ''
            click_button 'Apply'
          }
        end

        it "displays the john record" do
          within("tr##{@user_john.id}") { expect(page).to have_selector('td',
                                              text: @user_john.first_name) }
        end

        it "displays the jane record" do
          within("tr##{@user_jane.id}") { expect(page).to have_selector('td',
                                              text: @user_jane.first_name) }
        end
      end

      context "when searching results in one match" do
        before do
          within('div.panel.panel-default.visible-md.visible-lg') {
            fill_in 'user_search', with: 'waycool'
            click_button 'Apply'
          }
        end

        it "displays the john record" do
          within("tr##{@user_john.id}") { expect(page).to have_selector('td',
                                         text: @user_john.first_name) }
        end

        it "does not display the jane record" do
          expect(page).not_to have_content(@user_jane.first_name)
        end
      end

      context "when searching results in no matches" do
        before do
          within('div.panel.panel-default.visible-md.visible-lg') {
            fill_in 'user_search', with: 'wontmatch'
            click_button 'Apply'
          }
        end

        it "does not display the john record" do
          expect(page).not_to have_content(@user_john.first_name)
        end

        it "does not display the jane record" do
          expect(page).not_to have_content(@user_jane.first_name)
        end
      end

      context "when searching results in both matches" do
        before do
          within('div.panel.panel-default.visible-md.visible-lg') {
            fill_in 'user_search', with: 'ool'
            click_button 'Apply'
          }
        end

        it "displays the john record" do
          within("tr##{@user_john.id}") { expect(page).to have_selector('td',
                                          text: @user_john.first_name) }
        end

        it "displays the jane record" do
          within("tr##{@user_jane.id}") { expect(page).to have_selector('td',
                                          text: @user_jane.first_name) }
        end
      end

      context "within a specific department" do
        before do
          @accounting_department = create :department, name: 'Accounting'
          @finance_department = create :department, name: 'Finance'
          @other_department = create :department, name: 'Other'
          @user_bob_accounting = create :user, first_name: 'bobunusual',
                                        last_name: 'smithisamazing',
                                        department: @accounting_department
          @user_bob_finance = create :user, first_name: 'bobunusual',
                                     last_name: 'stevensissuper',
                                     department: @finance_department
        end

        # These must all be tested directly because the UI utilizes JS
        context "for all departments" do
          before do
            post directory_path, user_view: 'all',
                 user_search: 'bobunusual'
          end

          it "displays the bob in accounting record" do
            expect(response.body).to include(@user_bob_accounting.last_name)
          end

          it "displays the bob in finance record" do
            expect(response.body).to include(@user_bob_finance.last_name)
          end
        end

        context "for just one department with a match" do
          before do
            post directory_path, user_view: 'dep',
                 view_department_id: @finance_department.id,
                 user_search: 'bobunusual'
          end

          it "displays the bob in finance record" do
            expect(response.body).to include(@user_bob_finance.last_name)
          end

          it "does not display the bob in accounting record" do
            expect(response.body).not_to include(@user_bob_accounting.last_name)
          end
        end

        context "for a department without a match" do
          before do
            post directory_path, user_view: 'dep',
                 view_department_id: @other_department.id,
                 user_search: 'bobunusual'
          end

          it "does not display the bob in finance record" do
            expect(response.body).not_to include(@user_bob_finance.last_name)
          end

          it "does not display the bob in accounting record" do
            expect(response.body).not_to include(@user_bob_accounting.last_name)
          end
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
      @user = create :user_with_address_and_birthday
      visit users_path
    end

    context "adding" do

      context "clicking the Create New User link" do
        before do
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

        it "does not display the user picture panel" do
          expect(page).not_to have_selector('h3.panel-title',
                                            text: 'User Photo Preview')
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
            fill_in 'Address', with: "123 Somewhere St."
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
            expect(page).to have_selector('p', text: '123 Somewhere St.' )
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

    context "editing" do

      context "clicking the edit link in table" do
        before do
          within(:css, "tr##{@user.id}") { click_link 'Edit' }
        end

        it "displays the Edit User form" do
          expect(page).to have_selector('legend', text: 'Edit User')
        end

        it "displays the correct First Name field" do
          expect(find_field('user_first_name').value).to eq(@user.first_name)
        end

        it "displays the correct Last Name field" do
          expect(find_field('user_last_name').value).to eq(@user.last_name)
        end

        it "displays the correct Department field" do
          expect(page).to have_select('user_department_id', selected: @user.department.name)
        end

        it "displays the correct Phone Number field" do
          expect(find_field('user_phone').value).to eq(@user.phone)
        end

        it "displays the correct Email field" do
          expect(find_field('user_email').value).to eq(@user.email)
        end

        it "displays the correct Address field" do
          expect(find_field('user_address').value).to eq(@user.address)
        end

        it "displays the correct Start Date field" do
          expect(find_field('user_start_date').value).to eq(@user.start_date.strftime("%Y-%m-%d"))
        end

        it "displays the correct Birthday field" do
          expect(find_field('user_birthday').value).to eq(@user.birthday.strftime("%Y-%m-%d"))
        end

        it "displays the correct Admin option" do
          if @user.admin?
            expect(find '#user_admin_1').to be_checked
          else
            expect(find '#user_admin_0').to be_checked
          end
        end

        it "displays the user picture panel" do
          expect(page).to have_selector('h3.panel-title',
                                        text: 'User Photo Preview')
        end

        it "displays the user gravatar image" do
          expect(page).to have_selector('img.user-gravatar')
        end

        context "then submitting with a blanked out First Name" do
          before do
            fill_in 'First Name', with: ' '
            click_button 'Update User'
          end

          it "displays the error summary box" do
            expect(page).to have_selector('div.panel.panel-danger',
                                          text: 'Please correct the following:')
          end

          it "shows the first_name can't be blank error" do
            expect(page).to have_selector('li', text: "First name can't be blank")
          end

          it "highlights the First Name field as being in error" do
            expect(page).to have_selector('div.form-group.has-error',
                                          text: 'First Name')
          end
        end

        context "then changing all of the fields" do
          before do
            @previous_password = @user.password_digest
            fill_in 'First Name', with: 'NewFirst'
            fill_in 'Last Name', with: 'NewLast'
            select 'New Department', from: 'Department'
            fill_in 'Phone Number', with: '212-777-4321'
            fill_in 'Email', with: 'new@email.com'
            fill_in 'Password', with: 'newpass'
            fill_in 'Confirm Password', with: 'newpass'
            fill_in 'Address', with: "NewAddress"
            fill_in 'Start Date', with: '1999-09-09'
            fill_in 'Birthday', with: '1988-08-08'
            find(:css, "#user_admin_1[value='1']").set(true)
            click_button 'Update User'
            @user.reload
          end

          it "saves the updated first_name to the database" do
            expect(@user.first_name).to eq('NewFirst')
          end

          it "saves the updated last_name to the database" do
            expect(@user.last_name).to eq('NewLast')
          end

          it "saves the updated department to the database" do
            expect(@user.department.name).to eq('New Department')
          end

          it "saves the updated phone to the database" do
            expect(@user.phone).to eq('212-777-4321')
          end

          it "saves the updated email to the database" do
            expect(@user.email).to eq('new@email.com')
          end

          it "saves the updated address to the database" do
            expect(@user.address).to eq('NewAddress')
          end

          it "saves the updated start_date to the database" do
            expect(@user.start_date.strftime('%Y-%m-%d')).to eq('1999-09-09')
          end

          it "saves the updated birthday to the database" do
            expect(@user.birthday.strftime('%Y-%m-%d')).to eq('1988-08-08')
          end

          it "saves the updated admin selection to the database" do
            expect(@user.admin).to be_true
          end

          it "saves the updated password to the database" do
            expect(@user.password_digest).not_to eq(@previous_password)
          end

          it "returns to the user show page" do
            expect(page).to have_selector('legend', text: 'NewFirst NewLast' )
          end

          it "displays a success message" do
            expect(page).to have_selector('div.alert.alert-dismissable.alert-success',
                                          text: 'User was successfully updated.')
          end
        end

        context "then changing only the name and not the password" do
          before do
            fill_in 'First Name', with: 'MyNewFirst'
            click_button 'Update User'
            @user.reload
          end

          it "saves the updated first_name to the database" do
            expect(@user.first_name).to eq('MyNewFirst')
          end

          it "displays a success message" do
            expect(page).to have_selector('div.alert.alert-dismissable.alert-success',
                                          text: 'User was successfully updated.')
          end
        end

        context "then changing only the password without the confirmation" do
          before do
            @previous_password = @user.password_digest

          end

          context "without providing the confirmation" do
            before do
              fill_in 'Password', with: 'Pass'
              click_button 'Update User'
              @user.reload
            end

            it "does not update the password in the database" do
              expect(@user.password_digest).to eq(@previous_password)
            end

            it "displays the error summary box" do
              expect(page).to have_selector('div.panel.panel-danger',
                                            text: 'Please correct the following:')
            end

            it "shows the password too short error" do
              expect(page).to have_selector('li', text: "Password is too short")
            end

            it "shows the password doesn't match confirmation error" do
              expect(page).to have_selector('li', text: "Password confirmation doesn't match")
            end

            it "highlights the Password field as being in error" do
              expect(page).to have_selector('div.form-group.has-error',
                                            text: 'Password')
            end
          end

          context "with providing the confirmation" do
            before do
              fill_in 'Password', with: 'MyNewPass'
              fill_in 'Confirm Password', with: 'MyNewPass'
              click_button 'Update User'
              @user.reload
            end

            it "updates the password in the database" do
              expect(@user.password_digest).not_to eq(@previous_password)
            end

            it "returns to the user show page" do
              expect(page).to have_selector('legend',
                                  text: "#{@user.first_name} #{@user.last_name}" )
            end

            it "displays a success message" do
              expect(page).to have_selector('div.alert.alert-dismissable.alert-success',
                                            text: 'User was successfully updated.')
            end
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

    context "deleting" do
      before do
        within(:css, "tr##{@user.id}") do
          click_link('Delete')
        end
      end

      it "deletes the correct user from the database" do
        expect { @user.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "no longer shows the deleted user in the list" do
        expect(page).not_to have_selector('td', text: @user.first_name)
      end
    end
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

        it "redirects to the current user's url" do
          expect(response).to redirect_to(edit_user_url non_admin_user)
        end
      end

      context "and patching to the user path" do
        before { patch user_path(existing_user) }

        it "redirects to the current user's url" do
          expect(response).to redirect_to(edit_user_url non_admin_user)
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

  describe "profile" do
    let(:edit_profile_user) { create :user_with_address_and_birthday }
    let(:other_user) { create :user_with_address_and_birthday }

    context "when not logged in" do
      before do
        visit edit_user_path(edit_profile_user)
      end

      it_should_behave_like 'the login page'
    end

    context "when logged in as a non-admin user" do
      before do
        log_in_user edit_profile_user
        click_link 'Edit My Profile'
      end

      it "does not allow editing first_name" do
        expect(find('#user_first_name')[:disabled]).to be_true
      end

      it "does not allow editing last_name" do
        expect(find('#user_last_name')[:disabled]).to be_true
      end

      it "does not allow editing department" do
        expect(find('#user_department_id')[:disabled]).to be_true
      end

      it "does not allow editing start_date" do
        expect(find('#user_start_date')[:disabled]).to be_true
      end

      it "does not allow editing birthday" do
        expect(find('#user_birthday')[:disabled]).to be_true
      end

      it "displays only the birthday month and day" do
        expect(find('#user_birthday').value).to eq(edit_profile_user.birthday.strftime("%-m/%-d"))
      end

      it "allows editing phone number" do
        expect(find('#user_phone')[:disabled]).not_to be_true
      end

      it "allows editing email" do
        expect(find('#user_email')[:disabled]).not_to be_true
      end

      it "allows editing address" do
        expect(find('#user_address')[:disabled]).not_to be_true
      end

      it "allows editing password" do
        expect(find('#user_password')[:disabled]).not_to be_true
      end

      it "allows editing password confirmation" do
        expect(find('#user_password_confirmation')[:disabled]).not_to be_true
      end

      it "does not show the admin option" do
        expect(page).not_to have_selector('input#user_admin_0')
      end

      context "performing the update" do
        before do
          fill_in 'Phone', with: '212-212-2121'
          fill_in 'Address', with: 'My New Address'
          click_button 'Update User'
          edit_profile_user.reload
        end

        it "displays the user show screen" do
          expect(page).to have_selector('legend',
            text: "#{edit_profile_user.first_name} #{edit_profile_user.last_name}")
        end

        it "displays the success message" do
          expect(page).to have_selector('div.alert.alert-dismissable.alert-success',
                                        text: 'User was successfully updated.')
        end

        it "saves the updated phone to the database" do
          expect(edit_profile_user.phone).to eq('212-212-2121')
        end

        it "saves the updates address to the database" do
          expect(edit_profile_user.address).to eq('My New Address')
        end
      end

      context "when attempting to edit another person's profile" do
        before { log_in_user edit_profile_user, no_capybara: true }

        context "sending get to edit" do
          before { get edit_user_path other_user }

          it "redirects to the correct user's profile" do
            expect(response).to redirect_to(edit_user_url edit_profile_user)
          end
        end

        context "sending patch to update" do
          before { patch user_path other_user }

          it "redirects to the correct user's profile" do
            expect(response).to redirect_to(edit_user_url edit_profile_user)
          end
        end
      end
    end

    context "when logged in as an admin user" do
      before do
        admin_user.update_attribute(:birthday, '1976-06-01')
        log_in_user admin_user
        click_link 'Edit My Profile'
      end

      it "allows editing first_name" do
        expect(find('#user_first_name')[:disabled]).not_to be_true
      end

      it "allows editing last_name" do
        expect(find('#user_last_name')[:disabled]).not_to be_true
      end

      it "allows editing department" do
        expect(find('#user_department_id')[:disabled]).not_to be_true
      end

      it "allows editing start_date" do
        expect(find('#user_start_date')[:disabled]).not_to be_true
      end

      it "allows editing birthday" do
        expect(find('#user_birthday')[:disabled]).not_to be_true
      end

      it "displays the full birthday" do
        expect(find('#user_birthday').value).to eq(admin_user.birthday.strftime("%Y-%m-%d"))
      end

      it "allows editing phone number" do
        expect(find('#user_phone')[:disabled]).not_to be_true
      end

      it "allows editing email" do
        expect(find('#user_email')[:disabled]).not_to be_true
      end

      it "allows editing address" do
        expect(find('#user_address')[:disabled]).not_to be_true
      end

      it "allows editing password" do
        expect(find('#user_password')[:disabled]).not_to be_true
      end

      it "allows editing password confirmation" do
        expect(find('#user_password_confirmation')[:disabled]).not_to be_true
      end

      it "allows editing admin option" do
        expect(page).to have_selector('input#user_admin_0')
      end
    end
  end
end