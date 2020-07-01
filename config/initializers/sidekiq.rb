case Rails.env
  when 'production'
    url = 'redis://redistogo:752241e4625b430df005ad562d1c7e5c@pike.redistogo.com:11587/'
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