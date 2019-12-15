p Rails.application.credentials.fetch(:snapchat_dev_client_id)
p Rails.application.credentials.fetch(:snapchat_dev_secret)

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :snapchat,
    Rails.application.credentials.fetch(:snapchat_dev_client_id),
    Rails.application.credentials.fetch(:snapchat_dev_secret),
    scope: 'https://auth.snapchat.com/oauth2/api/user.display_name https://auth.snapchat.com/oauth2/api/user.bitmoji.avatar'
  )
end
