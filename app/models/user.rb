class User < ApplicationRecord
  has_and_belongs_to_many :storages

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  validate :password_complexity

  def password_complexity
    # https://github.com/plataformatec/devise/wiki/How-To:-Set-up-simple-password-complexity-requirements
    return if password.blank? || password =~ /\A(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[\W]).{8,}\z/

    errors.add :password, 'should include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end
end
