activate-template
=================

Activate Digital Padrino/Mongoid template project.

Using Rack::Cache:
```ruby
use Rack::Cache, :metastore => Dalli::Client.new, :entitystore  => 'file:tmp/cache/rack/body', :allow_reload => false
```

Using Padrino::Mailer with Gmail:
```ruby
register Padrino::Mailer
set :delivery_method, :smtp => {:user_name => ENV['GMAIL_USERNAME'], :password => ENV['GMAIL_PASSWORD'], :address => "smtp.gmail.com", :port => 587, :authentication => :plain, :enable_starttls_auto => true}
```