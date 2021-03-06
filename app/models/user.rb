class User < ActiveRecord::Base
  belongs_to :department

  default_scope -> { order('last_name, first_name') }
  scope :in_department, lambda { |dept_id| where(department_id: dept_id) }
  scope :with_name,
        lambda { |name| where("lower(first_name) LIKE ? or lower(last_name) LIKE ?",
                              "%#{name.downcase}%", "%#{name.downcase}%" ) }

  before_create :create_remember_token

  validates :first_name, :last_name, presence: true, length: { maximum: 50 }
  validates :department_id, presence: true
  validates :phone, presence: true,
             format: { with: EmployeeDirectory::VALID_PHONE_REGEX }
  validates :email, presence: true,
            format: { with: EmployeeDirectory::VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :address, length: { maximum: 200 }
  validates :start_date, date: true
  validates :birthday, date: true, allow_blank: true
  validates :password, length: { minimum: 6 }, on: :create
  validates :password, length: { minimum: 6 }, on: :update, if: :password

  has_secure_password
  self.per_page = 15

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
