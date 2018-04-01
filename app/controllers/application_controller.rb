class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_raven_context
  before_action :authenticate_user!

  private


  def after_sign_in_path_for(resource)
    notifications_path
  end

  private

  def set_raven_context
    user_id = current_user.id unless current_user.nil?
    Raven.user_context(id: user_id)
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
