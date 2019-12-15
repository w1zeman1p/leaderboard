Rails.application.config.middleware.use OmniAuth::Builder do
  provider :snapchat, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end
