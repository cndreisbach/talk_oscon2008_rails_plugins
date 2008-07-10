module PostsHelper
  def rfc3339(time) 
    time.strftime('%Y-%m-%dT%H:%M:%SZ') 
  end
end
