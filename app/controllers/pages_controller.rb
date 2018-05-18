class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'onepager', only: :index

  def index; end
  def terms; end
  def privacy_policy; end
end
