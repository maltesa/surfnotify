module ApplicationHelper
  def enum_options_for_select(model, attribute)
    Object.const_get(model.to_s.upcase_first).send(attribute.to_s.pluralize).map do |key, val|
      [I18n.t("activerecord.attributes.#{model}.#{attribute.to_s.pluralize}.#{key}"), val]
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def flash2bootstrap(key)
    case key.to_sym
    when :error
      'danger'
    when :alert
      'warning'
    when :notice
      'info'
    else
      key.to_s
    end
  end
end
