class User < ActiveRecord::Base
  belongs_to :department

  validates :first_name, :last_name, presence: true, length: { maximum: 50 }
  validates :department_id, presence: true
  validates :phone, presence: true,
             format: { with: EmployeeDirectory::VALID_PHONE_REGEX }
  validates :email, presence: true,
            format: { with: EmployeeDirectory::VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :address, length: { maximum: 200 }
  validates :user_type, inclusion: { in: (0..2) }
  validates :start_date, date: true
  validates :birthday, date: true, allow_blank: true
end
