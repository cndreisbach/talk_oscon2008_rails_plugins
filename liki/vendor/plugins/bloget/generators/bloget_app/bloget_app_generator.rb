class BlogetAppGenerator < Rails::Generator::Base

  def manifest
    template_dir = File.join(File.dirname(__FILE__), 'templates')
    
    record do |m|      
      Dir.chdir(template_dir) do
        m.file('routes.rb', 'config/routes.rb')
        m.file('user.rb', 'app/models/user.rb')
        m.file('application.rb', 'app/controllers/application.rb')
      end
    end
  end
    
end
