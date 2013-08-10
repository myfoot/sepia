# Be sure to restart your server when you modify this file.

if Rails.env.production? and ENV['REDISTOGO_URL']
  redis_uri = URI(ENV['REDISTOGO_URL'])
  Sepia::Application.config.session_store :redis_store, :servers => {
    host: redis_uri.host,
    port: redis_uri.port,
    password: redis_uri.password,
    namespace: "sepia:sessions"
  }, expire_in: 120.minutes
else
  Sepia::Application.config.session_store :redis_store, :servers => { :host => "localhost", :port => 6379, :namespace => "sepia:sessions" }, :expire_in => 120.minutes
end

