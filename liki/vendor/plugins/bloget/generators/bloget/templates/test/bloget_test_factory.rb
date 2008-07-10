module Bloget
  module TestFactory
    
    @@permalink_count = 0
    
    def get_permalink
      @@permalink_count += 1
      "permalink_#{@@permalink_count}"
    end
       
    def create_post(attributes = {})
      default_attributes = {
        :title => "My Day at the Beach",
        :permalink => get_permalink,
        :content => "Whatta day!",
        :poster => create_poster
      }
  
      Post.create! default_attributes.merge(attributes)
    end
    
    def create_comment(attributes = {})
      default_attributes = {
        :post => create_post,
        :poster => create_poster,
        :content => "Whatta comment!"
      }
  
      Comment.create! default_attributes.merge(attributes)
    end
    
    def create_blogger(attributes = {})
      default_attributes = {
        :poster => create_poster
      }
      
      Blogger.create! default_attributes.merge(attributes)
    end
    
    def create_poster(attributes = {})
      default_attributes = {
        :login => 'test',
        :email => 'test@example.com',
        :password => 'test',
        :password_confirmation => 'test',
        :terms => '1'
      }
      
      attributes = default_attributes.merge(attributes)

      user = User.find_by_login(attributes[:login])
      
      if user.nil?
        user = User.create! attributes
      end
      
      user
    end
        
  end
end
