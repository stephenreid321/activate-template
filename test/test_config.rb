RACK_ENV = 'test' unless defined?(RACK_ENV)
require File.expand_path('../../config/boot', __FILE__)

require 'capybara'
require 'capybara/poltergeist'
require 'factory_girl'
require 'minitest/autorun'

Capybara.app = Padrino.application
Capybara.server_port = ENV['PORT']
Capybara.default_driver = :poltergeist

class MiniTest::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end

FactoryGirl.define do
  
  factory :account do
    sequence(:name) { |n| "Account #{n}" }
    sequence(:email) { |n| "account#{n}@example.com" }
    time_zone 'London'
    sequence(:password) { |n| "password#{n}" } 
    password_confirmation { password }
  end
   
end