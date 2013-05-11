# Be sure to restart your server when you modify this file.

Sepia::Application.config.session_store :cookie_store, key: '_sepia_session'
# Sepia::Application.config.session_store :redis_store, :servers => { :host => "localhost", :port => 6379, :namespace => "sepia:sessions" }, :expire_in => 120.minutes
