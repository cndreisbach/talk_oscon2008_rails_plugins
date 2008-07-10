module Bloget
  module Models
    module Blogger
      
      def self.included(base)
        base.class_eval do
          belongs_to :poster, :polymorphic => true

          validates_presence_of :poster_id, :poster_type
          
          extend Bloget::Models::Blogger::ClassMethods
        end        
      end
      
      module ClassMethods
      
        def valid_blogger?(poster)
          !self.find_by_poster(poster).nil?
        end
      
        def find_by_poster(poster)
          self.find_by_poster_id_and_poster_type(poster.id, poster.class.to_s)
        end

      end
    end
  end
end
