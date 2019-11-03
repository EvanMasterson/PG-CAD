class PagesController < ApplicationController
  before_action :authenticate_user!, except: :index
  
  def index
  end

  def profile
    @user = User.find_by_email(current_user.email)
  end
end
