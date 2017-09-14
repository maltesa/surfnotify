# Model for user defined notifications
class Notification < ApplicationRecord
  belongs_to :user
  enum provider: ['MagicSeaweed']
  validates :name, :provider, :spot, :rules, :user, presence: true
  validate :json_rules

  def json_rules
    # TODO, check whether rule fit selected provider
    errors.add(:rules, 'The given rules are invalid!') if rules[:error]
  end

  def rules
    @rules ||= JSON.parse(read_attribute(:rules).to_s, symbolize_names: true) || {}
  rescue JSON::ParserError
    { error: true }
  end

  def params_with_rules
    return if rules[:error]
    self.class.params_for(provider).map do |param|
      val = rules[param[:key]] || param[:default]
      param.tap { |p| p[:value] = val }
    end
  end

  def self.params_for(provider)
    case provider
    when 'MagicSeaweed'
      MSW::Provider.params
    end
  end
end
