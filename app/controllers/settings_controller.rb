class SettingsController < ApplicationController
  # GET /settings
  def edit
    @user = current_user
  end

  # PATCH/PUT /settings
  # PATCH/PUT /settings.json
  def update
    @user = current_user
    respond_to do |format|
      if @user.update(setting_params)
        format.html { redirect_to settings_path, notice: 'Settings were successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def setting_params
    params.require(:user).permit(:pb_enabled, :pb_token, :mail_enabled, :notification_mail)
  end

end
