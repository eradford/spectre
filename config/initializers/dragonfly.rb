require 'dragonfly'
require_relative '../../app/datastores/dragonfly/active_record_data_store'
require_relative '../../app/datastores/dragonfly/composite_data_store'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "5fc2f8d11fb3d4ad28a4c4e3e353d2ca9e041e14930d48a5c1242613f9cdd2cc"

  url_format "/media/:job/:name"

  datastore CompositeDataStore.new(
    ActiveRecordDataStore.new,
    # If you want to use S3 to store your screenshots, comment the next section
    # and uncomment the S3 datastore section.
    Dragonfly::FileDataStore.new(
      root_path: Rails.root.join('public/system/dragonfly', Rails.env),
      server_root: Rails.root.join('public')
    )

    #  Dragonfly::S3DataStore.new(
    #    bucket_name: 'YOUR_S3_BUCKET',
    #    access_key_id: 'YOUR_ACCESS_KEY',
    #    secret_access_key: 'YOUR_SECRET_ACCESS_KEY'
    # )
  )
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
