RACK_ENV = 'test' unless defined?(RACK_ENV)
require File.expand_path('../../config/boot', __FILE__)

require 'minitest/autorun'

Capybara.app = Padrino.application

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