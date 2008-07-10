module Bloget
  module Models
    module Comment
      
      def self.included(base)
        base.class_eval do
          belongs_to :post
          belongs_to :poster, :polymorphic => true

          validates_presence_of :post_id
          validates_presence_of :poster_id
          validates_presence_of :poster_type
        end        
      end
      
    end
  end
end