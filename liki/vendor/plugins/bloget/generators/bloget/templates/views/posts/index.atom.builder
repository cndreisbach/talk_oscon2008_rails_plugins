xml.atom :feed, 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
  xml.atom :id, posts_url
  xml.atom :title, @blog.name
  xml.atom :updated, rfc3339(@posts.first ? @posts.first.updated_at : Time.now)
  xml.atom :link, :href => formatted_posts_url('atom'), :rel => 'self'

  @posts.each do |post|
    xml.<< render(:partial => 'entry', :object => post, :locals => {
      :id => post_url(post),
      :link => post_url(post)
    })    
  end
end