# Model for user defined notifications
class Notification < ApplicationRecord
  before_update :apply_rules
  before_validation :create_missing_forecast
  belongs_to :user
  belongs_to :forecast, primary_key: :spot, foreign_key: :spot
  enum provider: ['MagicSeaweed']
  validates :name, :provider, :spot, :rules, :user, :forecast, presence: true
  validate :json_is_valid

  def activated_rules
    rules.select { |_, v| v[:activated] == true }
  end

  def activated_rules_with_params
    params_with_rules.select { |v| v[:activated] == true }
  end

  def apply_rules
    # apply rules to new forecast
    old_filtered_forecast = filtered_forecast_cache.dup
    self.filtered_forecast_cache = forecast.filter_by(rules)
    # create diff to old cache
    diff = Helpers.forecast_diff(old: old_filtered_forecast, new: filtered_forecast_cache)
    # notify user if changes occured
    user.notify(diff) if diff.present?
    # return filtered forecast
    filtered_forecast_cache
  end

  # relate forecast corresponding to spot
  def create_missing_forecast
    forecast = Forecast.find_by(spot: spot, provider: provider)
    return unless forecast.blank?
    Forecast.create(provider: provider, spot: spot)
  end

  def filtered_forecast_cache
    read_attribute(:filtered_forecast_cache).map do |unit|
      unit['time'] = DateTime.parse unit['time'] if unit['time'].is_a? String
      unit.with_indifferent_access
    end
  end

  def json_is_valid
    # TODO: check whether rule fits selected provider
    errors.add(:rules, 'The given rules are invalid!') if rules[:error]
  end

  def matching_forecasts
    # return cache if forecast data is older then this
    return filtered_forecast_cache if forecast.updated_at < updated_at
    # update cache and save
    apply_rules
    save
  end

  def params_with_rules
    return if rules[:error]
    self.class.params_for(provider).map do |param|
      rule = rules[param[:key]] || param[:default] || {}
      param.tap do |p|
        p[:activated] = rule[:activated]
        p[:value] = rule[:value]
      end
    end
  end

  def self.params_for(provider)
    case provider
    when 'MagicSeaweed'
      MSW::Provider.params
    end
  end

  def rules
    read_attribute(:rules).with_indifferent_access
  end

  def rules=(rules)
    write_attribute(:rules,
                    begin
                      JSON.parse(rules)
                    rescue JSON::ParserError
                      { error: true }
                    end)
  end
end
