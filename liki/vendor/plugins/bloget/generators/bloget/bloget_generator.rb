class BlogetGenerator < Rails::Generator::Base

  def manifest
    template_dir = File.join(File.dirname(__FILE__), 'templates')
    
    record do |m|      
      m.class_collisions "Blog", "Blogger", "Post", "Comment"
      m.class_collisions "PostsController", "CommentsController"

      Dir.chdir(template_dir) do
        
        # handle models, controllers, helpers, and views
        %w(models controllers helpers views).each do |area|
          m.directory(File.join('app', area))
          Dir.glob(File.join(area, '**', '*')).each do |file|
            m.directory(File.join('app', file)) if File.directory?(file)
            m.file(file, File.join('app', file)) if File.file?(file)
          end
        end
                
        # handle tests
        m.directory('test')
        Dir.glob(File.join('test', '**', '*')).each do |file|
          m.directory(file) if File.directory?(file)
          m.file(file, file) if File.file?(file)
        end
      end
            
      m.file('bloget.css', 'public/stylesheets/bloget.css')

      # Handle migrations
      Dir.glob(File.join(template_dir, 'migrate', '*')).each do |file|
        m.migration_template(
          File.join('migrate', File.basename(file)),
          'db/migrate',
          :migration_file_name => File.basename(file, '.rb')
        )
      end
      
      m.readme '../../../README'
              
    end
  end
    
end
