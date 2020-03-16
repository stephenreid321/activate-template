ActivateApp::App.controller do
  
  get '/sign_up' do
    redirect '/accounts/new' if Provider.registered.empty?
    erb :'accounts/sign_up'
  end    
  
  get '/sign_in' do
    erb :'accounts/sign_in'
  end    
    
  get '/accounts/sign_out' do
    session.clear
    redirect '/'
  end
  
  post '/accounts/forgot_password' do
    if params[:email] and @account = Account.find_by(email: /^#{::Regexp.escape(params[:email])}$/i)
      if @account.reset_password!        
        flash[:notice] = "A new password was sent to #{@account.email}"
      else
        flash[:error] = "There was a problem resetting your password."
      end
    else
      flash[:error] = "There's no account registered under that email address."
    end
    redirect '/'
  end  
        
  get '/accounts/new' do
    @account = Account.new    
    erb :'accounts/build'
  end 
  
  post '/accounts/new' do   
    @account = Account.new(mass_assigning(params[:account], Account))
    if session['omniauth.auth']
      @provider = Provider.object(session['omniauth.auth']['provider'])
      @account.provider_links.build(provider: @provider.display_name, provider_uid: session['omniauth.auth']['uid'], omniauth_hash: session['omniauth.auth'])
      @account.picture_url = @provider.image.call(session['omniauth.auth']) unless @account.picture
    end        
    if @account.save
      flash[:notice] = "<strong>Awesome!</strong> Your account was created successfully."
      session['account_id'] = @account.id.to_s
      redirect '/'
    else
      flash.now[:error] = "<strong>Oops.</strong> Some errors prevented the account from being saved."
      erb :'accounts/build'
    end
  end
      
  get '/accounts/edit' do
    sign_in_required!
    @account = current_account
    erb :'accounts/build'
  end
  
  post '/accounts/edit' do
    sign_in_required!
    @account = current_account
    if @account.update_attributes(mass_assigning(params[:account], Account))
      flash[:notice] = "<strong>Awesome!</strong> Your account was updated successfully."
      redirect '/accounts/edit'
    else
      flash.now[:error] = "<strong>Oops.</strong> Some errors prevented the account from being saved."
      erb :'accounts/build'
    end
  end
  
  get '/accounts/use_picture/:provider' do
    sign_in_required!
    @provider = Provider.object(params[:provider])
    @account = current_account
    @account.picture_url = @provider.image.call(@account.provider_links.find_by(provider: @provider.display_name).omniauth_hash)
    if @account.save
      flash[:notice] = "<i class=\"fa fa-#{@provider.icon}\"></i> Grabbed your picture!"
      redirect '/accounts/edit'
    else
      flash.now[:error] = "<strong>Hmm.</strong> There was a problem grabbing your picture."
      erb :'accounts/build'
    end
  end   
  
  get '/accounts/disconnect/:provider' do
    sign_in_required!
    @provider = Provider.object(params[:provider])    
    @account = current_account
    if @account.provider_links.find_by(provider: @provider.display_name).destroy
      flash[:notice] = "<i class=\"fa fa-#{@provider.icon}\"></i> Disconnected!"
      redirect '/accounts/edit'
    else
      flash.now[:error] = "<strong>Oops.</strong> The disconnect wasn't successful."
      erb :'accounts/build'
    end
  end   
   
end