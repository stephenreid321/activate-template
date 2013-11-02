module ActivateApp
  class App < Padrino::Application
    register Padrino::Rendering
    register Padrino::Helpers
    register WillPaginate::Sinatra
    helpers Activate::DatetimeHelpers
    helpers Activate::ParamHelpers
    helpers Activate::NavigationHelpers
    use Dragonfly::Middleware, :dragonfly
    
    set :sessions, :expire_after => 1.year
    # set :show_exceptions, true
    set :public_folder,  Padrino.root('app', 'assets')
      
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
      #    Airbrake.notify(env['sinatra.error']) if Padrino.env == :production
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
