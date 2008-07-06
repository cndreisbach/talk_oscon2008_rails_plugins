require 'test_helper'

class CreateTableTest < Test::Unit::TestCase
  
  def setup
    @adapter = ActiveRecord::ConnectionAdapters::AbstractAdapter.new(nil)
    @adapter.stubs(:supports_foreign_keys?).returns(true)
  end
  
  def test_create_table_should_allow_simple_foreign_key_definitions
    @adapter.expects(:execute).with(
      'CREATE TABLE users (' + 
      'id primary_key, ' + 
      'department_id integer NOT NULL, ' +
      'CONSTRAINT fk_users_department_id_departments_id ' + 
      'FOREIGN KEY (department_id) REFERENCES departments(id)) '
    ).returns(true)
    
    @adapter.create_table :users do |t|
      t.column :department_id, :integer, :null => false, :references => :departments
    end
  end

  def test_create_table_should_allow_action_options
    @adapter.expects(:execute).with(
      'CREATE TABLE users (' + 
      'id primary_key, ' + 
      'department_id integer NOT NULL, ' +
      'CONSTRAINT fk_users_department_id_departments_id ' + 
      'FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE) '
    ).returns(true)
    
    @adapter.create_table :users do |t|
      t.column :department_id, :integer, :null => false, :references => :departments, :delete => :cascade
    end
  end
  
  def test_create_table_should_allow_multiple_action_options
    @adapter.expects(:execute).with(
      'CREATE TABLE users (' + 
      'id primary_key, ' + 
      'department_id integer NOT NULL, ' +
      'CONSTRAINT fk_users_department_id_departments_id ' + 
      'FOREIGN KEY (department_id) REFERENCES departments(id) ON UPDATE RESTRICT ON DELETE CASCADE) '
    ).returns(true)
    
    @adapter.create_table :users do |t|
      t.column :department_id, :integer, :null => false, :references => :departments, :delete => :cascade, :update => :restrict
    end
  end

  def test_create_table_should_allow_complex_foreign_key_definitions
    @adapter.expects(:execute).with(
      'CREATE TABLE users (' + 
      'id primary_key, ' + 
      'department_id integer NOT NULL, ' + 
      'CONSTRAINT fk_users_department_id_department_dept_id ' + 
      'FOREIGN KEY (department_id) REFERENCES department(dept_id)) '
    ).returns(true)
    
    @adapter.create_table :users do |t|
      t.column :department_id, :integer, :null => false, :references => {:table => :department, :column => :dept_id}
    end
  end
  
  def test_create_table_with_constraint_syntax_and_bad_variables_should_error
    assert_raise ArgumentError do
      @adapter.create_table :users do |t|
        t.foreign_key
      end
    end
  end
    
  def test_create_table_should_allow_constraint_syntax
    @adapter.expects(:execute).with(
      'CREATE TABLE users (' + 
      'id primary_key, ' +
      'department_id integer NOT NULL, ' +
      'CONSTRAINT fk_users_department_id_departments_id ' + 
      'FOREIGN KEY (department_id) REFERENCES departments(id)) '
    )
    
    @adapter.create_table :users do |t|
      t.column :department_id, :integer, :null => false
      t.foreign_key :on => :department_id, :references => :departments
    end
  end
  
  def test_create_table_should_allow_complex_constraint_syntax
    @adapter.expects(:execute).with(
      'CREATE TABLE users (' + 
      'id primary_key, ' +
      'department_id integer NOT NULL, ' +
      'CONSTRAINT fk_users_department_id_departments_dept_id ' + 
      'FOREIGN KEY (department_id) REFERENCES departments(dept_id)) '
    )
    
    @adapter.create_table :users do |t|
      t.column :department_id, :integer, :null => false
      t.foreign_key :on => :department_id, 
        :references => {:table => :departments, :column => :dept_id}
    end
  end
  
end
