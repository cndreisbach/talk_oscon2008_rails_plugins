require File.dirname(__FILE__) + '/../bloget_test_helper'

class CommentTest < ActiveSupport::TestCase
    
  def test_should_exist_and_work
    c = Comment.new(
      :post_id => 1,
      :poster_id => 1, 
      :poster_type => 'User') 

    assert c.valid?
  end
  
  def test_should_require_a_post
    c = Comment.new(
      :poster_id => 1, 
      :poster_type => 'User')

    assert !c.valid?
    assert_not_nil c.errors[:post_id]
  end
  
  def test_may_belong_to_a_post
    c = Comment.new(
      :poster_id => 1, 
      :poster_type => 'User')
            
    c.post = create_post(:poster_id => c.poster_id, :poster_type => c.poster_type)

    assert c.valid?
  end
  
  def test_should_require_a_poster
    c = Comment.new(
      :post_id => 1)

    assert !c.valid?
    assert_not_nil c.errors[:poster_id]
    assert_not_nil c.errors[:poster_type]
  end
      
end
