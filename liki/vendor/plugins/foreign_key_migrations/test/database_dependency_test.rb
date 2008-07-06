require 'test_helper'

class DatabaseDependencyTest < Test::Unit::TestCase
  
  def setup
    @adapter = ActiveRecord::ConnectionAdapters::AbstractAdapter.new(nil)
  end
  
  def test_mysql_should_have_foreign_keys
    ActiveRecord::ConnectionAdapters::MysqlAdapter.any_instance. \
      expects(:connect).returns(true)
    
    mysql = ActiveRecord::ConnectionAdapters::MysqlAdapter.new(nil, nil, nil, nil)
    
    mysql.expects(:execute).with(
      'CREATE TABLE users (' + 
      '`id` int(11) DEFAULT NULL auto_increment PRIMARY KEY, ' + 
      '`department_id` int(11) NOT NULL, ' +
      'CONSTRAINT fk_users_department_id_departments_id ' +
      'FOREIGN KEY (department_id) REFERENCES departments(id)' +
      ') ENGINE=InnoDB'
    ).returns(true)
    
    mysql.create_table :users do |t|
      t.column :department_id, :integer, :null => false, :references => :departments
    end
  end 
  
  def test_postgresql_should_have_foreign_keys
    ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.any_instance.stubs(:connect)

    postgresql = ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.new(nil, nil, nil, nil)
    
    postgresql.expects(:execute).with(
      'CREATE TABLE users (' +
      '"id" serial primary key, ' +
      '"department_id" integer NOT NULL, ' +
      'CONSTRAINT fk_users_department_id_departments_id ' +
      'FOREIGN KEY (department_id) REFERENCES departments(id)) '
    ).returns(true)
    
    postgresql.create_table :users do |t|
      t.column :department_id, :integer, :null => false, :references => :departments
    end
  end 

  def test_sqlite_should_have_foreign_keys    
    sqlite = ActiveRecord::ConnectionAdapters::SQLiteAdapter.new(nil)

    sqlite.expects(:execute).with('select sqlite_version(*)', 
                                  nil).returns([{"2.8.17" => "2.8.17"}])
    
    sqlite.expects(:execute).with(
      'CREATE TABLE users (' +
      '"id" INTEGER PRIMARY KEY NOT NULL, ' +
      '"department_id" integer NOT NULL, ' +
      'CONSTRAINT fk_users_department_id_departments_id ' +
      'FOREIGN KEY (department_id) REFERENCES departments(id)) '
    ).returns(true)
    
    sqlite.create_table :users do |t|
      t.column :department_id, :integer, :null => false, :references => :departments
    end
  end
  
  def test_sqlite3_should_have_foreign_keys    
    sqlite3 = ActiveRecord::ConnectionAdapters::SQLite3Adapter.new(nil)

    sqlite3.expects(:execute).with('select sqlite_version(*)', 
                                   nil).returns([{"3.4.2" => "3.4.2"}])    
    sqlite3.expects(:execute).with(
      'CREATE TABLE users (' +
      '"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ' +
      '"department_id" integer NOT NULL, ' +
      'CONSTRAINT fk_users_department_id_departments_id ' +
      'FOREIGN KEY (department_id) REFERENCES departments(id)) '
    ).returns(true)
    
    sqlite3.create_table :users do |t|
      t.column :department_id, :integer, :null => false, :references => :departments
    end
  end

  def test_sqlite_alter_table_should_do_nothing
    sqlite = ActiveRecord::ConnectionAdapters::SQLiteAdapter.new(nil)
    
    sqlite.expects(:execute).never
    
    sqlite.add_foreign_key(
      :on => {:table => :employees, :column => :manager_id}, 
      :references => {:table => :employees, :column => :employee_id})
      
    sqlite.drop_foreign_key(
      :on => {:table => :employees, :column => :manager_id}, 
      :references => {:table => :employees, :column => :employee_id})
  end
  
  def test_sqlite3_alter_table_should_do_nothing
    sqlite3 = ActiveRecord::ConnectionAdapters::SQLite3Adapter.new(nil)
    
    sqlite3.expects(:execute).never
    
    sqlite3.add_foreign_key(
      :on => {:table => :employees, :column => :manager_id}, 
      :references => {:table => :employees, :column => :employee_id})

    sqlite3.drop_foreign_key(
      :on => {:table => :employees, :column => :manager_id}, 
      :references => {:table => :employees, :column => :employee_id})

  end
  
  def test_postgresql_needs_a_different_drop_syntax
    ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.any_instance.stubs(:connect)
    
    postgresql = ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.new(nil, nil, nil, nil)
    
    postgresql.expects(:execute).with(
      'ALTER TABLE employees ' + 
        'DROP CONSTRAINT fk_employees_manager_id_employees_employee_id'
    ).returns(true)
    
    postgresql.drop_foreign_key(
      :on => {:table => :employees, :column => :manager_id}, 
      :references => {:table => :employees, :column => :employee_id})
  end
  
end
