# config/initializers/sidekiq.rb
# frozen_string_literal: true

redis_url = case Rails.env
when 'staging'
  "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}/1"
when 'testing'
  "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}/2"
else
  "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}/0"
end

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
