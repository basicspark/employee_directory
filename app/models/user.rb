class User < ActiveRecord::Base

  VALID_PHONE_REGEX = /\A[2-9]\d{2}-[2-9]\d{2}-\d{4}\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :first_name, :last_name, presence: true, length: { maximum: 50 }
  validates :department_id, presence: true
  validates :phone, presence: true, format: { with: VALID_PHONE_REGEX }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :address, length: { maximum: 200 }
  validates :user_type, inclusion: { in: (0..2) }

end
