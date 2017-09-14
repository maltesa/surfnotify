# Handles Provider (MSW etc) specific actions
class ProviderController < ApplicationController
  # GET /provider/msw/find/:query
  def msw_search_spots
    spots = MSW::Provider.search_spots(params[:query])
    render json: spots
  end
end
