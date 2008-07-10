require File.dirname(__FILE__) + '/../bloget_test_helper'

class CommentsControllerTest < ActionController::TestCase
  tests CommentsController
    
  def test_should_be_able_to_get_individual_comment
    comment = create_comment
    get :show, :id => comment, :post_id => comment.post.permalink
    assert_response :success
  end

  def test_must_be_logged_in_to_get_new_comment_form
    a_post = create_post
    get :new, :post_id => a_post.permalink
    assert_response :redirect
  end
    
  def test_should_be_able_to_get_new_post_form
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(create_poster)
    a_post = create_post

    get :new, :post_id => a_post.permalink
    assert_response :success
  end

  def test_must_be_logged_in_to_create_new_comment
    a_post = create_post

    post :create, :post_id => a_post.permalink, :comment => { :content => 'My comment' }
    assert_response :redirect
  end
  
  def test_should_be_able_to_create_new_comment
    @controller.stubs(:logged_in?).returns(true)
    @controller.stubs(:current_user).returns(create_poster)    
    a_post = create_post
    
    post :create, :post_id => a_post.permalink, :comment => { :content => 'My comment' }
    assert_redirected_to :controller => 'posts', :action => 'show'
    assert_match "success", flash[:notice]
  end

end
