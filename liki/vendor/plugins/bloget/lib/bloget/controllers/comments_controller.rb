module Bloget
  module Controllers
    module CommentsController
      
      def self.included(base)
        base.class_eval do
          
          around_filter :load_post
          
          before_filter :login_required, :only => [ :new, :create, :edit, :update ]
          before_filter :authenticate_for_comment, :only => [:edit, :update]

          layout 'bloget'
          
        end
      end
  
      def index
        respond_to do |format|
          format.html { redirect_to post_url(params[:post_id]) }
          format.atom { redirect_to formatted_post_url(params[:post_id], 'atom') }
        end
      end
  
      def show
        @comment = Comment.find(params[:id], :conditions => {:post_id => @post.id})
      end
  
      def create
        @comment = Comment.new(params[:comment])
        @comment.post = @post
        @comment.poster = current_user
    
        if @comment.save
          flash[:notice] = "Your comment was successfully saved."      
          redirect_to post_url(:id => @comment.post, :anchor => 'comment_' + @comment.id.to_s)
        else
          render :action => "new"
        end
      end
  
      def new
        @comment = Comment.new(:post_id => @post.id)
        @comment.poster = current_user
      end
    
      def edit
        @comment = Comment.find(params[:id], :conditions => {:post_id => @post.id})
      end
  
      def update
        @comment = Comment.find(params[:id], :conditions => {:post_id => @post.id})
      
        if @comment.update_attributes(params[:comment])
          redirect_to post_url(:id => @comment.post, :anchor => 'comment_' + @comment.id.to_s)
        else
          render :action => :edit
        end
      end
    
      protected
    
      def authenticate_for_comment
        @comment = Comment.find(params[:id])
        if (@comment.poster != current_user)
          render :nothing => true, :status => 401
        end
      end 
      
      def load_post
        begin
          @post ||= Post.find_by_permalink(params[:post_id])
          raise ActiveRecord::RecordNotFound if @post.nil?
          yield
        rescue ActiveRecord::RecordNotFound
          render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
        end
      end     
    end
  end
end
