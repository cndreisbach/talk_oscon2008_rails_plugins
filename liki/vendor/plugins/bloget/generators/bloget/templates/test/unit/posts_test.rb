require File.dirname(__FILE__) + '/../bloget_test_helper'

class PostTest < ActiveSupport::TestCase

  def test_should_exist_and_work
    p = Post.new(:poster_id => 1, 
                 :poster_type => 'User', 
                 :title => 'My first post',
                 :permalink => get_permalink)

    assert p.valid?
  end
  
  def test_should_require_a_poster
    p = Post.new(:title => 'My first post',
                 :permalink => get_permalink)

    assert !p.valid?
    assert_not_nil p.errors[:poster_id]
    assert_not_nil p.errors[:poster_type]
  end
  
  def test_should_require_a_title
    p = Post.new(:poster_id => 1, 
                 :poster_type => 'User',
                 :permalink => get_permalink)

    assert !p.valid?
    assert_not_nil p.errors[:title]
  end
  
  def test_should_require_a_permalink
    p = Post.new(:poster_id => 1,
                 :poster_type => 'User',
                 :title => 'Title')

    assert !p.valid?
    assert_not_nil p.errors[:permalink]
  end
  
  def test_should_not_have_identical_permalinks
    p1 = create_post
    p2 = create_post
    p2.permalink = p1.permalink

    assert !p2.valid?
    assert_not_nil p2.errors[:permalink]
  end
  
  def test_can_have_a_state
    p = create_post

    assert p.respond_to?(:state)
  end
  
  def test_should_have_default_state_of_draft 
    p = Post.new(:poster_id => 1,
                 :poster_type => 'User',
                 :title => "A post",
                 :permalink => 'a-post')

    assert p.draft?
  end

  def test_should_be_able_to_be_published
    p = Post.new(:poster_id => 1,
                 :poster_type => 'User',
                 :title => "A post",
                 :permalink => 'a-post',
                 :content => "some content")

    p.publish!
    assert p.published?
  end
  
  def test_should_not_have_other_states
    p = create_post
    p.state = 'ready'

    assert !p.valid?
  end
  
end
