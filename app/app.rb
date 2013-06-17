module ActivateApp
  class App < Padrino::Application
    register Padrino::Rendering
    register Padrino::Helpers
    register Sinatra::SimpleNavigation
    helpers Kaminari::Helpers::SinatraHelpers  
    helpers ActivateApp::DatetimeHelpers
    helpers ActivateApp::ParamHelpers  
    use Dragonfly::Middleware, :dragonfly
    
    set :sessions, :expire_after => 1.year
    # set :show_exceptions, true
    
    register Sinatra::AssetPack
    assets {
      serve '/css', from: '/assets/stylesheets'
      serve '/font', from: '/assets/fonts'
      serve '/js', from: '/assets/javascripts'
      serve '/images', from: '/assets/images'
      css :app, [
        '/css/bootstrap.min.css',
        '/css/bootstrap-responsive.min.css',
        '/css/font-awesome.min.css',
        '/css/bootstrap-wysihtml5-0.0.2.css'
      ]
      js :app, [
        '/js/jquery-1.9.1.min.js',
        '/js/jquery-migrate-1.1.1.js',
        '/js/jquery-ujs.js',
        '/js/bootstrap.min.js',
        '/js/wysihtml5-0.3.0.js',
        '/js/bootstrap-wysihtml5-0.0.2.js',
        '/js/jquery.ba-bbq.min.js',
        '/js/jquery.fitvids.js',
        '/js/jquery.popupWindow.js'
        ]
      prebuild true
    } 
  
    before do
      redirect "http://#{ENV['DOMAIN']}" if ENV['DOMAIN'] and request.env['HTTP_HOST'] != ENV['DOMAIN']
      fix_params!
      Time.zone = current_account.time_zone if current_account and current_account.time_zone    
    end     
  
    use OmniAuth::Builder do
      provider :account
      provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
      provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
      provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET']
      provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET']
    end  
    OmniAuth.config.on_failure = Proc.new { |env|
      OmniAuth::FailureEndpoint.new(env).redirect_to_failure
    }
  
    #  use Rack::Cache,
    #    :metastore    => Dalli::Client.new,
    #    :entitystore  => 'file:tmp/cache/rack/body',
    #    :allow_reload => false
      
    #  register Padrino::Mailer
    #  set :delivery_method, :smtp => { 
    #    :address              => "smtp.gmail.com",
    #    :port                 => 587,
    #    :user_name            => ENV['GMAIL_USERNAME'],
    #    :password             => ENV['GMAIL_PASSWORD'],
    #    :authentication       => :plain,
    #    :enable_starttls_auto => true  
    #  }  
    
    not_found do
      erb :not_found, :layout => :application
    end
  
    #  use Airbrake::Rack  
    #  Airbrake.configure do |config| config.api_key = ENV['AIRBRAKE_API_KEY'] end
    error do
      #    Airbrake.notify(env['sinatra.error'])
      erb :error, :layout => :application
    end      
    #  get '/airbrake' do
    #    raise StandardError
    #  end
  
    get :home, :map => '/' do
      erb :home
    end
     
  end         
end
