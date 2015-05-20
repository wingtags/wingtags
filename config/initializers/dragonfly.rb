require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "a2e50e21938297f62c2fd5160e39703f1437d2169a822c97ef1a973693f81f48"

  url_format "/images"

  datastore :s3,
  	region: 'ap-southeast-2',
    bucket_name: 'wingtags-syd',
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    root_path: "images"
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware