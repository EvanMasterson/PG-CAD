class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  
  def index
    if current_user
      @user = User.find_by_email(current_user.email)
      @size_used = 0
      @user.storages.each do |storage|
        if storage.size
          @size_used += storage.size
        end
      end
    end
  end

  def profile
    @user = User.find_by_email(current_user.email)
  end
end
