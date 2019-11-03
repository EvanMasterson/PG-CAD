class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  validate :password_complexity

  def password_complexity
    # https://github.com/plataformatec/devise/wiki/How-To:-Set-up-simple-password-complexity-requirements
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

    errors.add :password, 'should include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end
end