ActivateApp::App.controller do
  
  get '/sign_up' do
    erb :'accounts/sign_up'
  end    
      
  get '/account/new' do
    @account = Account.new    
    erb :'accounts/build'
  end 
  
  post '/account/new' do
    @account = Account.new(params[:account])
    if session['omniauth.auth']
      @provider = Account.provider_object(session['omniauth.auth']['provider'])
      @account.connections.build(provider: @provider.display_name, provider_uid: session['omniauth.auth']['uid'], omniauth_hash: session['omniauth.auth'])
      @account.picture_url = @provider.image.call(session['omniauth.auth']) unless @account.picture
    end        
    if @account.save
      flash[:notice] = "<strong>Awesome!</strong> Your account was created successfully."
      session['account_id'] = @account.id
      redirect '/'
    else
      flash.now[:error] = "<strong>Oops.</strong> Some errors prevented the account from being saved."
      erb :'accounts/build'
    end
  end
  
  get '/sign_in' do
    erb :'accounts/sign_in'
  end  
  
  get '/auth/failure' do
    flash.now[:error] = "<strong>Hmm.</strong> There was a problem signing you in."
    erb :'accounts/sign_in'
  end
  
  %w(get post).each do |method|
    send(method, "/auth/:provider/callback") do      
      account = if env['omniauth.auth']['provider'] == 'account'
        Account.find(env['omniauth.auth']['uid'])
      else
        env['omniauth.auth'].delete('extra')
        @provider = Account.provider_object(env['omniauth.auth']['provider'])
        Connection.find_by(provider: @provider.display_name, provider_uid: env['omniauth.auth']['uid']).try(:account)
      end
      if current_account # already signed in; attempt to connect            
        if account # someone's already connected
          flash[:error] = "Someone's already connected to that account!"
        else # connect; Account never reaches here
          flash[:notice] = "<i class=\"icon-#{@provider.icon}\"></i> Connected!"
          current_account.connections.build(provider: @provider.display_name, provider_uid: env['omniauth.auth']['uid'], omniauth_hash: env['omniauth.auth'])
          current_account.picture_url = @provider.image.call(env['omniauth.auth']) unless current_account.picture
          current_account.save
        end
        redirect '/account/edit'
      else # not signed in
        if account # sign in
          session['account_id'] = account.id
          flash[:notice] = "Signed in!"
          redirect '/'
        elsif session[:code] # sign up; Account never reaches here          
          flash.now[:notice] = "<i class=\"icon-#{@provider.icon}\"></i> We need a few more details to finish creating your account&hellip;"
          session['omniauth.auth'] = env['omniauth.auth']
          @account = Account.new
          @account.name = env['omniauth.auth']['info']['name']
          @account.email = env['omniauth.auth']['info']['email']  
          @account.picture_url = @provider.image.call(env['omniauth.auth'])
          @account.connections.build(provider: @provider.display_name, provider_uid: env['omniauth.auth']['uid'], omniauth_hash: env['omniauth.auth'])
          erb :'accounts/build'
        else
          redirect '/auth/failure'
        end
      end
    end
  end
  
  get '/account/:provider/use_picture' do
    protected!
    @provider = Account.provider_object(params[:provider])
    @account = current_account
    @account.picture_url = @provider.image.call(@account.connections.find_by(provider: @provider.display_name).omniauth_hash)
    if @account.save
      flash[:notice] = "<i class=\"icon-#{@provider.icon}\"></i> Grabbed your picture!"
      redirect '/account/edit'
    else
      flash.now[:error] = "<strong>Hmm.</strong> There was a problem grabbing your picture."
      erb :'accounts/build'
    end
  end   
  
  get '/account/:provider/disconnect' do
    protected!
    @provider = Account.provider_object(params[:provider])    
    @account = current_account
    if @account.connections.find_by(provider: @provider.display_name).destroy
      flash[:notice] = "<i class=\"icon-#{@provider.icon}\"></i> Disconnected!"
      redirect '/account/edit'
    else
      flash.now[:error] = "<strong>Oops.</strong> The disconnect wasn't successful."
      erb :'accounts/build'
    end
  end      
  
  get '/account/edit' do
    protected!
    @account = current_account
    erb :'accounts/build'
  end
  
  post'/account/edit' do
    protected!
    @account = current_account
    if @account.update_attributes(params[:account])      
      flash[:notice] = "<strong>Awesome!</strong> Your account was updated successfully."
      redirect '/account/edit'
    else
      flash.now[:error] = "<strong>Oops.</strong> Some errors prevented the account from being saved."
      erb :'accounts/build'
    end
  end
  
  get '/sign_out' do
    session.clear
    redirect '/'
  end
  
end