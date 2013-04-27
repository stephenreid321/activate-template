ActivateApp::App.helpers do
  
  def current_account
    @current_account ||= Account.find(session[:account_id]) if session[:account_id]
  end
  
  def protected!
    redirect '/sign_in' unless current_account
  end
  
end