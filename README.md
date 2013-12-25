activate-template
=================

Activate Digital Padrino/Mongoid template project.

## Other useful gems
```
# Autolinking
# gem 'rinku'

# Email
# gem 'mail'
# gem 'premailer'

# Asynchronous tasks
# gem 'delayed_job_mongoid', github: 'shkbahmad/delayed_job_mongoid'
# gem 'hirefire-resource'

# Interacting with other websites
# gem 'mechanize'
# gem 'oauth'
# gem 'twitter'
# gem 'koala'
# gem 'hominid'
# gem 'restforce'
# gem 'heroku-api'

# Caching
# gem 'rack-cache'
# gem 'memcachier'
# gem 'dalli'
```

## Rack::Cache
```ruby
use Rack::Cache, :metastore => Dalli::Client.new, :entitystore  => 'file:tmp/cache/rack/body', :allow_reload => false
```

## Delayed::Job + Airbrake
```ruby
module Delayed
  class Worker
    alias_method :original_handle_failed_job, :handle_failed_job

    protected
    def handle_failed_job(job, error)
      Airbrake.notify(error)
      original_handle_failed_job(job,error)
    end
  end
end
```

## Delayed::Job + Hirefire
```ruby
use HireFire::Middleware # config.ru

HireFire::Resource.configure do |config|
  config.dyno(:worker) do
    HireFire::Macro::Delayed::Job.queue(:mapper => :mongoid)
  end
end
```

## Padrino::Mailer with Gmail
```ruby
register Padrino::Mailer
set :delivery_method, :smtp => {:user_name => ENV['GMAIL_USERNAME'], :password => ENV['GMAIL_PASSWORD'], :address => "smtp.gmail.com", :port => 587, :authentication => :plain, :enable_starttls_auto => true}
```
