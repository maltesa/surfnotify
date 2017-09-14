json.extract! notification, :id, :name, :provider, :spot, :rules, :user_id, :created_at, :updated_at
json.url notification_url(notification, format: :json)
