class User < ApplicationRecord
  has_many :storages

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :timeoutable, :lockable

  validate :email_input
  validate :password_input
  validate  :selected_package

  # using hash to show string on the view but save integer to the database => restirict data that can be saved
  PACKAGES = Hash[ 5 => 'FREE - 5GB Storage', 25 => 'PLUS - 25GB Storage', 50 => 'EXTRA - 50GB Storage' ]

  def email_input
    # use our custom gem to validate email address with a regex returns true or false
    unless RailsValidator.validate_email(email)
      errors.add :email, 'is not a valid email'
    end
  end

  def password_input
      # use our custom gem to validate password with a regex returns true or false
    unless RailsValidator.validate_password(password)
      errors.add :password, 'should include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
    end
  end
end
