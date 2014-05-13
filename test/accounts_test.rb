require File.expand_path(File.dirname(__FILE__) + '/test_config.rb')

class TestAccounts < ActiveSupport::TestCase
  include Capybara::DSL
    
  setup do
    Account.destroy_all    
  end
  
  test 'signing up' do
    @account = build(:account)
    visit '/accounts/sign_up'
    click_link 'Sign up with an email address' if !Account.providers.empty?
    fill_in 'Name', :with => @account.name
    fill_in 'Email', :with => @account.email
    select @account.time_zone, :from => 'Time zone'
    fill_in 'Password', :with => @account.password
    fill_in 'Password again', :with => @account.password_confirmation
    click_button 'Create account'
    assert page.has_content? 'Your account was created successfully'
  end    
    
  test 'signing in' do
    @account = create(:account)
    visit '/accounts/sign_in'
    fill_in 'Email', :with => @account.email
    fill_in 'Password', :with => @account.password
    click_button 'Sign in'
    assert page.has_content? 'Signed in'
  end   
  
end