if defined? Dragonfly
  
  app = Dragonfly[:dragonfly].configure_with(:imagemagick) do |c|
    c.url_format = '/media/:job/:basename.:format'  
  end
  
  app.analyser.register(Dragonfly::Analysis::FileCommandAnalyser)

  if Padrino.env == :production
    # app.datastore = Dragonfly::DataStorage::S3DataStore.new
    # app.datastore.configure do |d|
    #   d.bucket_name = ENV['S3_BUCKET_NAME']
    #   d.access_key_id = ENV['S3_ACCESS_KEY']
    #   d.secret_access_key = ENV['S3_SECRET']
    # end
    app.datastore = Dragonfly::DataStorage::MongoDataStore.new
    app.datastore.configure do |c|
      c.host = ENV['MONGOHQ_URL'].split('@').last.split(':').first
      c.port = ENV['MONGOHQ_URL'].split('@').last.split(':').last.split('/').first
      c.database = ENV['MONGOHQ_URL'].split('/')[3]
      c.username = ENV['MONGOHQ_URL'].split('://').last.split(':').first
      c.password = ENV['MONGOHQ_URL'].split('://').last.split('@').first.split(':').last
    end        
  else
    app.datastore = Dragonfly::DataStorage::MongoDataStore.new
    # app.datastore.configure do |c|
    #   c.root_path = "#{PADRINO_ROOT}/public/media"
    #   c.server_root = "#{PADRINO_ROOT}/public"
    # end
  end

  app.define_macro_on_include(Mongoid::Document, :dragonfly_accessor)
  
end