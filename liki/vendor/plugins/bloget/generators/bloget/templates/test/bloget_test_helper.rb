require 'test_helper'
require 'rubygems'
require 'mocha'
require File.dirname(__FILE__) + '/bloget_test_factory'
include Bloget::TestFactory

# Re-raise controller errors
class ApplicationController < ActionController::Base
  def rescue_action(e)
    raise e
  end
end

def String.random(size=16)
  (1..size).collect { (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }.join
end
