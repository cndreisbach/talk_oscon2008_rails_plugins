require File.dirname(__FILE__) + '/test_helper'

MYSQL_HOST = ENV['MYSQL_HOST'] || 'localhost'
MYSQL_USER = ENV['MYSQL_USER'] || 'root'
MYSQL_PASS = ENV['MYSQL_PASS'] || ''
MYSQL_DB = ENV['MYSQL_DB'] || 'test'

ActiveRecord::Base.establish_connection(:adapter => 'mysql',
                                        :host => MYSQL_HOST,
                                        :username => MYSQL_USER,
                                        :password => MYSQL_PASS,
                                        :database => MYSQL_DB
                                        )

class MysqlAdapterTest < Test::Unit::TestCase

  def setup
    TestDB.up
  end
  
  def teardown
    TestDB.down
  end

  def test_should_add_a_foreign_key
    db = ActiveRecord::Base.connection
    db.add_foreign_key(:on => {:table => :widgets, :column => :factory_id}, 
                       :references => {:table => :factories, :column => :id})
    
    key = db.send(:select, 
                  "SELECT * FROM information_schema.key_column_usage " +
                  "WHERE constraint_schema = 'test' AND " +
                  "constraint_name = 'fk_widgets_factory_id_factories_id'")[0]

    assert_equal key['TABLE_NAME'], 'widgets'
    assert_equal key['COLUMN_NAME'], 'factory_id'
    assert_equal key['REFERENCED_TABLE_NAME'], 'factories'
    assert_equal key['REFERENCED_COLUMN_NAME'], 'id'
  end
end
