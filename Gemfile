source 'https://rubygems.org'

ruby '2.0.0'
gem 'unicorn'
gem 'padrino', '0.12.0'
gem 'rake'

# Admin
gem 'will_paginate', github: 'mislav/will_paginate'
gem 'activate-admin', github: 'wordsandwriting/activate-admin'

# Data storage
gem 'mongoid', github: 'mongoid/mongoid', ref: 'e1b32e598ec231cc7a7e191fd0432e4cd4910447'
gem 'dragonfly'

# Authentication
gem 'bcrypt'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-linkedin'

# Caching
gem 'rack-cache'
gem 'memcachier'
gem 'dalli'

# Error reporting
gem 'airbrake'

group :production do  
  gem 'dragonfly-s3_data_store'   
end

group :development, :test do
  gem 'dragonfly-mongo_data_store'
  gem 'bson_ext'
end

group :test do
  gem 'factory_girl'
  gem 'turn'
  gem 'capybara'
end