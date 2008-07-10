module Bloget
  module Models
    module Post
      
      def self.included(base)
        base.class_eval do
          
          has_many :comments, :order => 'created_at ASC'
          belongs_to :poster, :polymorphic => true

          validates_presence_of :poster_id
          validates_presence_of :poster_type
          validates_presence_of :title
          validates_presence_of :permalink
          validates_uniqueness_of :permalink
          validates_format_of :permalink, :with => /^[\w\-]+$/,
            :message => 'must only be made up of numbers, letters, and dashes'          

          acts_as_state_machine :initial => :draft

          state :draft
          state :published, :enter => lambda { |o| o.save if o.new_record? }

          validates_inclusion_of :state, :in => states.map { |s| s.to_s }

          event :publish do
            transitions :from => :draft, :to => :published, :guard => lambda { 
              |o| o.valid?
            }
          end

          event :unpublish do
            transitions :from => :published, :to => :draft
          end

        end        
      end
      
      def to_param
        permalink
      end
      
      def display_title
        title = read_attribute(:title)
        title += " [DRAFT]" if !title.empty? and state == 'draft'
        title
      end
            
    end
  end
end
