ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resource  :session
  
  map.with_options :controller => 'posts', :conditions => {:method => :get} do |bloget|
    bloget.blog_url '/blog', :action => 'index'
    bloget.formatted_blog_url '/blog.:format', :action => 'index'
  end
  
  map.resources(:posts)
  map.resources(:comments, :path_prefix => '/posts/:post_id')

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
