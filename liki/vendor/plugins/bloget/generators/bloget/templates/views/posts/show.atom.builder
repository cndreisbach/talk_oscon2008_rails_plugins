xml.atom :feed, 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
  xml.atom :id, post_url
  xml.atom :title, @post.title
  xml.atom :updated, rfc3339(@post.comments.count > 0 ? @post.comments.first.created_at : @post.created_at)
  xml.atom :link, :href => formatted_post_url(:format => 'atom'), :rel => 'self'

  xml.<< render(:partial => 'entry', :object => @post, :locals => {
    :id => post_url,
    :link => post_url
  })

  @post.comments.each do |comment|
    xml.<< render(:partial => 'entry', :object => comment, :locals => {
      :id => comment_url(:post_id => @post, :id => comment),
      :link => post_url(:id => @post, :anchor => "comment_#{comment.id}" )
    })
  end
end