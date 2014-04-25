def log_in_user(user, options={})
  visit login_path
  fill_in "email", with: options[:email] || user.email.upcase
  fill_in "password", with: options[:password] || user.password
  click_button 'Log in'
end