xml.atom :entry do
  xml.atom :id, id
  xml.atom :updated, rfc3339(entry.created_at)
  xml.atom :link, :href => link
  xml.atom :title, entry.respond_to?(:title) ? entry.title : truncate(entry.content, 20)
  
  xml.atom :author do
    xml.atom :name, entry.poster.name if entry.poster.respond_to?(:name)
    xml.atom :email, entry.poster.email if entry.poster.respond_to?(:email)
  end
  
  xml.atom :content, {:type => 'html'}, entry.content
end