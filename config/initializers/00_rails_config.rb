RailsConfig.setup do |config|
  config.const_name = "Settings"
end

if Rails.env.production?
  Settings[:social] = RailsConfig::Options.new({
    twitter: RailsConfig::Options.new({
      consumer_key:    ENV['TWITTER_KEY'],
      consumer_secret: ENV['TWITTER_SECRET']
    }),
    facebook: RailsConfig::Options.new({
       consumer_key:    ENV['FACEBOOK_KEY'],
       consumer_secret: ENV['FACEBOOK_SECRET']
    }),
    google: RailsConfig::Options.new({
       consumer_key:    ENV['GOOGLE_KEY'],
       consumer_secret: ENV['GOOGLE_SECRET']
    })
  })
end
