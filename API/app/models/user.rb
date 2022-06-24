class User < ApplicationRecord
  validates :first_name, :last_name, :address, :date_of_birth, :role_id, presence: true
  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates :email, uniqueness: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.authenticate(email, password)
    user = User.find_for_authentication(email:)
    user&.valid_password?(password) ? user : nil
  end

  has_many :examinations, foreign_key: 'user_id', class_name: 'examination'
end
