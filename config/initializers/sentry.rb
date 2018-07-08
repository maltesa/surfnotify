if Rails.env.production?
  Raven.configure do |config|
    config.dsn = 'https://d7a6658f878c42a4bd4d417d25527209:44d1ae3430984a8291bccafe638dddbd@sentry.surfnotify.com/2'
  end
end
