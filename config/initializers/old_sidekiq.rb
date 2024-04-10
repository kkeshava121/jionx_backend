# config/initializers/sidekiq.rb
Sidekiq.configure_server do |config|
  config.concurrency = 5
  config.redis = { url: 'redis://localhost:6379/0' } # Replace with your Redis server URL if needed
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0' } # Replace with your Redis server URL if needed
end
