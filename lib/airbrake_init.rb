if ENV['AIRBRAKE_HOST']
  Airbrake.configure do |config|
    config.project_id = (ENV['AIRBRAKE_PROJECT_ID'] or ENV['AIRBRAKE_API_KEY'])
    config.project_key = (ENV['AIRBRAKE_PROJECT_KEY'] or ENV['AIRBRAKE_API_KEY'])
    config.host = ENV['AIRBRAKE_HOST']
  end
end