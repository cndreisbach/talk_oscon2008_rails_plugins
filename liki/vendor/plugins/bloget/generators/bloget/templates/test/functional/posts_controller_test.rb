require File.dirname(__FILE__) + '/../bloget_test_helper'

class PostsControllerTest < ActionController::TestCase
  tests PostsController

  def test_should_show_index_of_posts
    get :index
    assert_response :success
  end

  def test_should_be_able_to_get_index_posts_as_Atom_feed
    get :index, :format => 'atom'
    assert_response :success
  end
  
  def test_should_show_individual_post
    post = create_post
    post.publish!
    get :show, :id => post.permalink
    assert_response :success
  end

  def test_should_show_individual_post_as_Atom_feed
    post = create_post
    post.publish!    
    get :show, :id => post.permalink, :format => 'atom'
    assert_response :success
  end
  
  def test_must_be_logged_in_to_get_new_post_form
    get :new
    assert_response :redirect
  end
  
  def test_must_be_a_blogger_to_get_new_post_form
    not_a_blogger = create_poster(:login => 'not_a_blogger', :email => 'not_a_blogger')
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(not_a_blogger)
    
    get :new
    assert_response 401
  end
  
  def test_should_be_able_to_get_new_post_form
    blogger = create_blogger
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(blogger.poster)

    get :new
    assert_response :success
  end

  def test_must_be_a_blogger_to_create_new_post
    not_a_blogger = create_poster(:login => 'not_a_blogger', :email => 'not_a_blogger')
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(not_a_blogger)
    
    post :create, :post => {
      :poster_id => 1,
      :poster_type => 'User',
      :title => 'A new post'
    }
    assert_response 401
  end

  def test_should_be_able_to_create_new_post
    blogger = create_blogger
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(blogger.poster)
    
    post :create, :post => {
      :poster_id => 1,
      :poster_type => 'User',
      :title => 'A new post',
      :permalink => get_permalink,
      :content => 'Some content'
    }
    assert_redirected_to :action => 'show'
    assert_match "success", flash[:notice]
  end

  def test_post_should_be_published_when_published_passed_in_params
    blogger = create_blogger
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(blogger.poster)

    p = create_post
    Post.stubs(:new).returns(p)
    p.stubs(:save).returns(true)
    p.expects(:publish!)
    
    post :create, :post => {
      :state => 'published'
    }   
  end
  
  def test_must_be_logged_in_to_get_edit_form
    a_post = create_post
    
    get :edit, :id => a_post.permalink
    assert_response :redirect
  end
  
  def test_must_be_post_poster_to_get_edit_form
    a_post = create_post
    
    some_guy = create_poster(:login => 'some_guy', :email => 'some_guy')
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(some_guy)
    
    get :edit, :id => a_post.permalink
    assert_response 401
  end
  
  def test_should_be_able_to_get_edit_form
    a_post = create_post
    
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(a_post.poster)
    
    get :edit, :id => a_post.permalink
    assert_response :success
  end
  
  def test_must_be_post_poster_to_edit_post
    a_post = create_post
    
    some_guy = create_poster(:login => 'some_guy', :email => 'some_guy')
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(some_guy)
    
    put :update, :id => a_post.permalink, :post => {
      :title => "Updated!"
    }
    assert_response 401
  end
  
  def test_should_be_able_to_edit_post
    a_post = create_post
    
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(a_post.poster)
    
    put :update, :id => a_post.permalink, :post => {
      :title => "Updated!"
    }
    assert_redirected_to :action => :show, :id => a_post
  end
  
  def test_must_be_post_poster_to_delete_post
    a_post = create_post
    
    some_guy = create_poster(:login => 'some_guy', :email => 'some_guy')
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(some_guy)
    
    delete :destroy, :id => a_post.permalink
    assert_response 401
  end
  
  def test_should_be_able_to_delete_post
    a_post = create_post
    
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(a_post.poster)
    
    delete :destroy, :id => a_post.permalink
    assert_redirected_to :action => :index
  end
  
  def test_should_not_show_draft_posts_in_index
    post = create_post(:state => 'draft', :title => String.random)
    get :index

    assert_select "h2 a", :text => post.display_title, :count => 0
  end

  def test_should_show_draft_posts_in_index_if_you_are_a_blogger
    blogger = create_blogger
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(blogger.poster)

    post = create_post(:state => 'draft', :title => String.random)
    get :index

    assert_select "h2 a", post.display_title
    assert_select "div[class~='post'][class~='draft']"
  end
  
  def test_should_not_show_individual_post_in_draft_state
    post = create_post(:state => 'draft')
    get :show, :id => post.permalink
    assert_response 401
  end
  
  def test_should_show_individual_post_in_draft_state_to_blogger
    blogger = create_blogger
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(blogger.poster)

    post = create_post(:state => 'draft')
    get :show, :id => post.permalink
    assert_response :success
  end
  
end
