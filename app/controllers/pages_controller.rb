class PagesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    # if !user_signed_in?
    #   flash[:notice] = "Sign in to access"
    # end
  end
end
