# Model for user defined notifications
class Notification < ApplicationRecord
  before_update :apply_rules_and_notify
  before_validation :create_missing_forecast
  belongs_to :user
  belongs_to :forecast, primary_key: :spot, foreign_key: :spot
  enum provider: ['MagicSeaweed']
  validates :name, :provider, :spot, :rules, :user, :forecast, presence: true
  validate :json_is_valid

  def self.params_for(provider)
    case provider
    when 'MagicSeaweed'
      MSW::Provider.params.select { |p| p[:visible] }
    end
  end

  def activated_rules
    rules.select { |_, v| v[:activated] == true }
  end

  def activated_rules_with_params
    params_with_rules.select { |v| v[:activated] == true }
  end

  # apply rules to new forecast
  def apply_rules_and_notify
    # keep old filtered forecast for diff
    old_filtered_forecast = filtered_forecast_cache.dup
    filtered_forecast_cache = forecast.filter_by(rules)
    # create diff between old and new filtered forecast
    diff = Helpers.forecast_diff(old: old_filtered_forecast, new: filtered_forecast_cache)
    logger.info "DIFF: #{diff.inspect}"
    # notify user if changes occured
    user.notify(self, diff) if diff.present?
    # return filtered forecast
    filtered_forecast_cache
  end

  # relate forecast corresponding to spot
  def create_missing_forecast
    forecast = Forecast.find_by(spot: spot, provider: provider)
    return unless forecast.blank?
    Forecast.create(provider: provider, spot: spot)
  end

  def json_is_valid
    # TODO: check whether rule fits selected provider
    errors.add(:rules, 'The given rules are invalid!') if rules[:error]
  end

  def matching_forecasts
    # return cache if forecast data is older then this
    return filtered_forecast_cache if forecast.updated_at < updated_at
    # update cache and save
    apply_rules_and_notify
    save
  end

  def params_with_rules
    return if rules[:error]
    Notification.params_for(provider).map do |param|
      rule = rules[param[:key]] || param[:default] || {}
      param.tap do |p|
        p[:activated] = rule[:activated]
        p[:value] = rule[:value]
      end
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
