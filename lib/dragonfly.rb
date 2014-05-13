Dragonfly.app.configure do    
  plugin :imagemagick
  url_format '/media/:job/:name'    
  datastore :s3, {:bucket_name => ENV['S3_BUCKET_NAME'], :access_key_id => ENV['S3_ACCESS_KEY'], :secret_access_key => ENV['S3_SECRET']}   
  
  define_url do |app, job, opts|    
    if thumb = Thumb.find_by(signature: job.signature)
      app.datastore.url_for(thumb.uid)
    else
      app.server.url_for(job)
    end
  end

  before_serve do |job, env|
    uid = job.store
    Thumb.create!(uid: uid, signature: job.signature)
  end
  
end