# Model for user defined notifications
class Notification < ApplicationRecord
  attr_accessor :spot_name
  alias_attribute :silent?, :silent
  enum provider: ['MagicSeaweed']
  belongs_to :forecast, primary_key: :spot, foreign_key: :spot
  belongs_to :user

  # make sure forecast exists before rules are applied to it
  # lifecycle: before_validation -> ... -> before_save -> ...
  # pull is automatically called for a forecast on creation which triggers the
  # apply_rules_and_notify for this notification when finished
  before_validation :create_missing_forecast
  # reapply rules and notify since parameters may be modified
  before_update :apply_rules_and_notify

  # validations
  validates :provider, :spot, :rules, :user, :forecast, presence: true
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

  # applies rules to new forecast and notify user about changes
  # WARNING: This methods does not persist data. Make sure save is called afterwards or it is called
  #          in a hook before save
  def apply_rules_and_notify
    # copy old filtered forecast for diff
    old_filtered_forecast = filtered_forecast_cache.dup
    self.filtered_forecast_cache = forecast.filter_by(rules)
    # create diff between old and new filtered forecast
    diff = Diff.new(old: old_filtered_forecast, new: filtered_forecast_cache)

    # dont send notifications for silenced notifications
    return if silent
    # Notify user about changes if there are any changes (checked in notify method)
    user.notify(forecast.spot_name, spot_url, diff)
  end

  # create if forecast for spot in notification is not existing
  def create_missing_forecast
    forecast = Forecast.find_by(spot: spot, provider: provider)
    return forecast unless forecast.blank?
    Forecast.create(provider: provider, spot: spot, spot_name: spot_name)
  end

  def json_is_valid
    # TODO: check whether rule fits selected provider
    errors.add(:rules, 'The given rules are invalid!') if rules[:error]
  end

  def matching_forecasts
    # update cache if forecast data is newer then this
    apply_rules_and_notify if forecast.updated_at > updated_at
    # return filtered forecasts
    filtered_forecast_cache || []
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

  def sorted_params_with_rules
    params_with_rules.sort_by { |e| e[:activated] ? 0 : 1 }
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

  # fix for breaking msw urls
  def spot_url
    if provider == 'MagicSeaweed' && !spot.end_with?('/')
      "#{spot}/"
    else
      spot
    end
  end
end
