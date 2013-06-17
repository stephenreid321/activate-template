ActivateApp::App.controllers :blog do
  
  get :index do
    @blog_posts = BlogPost.order_by(:created_at.desc)
    @title = 'Blog'
    erb :'blog/index'
  end
  
  get :post, :map => '/blog/:slug' do 
    @blog_post = BlogPost.find_by(slug: params[:slug])
    @title = @blog_post.title
    erb :'blog/post'
  end  
  
end
