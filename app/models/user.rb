class User < ApplicationRecord
  has_many :storages

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  validate :email_input
  validate :password_input

  def email_input
    return if RailsValidator.validate_email(email)

    errors.add :email, 'is not a valid email'
  end

  def password_input
    return if RailsValidator.validate_password(password) 

    errors.add :password, 'should include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end
end
