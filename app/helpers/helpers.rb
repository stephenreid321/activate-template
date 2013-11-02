ActivateApp::App.helpers do
  
  def current_account
    @current_account ||= Account.find(session[:account_id]) if session[:account_id]
  end
  
  def protected!
    if !current_account
      flash[:notice] = 'You must sign in to access that page'
      session[:return_to] = request.url
      redirect url(:accounts, :sign_in)
    end
  end
  
end