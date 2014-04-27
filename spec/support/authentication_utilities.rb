def log_in_user(user, options={})
  if options[:no_capybara]
    # Sign in without Capybara
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
  else
    # Sign in using Capybara
    visit login_path
    fill_in "email", with: options[:email] || user.email.upcase
    fill_in "password", with: options[:password] || user.password
    click_button 'Log in'
  end
end