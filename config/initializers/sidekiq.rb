
# if Rails.env.production? and (redis_url = ENV['REDISTOGO_URL'])
#   Sidekiq.configure_server do |config|
#     config.redis = { :url => redis_url, :namespace => 'sidekiq' }
#   end

#   Sidekiq.configure_client do |config|
#     config.redis = { :url => redis_url, :namespace => 'sidekiq' }
#   end
# end
