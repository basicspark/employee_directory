shared_examples_for "a record with valid phone number" do
  it "does not allow invalid phone numbers" do
    bad_numbers = ["123", "123 444 1212", "312 454 5765", "(122) 223-2332",
                   "232-2323232","(122) 444 1212", "232-233-293S", "232-232-232",
                   "2223331212", "22212312344", "112-654-5557"]
    bad_numbers.each do |bad_number|
      subject.__send__("phone=", bad_number)
      expect(subject).not_to be_valid
    end
  end
end

shared_examples_for 'all pages with logged out users' do
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

shared_examples_for 'all pages with logged in admin users' do
  it "shows the Directory link in the top menu" do
    expect(page).to have_link('Directory', href: directory_path)
  end

  it "shows the Edit My Profile link in the top menu" do
    expect(page).to have_link('Edit My Profile',
                              href: path_to_test)
  end

  it "shows the Maintenance dropdown" do
    expect(page).to have_selector('a', text: 'Maintenance')
  end

  it "shows the User Maintenance link" do
    expect(page).to have_link('Users')
  end

  it "shows the Department Maintenance link" do
    expect(page).to have_link('Departments', href: departments_path)
  end

  it "shows the Logout link in the top menu" do
    expect(page).to have_link('Logout', href: logout_path)
  end
end

shared_examples_for 'all pages with logged in non-admin users' do
  it "shows the Directory link in the top menu" do
    expect(page).to have_link('Directory', href: directory_path)
  end

  it "shows the Edit My Profile link in the top menu" do
    expect(page).to have_link('Edit My Profile',
                              href: path_to_test)
  end

  it "does not show the Maintenance dropdown" do
    expect(page).not_to have_selector('a', text: 'Maintenance')
  end

  it "does not show the User Maintenance link" do
    expect(page).not_to have_link('Users')
  end

  it "does not show the Department Maintenance link" do
    expect(page).not_to have_link('Departments', href: departments_path)
  end

  it "shows the Logout link in the top menu" do
    expect(page).to have_link('Logout', href: logout_path)
  end
end

shared_examples_for 'the login page' do
  it "displays the login form instructions" do
    expect(page).to have_selector('h2.form-signin-heading',
                                  text: 'Please log in')
  end

  it "shows the Login link as active" do
    expect(page).to have_selector('li.active', text: 'Login')
  end
end

shared_examples_for 'the failed login page' do
  it_should_behave_like 'the login page'
  it_should_behave_like 'all pages with logged out users'

  it "displays the login error message" do
    expect(page).to have_selector('div.alert.alert-dismissable.alert-danger',
                                  text: "Incorrect username/password combination. Please try again.")
  end
end

shared_examples_for 'a list of users' do
  it "displays the user list screen" do
    expect(page).to have_selector('th', text: 'Last Name')
  end
end

shared_examples_for 'the directory page' do
  it_should_behave_like 'a list of users'

  it "shows the Directory link as active" do
    expect(page).to have_selector('li.active', text: 'Directory')
  end

  it "does not have the edit or delete links" do
    expect(page).not_to have_selector('ul.user-actions')
  end
end

shared_examples_for 'the user maintenance page' do
  it_should_behave_like 'a list of users'

  it "shows the Maintenance link as active" do
    expect(page).to have_selector('li.active', text: 'Maintenance')
  end

  it "has the edit and delete links" do
    expect(page).to have_selector('ul.user-actions')
  end
end



