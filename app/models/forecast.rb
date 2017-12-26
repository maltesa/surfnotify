# handles stored forecasts
class Forecast < ApplicationRecord
  before_create :pull
  has_many :notifications, primary_key: :spot, foreign_key: :spot

  # filter this forecast by given rules
  def filter_by(rules)
    # TODO: select correct provider when multiple exist
    constraints = MSW::Provider.rules2constraints(rules)
    MSW::Provider.filter_by(constraints, forecast)
  end

  # update forecast data from provider
  def pull
    # TODO: select correct provider when multiple exist
    provider = MSW::Provider.new spot
    self.forecast = provider.pull
  end
end
