class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :edit, :update, :destroy, :toggle_silent]
  before_action :authenticate_user!

  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = Notification.includes(:forecast)
                                 .where(user: current_user)
                                 .with_spot_name
                                 .order('spot_name')
  end

  # GET /notifications/new
  def new
    @notification = Notification.new
  end

  # GET /notifications/1/edit
  def edit; end

  # POST /notifications
  # POST /notifications.json
  def create
    @notification = Notification.new notification_params
    @notification.user = current_user

    respond_to do |format|
      if @notification.save
        format.html { redirect_to notifications_path, notice: 'Notification was successfully created.' }
        format.json { render :show, status: :created, location: @notification }
      else
        format.html { render :new }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notifications/1
  # PATCH/PUT /notifications/1.json
  def update
    respond_to do |format|
      if @notification.update(notification_params)
        format.html { redirect_to notifications_path, notice: 'Notification was successfully updated.' }
        format.json { render :show, status: :ok, location: @notification }
      else
        format.html { render :edit }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_path, notice: 'Notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def toggle_silent
    @notification.silent = !@notification.silent
    @notification.save
    respond_to do |format|
      format.html do
        verb = @notification.silent ? 'silenced' : 'desilenced'
        redirect_to notifications_path, notice: "Notification was successfully #{verb}."
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_notification
    @notification = Notification.find_by(id: params[:id], user: current_user)
    redirect_to notifications_path if @notification.nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def notification_params
    params.require(:notification).permit(:provider, :spot, :spot_name, :rules)
  end
end
