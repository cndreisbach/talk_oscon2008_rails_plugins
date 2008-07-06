require 'test_helper'

class MultipleColumnTest < Test::Unit::TestCase
  
  def setup
    @adapter = ActiveRecord::ConnectionAdapters::AbstractAdapter.new(nil)
    @adapter.stubs(:supports_foreign_keys?).returns(true)
  end

  def test_constraint_syntax_with_multiple_columns_should_work

    @adapter.expects(:execute).with(
      'CREATE TABLE users (' + 
      'id primary_key, ' +
      'department_id integer NOT NULL, ' +
      'location_id integer NOT NULL, ' +
      'CONSTRAINT fk_users_department_id_location_id_departments_id_location_id ' + 
      'FOREIGN KEY (department_id, location_id) ' +
      'REFERENCES departments(id, location_id)) '
    )

    @adapter.create_table :users do |t|
      t.column :department_id, :integer, :null => false
      t.column :location_id, :integer, :null => false
      t.foreign_key :on => [:department_id, :location_id], 
        :references => {:table => :departments, :column => [:id, :location_id]}
    end

  end
  
  def test_alter_table_syntax_with_multiple_columns_should_work
    @adapter.expects(:execute).once.with(
      'ALTER TABLE users ADD CONSTRAINT ' +
      'fk_users_department_id_location_id_departments_id_location_id ' +
      'FOREIGN KEY (department_id, location_id) ' +
      'REFERENCES departments(id, location_id)').returns(true)
    
    assert(@adapter.add_foreign_key(
      :on => {:table => :users, :column => [:department_id, :location_id]}, 
      :references => {:table => :departments, :column => [:id, :location_id]}))
  end
  
end