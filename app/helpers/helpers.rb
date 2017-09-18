ActivateApp::App.helpers do
  
  def mass_assigning(params, model)
    intersection = model.protected_attributes & params.keys
    if !intersection.empty?
      raise "attributes #{intersection} are protected"
    end
    params
  end  
  
  def current_account
    @current_account ||= Account.find(session[:account_id]) if session[:account_id]
  end
   
  def sign_in_required!
    unless current_account
      flash[:notice] = 'You must sign in to access that page'
      session[:return_to] = request.url
      request.xhr? ? halt(403) : redirect('/sign_in')
    end
  end  
  
  
  def f(slug)
    (if fragment = Fragment.find_by(slug: slug) and fragment.body
      "\"#{fragment.body.to_s.gsub('"','\"')}\""
    end).to_s
  end  
  
  def timeago(x)
    %Q{<abbr class="timeago" title="#{x.iso8601}">#{x}</abbr>}
  end  
  
  def random(relation, n)
    count = relation.count
    (0..count-1).sort_by{rand}.slice(0, n).collect! do |i| relation.skip(i).first end
  end  
  
end