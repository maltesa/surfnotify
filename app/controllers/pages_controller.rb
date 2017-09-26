class PagesController < ApplicationController
  def index 
  	if current_user
      @user = current_user
      @notification = Notification.where(user_id: @user.id.to_i)
      redirect_to notifications_path
    else
    redirect_to landing_url, :method => :get
	end
  end
end
