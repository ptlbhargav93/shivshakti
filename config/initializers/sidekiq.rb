case Rails.env
  when 'production'
    url = 'redis://127.0.0.1:6379/12'
  when 'staging'
    url = 'redis://staging:6379/12'
  else
    url = 'redis://localhost:6379/12'
end

Sidekiq.configure_server do |config|
  config.redis = { url: url, namespace: "sidekiq-#{Rails.env}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: url, namespace: "sidekiq-#{Rails.env}" }
end

Sidekiq::Extensions.enable_delay!