class Department < ActiveRecord::Base
  has_many :users

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :name, :location, length: { maximum: 50 }
  validates :phone, format: { with: EmployeeDirectory::VALID_PHONE_REGEX },
            allow_blank: true

end
