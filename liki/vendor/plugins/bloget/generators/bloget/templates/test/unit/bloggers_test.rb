require File.dirname(__FILE__) + '/../bloget_test_helper'

class BloggerTest < ActiveSupport::TestCase

  def test_should_exist_and_work
    blogger = Blogger.new(:poster_id => 1, :poster_type => 'User')

    assert blogger.valid?
  end
  
  def test_should_not_work_without_a_poster
    blogger = Blogger.new
    
    assert !blogger.valid?
    assert_not_nil blogger.errors[:poster_id]
    assert_not_nil blogger.errors[:poster_type]    
  end

  def test_may_be_associated_with_a_valid_poster
    blogger = Blogger.new
    blogger.poster = create_poster
    
    assert blogger.valid?
  end
    
end
