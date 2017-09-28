# handles stored forecasts
class Forecast < ApplicationRecord
  before_create :pull
  has_many :notifications, primary_key: :spot, foreign_key: :spot

  def filter_by(rules)
    constraints = MSW::Provider.rules2constraints(rules)
    MSW::Provider.filter_by(constraints, forecast)
  end

  def forecast
    @forecast ||= read_attribute(:forecast).map do |unit|
      unit['time'] = DateTime.parse unit['time']
      unit.with_indifferent_access
    end
  end

  def pull
    provider = MSW::Provider.new spot
    self.forecast = provider.pull
  end
end
