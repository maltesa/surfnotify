# handle user settings and data
class UsersController < ApplicationController
  # GET /users/edit
  def edit
    @user = current_user
  end

  # PATCH /users/edit
  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path, flash: { success: t('flash.success.update', thing: 'Profile') }
    else
      render :edit
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:mail_enabled, :notification_mail, :pb_enabled, :pb_token)
  end
end
