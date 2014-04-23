module EmployeeDirectory
  # This is where we keep application-wide constants
  VALID_PHONE_REGEX = /\A[2-9]\d{2}-[2-9]\d{2}-\d{4}\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
end
