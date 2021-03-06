MessageBus.configure(backend: :redis, url: (ENV['REDIS_QUEUE_URL'] || ENV.fetch('REDIS_URL', 'redis://localhost:6379')))

# MessageBus.enable_diagnostics # Must be called after `MessageBus.after_fork` if using a forking webserver
# MessageBus.user_id_lookup do |_env|
#   1
# end

# might this for devise
Rails.application.config do |config|
  # See https://github.com/rails/rails/issues/26303#issuecomment-442894832
  MyAppMessageBusMiddleware = Class.new(MessageBus::Rack::Middleware)
  config.middleware.delete(MessageBus::Rack::Middleware)
  config.middleware.insert_after(Warden::Manager, MyAppMessageBusMiddleware)
end

MessageBus.configure(on_middleware_error: proc do |env, e|
  # env contains the Rack environment at the time of error
  # e contains the exception that was raised
  if Errno::EPIPE === e
    [422, {}, [""]]
  else
    raise e
  end
end)

MessageBus.user_id_lookup do |env|
  req = Rack::Request.new(env)

  if req.session && req.session["warden.user.user.key"] && req.session["warden.user.user.key"][0][0]
    user = User.find(req.session["warden.user.user.key"][0][0])
    user.id
  end
end

MessageBus.group_ids_lookup do |env|
  req = Rack::Request.new(env)

  if req.session && req.session["warden.user.user.key"] && req.session["warden.user.user.key"][0][0]
    user = User.find(req.session["warden.user.user.key"][0][0])
    user.group_ids
  end
end
