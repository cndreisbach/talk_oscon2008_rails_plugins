class Blog
  
  include Singleton
  attr_reader :name
  
  def initialize
    @name = "Bloget" # choose the name of your blog here
  end
  
end