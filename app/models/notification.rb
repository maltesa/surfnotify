# Model for user defined notifications
class Notification < ApplicationRecord
  before_validation :create_missing_forecast
  belongs_to :user
  belongs_to :forecast, primary_key: :spot, foreign_key: :spot
  enum provider: ['MagicSeaweed']
  validates :name, :provider, :spot, :rules, :user, :forecast, presence: true
  validate :json_is_valid

  # relate forecast corresponding to spot
  def create_missing_forecast
    forecast = Forecast.find_by(spot: spot, provider: provider)
    return unless forecast.blank?
    Forecast.create(provider: provider, spot: spot)
  end

  def json_is_valid
    # TODO, check whether rule fits selected provider
    errors.add(:rules, 'The given rules are invalid!') if rules[:error]
  end

  def matching_forecasts
    forecast.filter_by(rules)
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
