require 'test_helper'

class AddDropForeignKeyTest < Test::Unit::TestCase
  
  def setup
    @adapter = ActiveRecord::ConnectionAdapters::AbstractAdapter.new(nil)
    @adapter.stubs(:supports_foreign_keys?).returns(true)
  end

  def test_full_migration_data_should_return_valid_sql
    @adapter.expects(:execute).once.with(
      "ALTER TABLE employees ADD CONSTRAINT " +
      "fk_employees_manager_id_employees_employee_id FOREIGN KEY (manager_id) " +
      "REFERENCES employees(employee_id)").returns(true)
    
    assert(@adapter.add_foreign_key(
      :on => {:table => :employees, :column => :manager_id}, 
      :references => {:table => :employees, :column => :employee_id}))
  end
  
  def test_full_migration_data_with_on_delete_action_should_return_valid_sql
    @adapter.expects(:execute).once.with(
      "ALTER TABLE employees ADD CONSTRAINT " +
      "fk_employees_manager_id_employees_employee_id FOREIGN KEY (manager_id) " +
      "REFERENCES employees(employee_id) ON DELETE CASCADE").returns(true)
    assert(@adapter.add_foreign_key(
      :on => {:table => :employees, :column => :manager_id}, 
      :references => {:table => :employees, :column => :employee_id},
      :actions => {:delete => :cascade}))
  end
  
  def test_add_foreign_key_should_fail_with_no_params
    assert_raise(ArgumentError) { @adapter.add_foreign_key }
  end
  
  def test_add_foreign_key_should_fail_with_no_on_or_references
    assert_raise(ArgumentError) { @adapter.add_foreign_key(
      :references => {:table => :employee, :column => :employee_id})}
    assert_raise(ArgumentError) { @adapter.add_foreign_key(
      :on => {:table => :employee, :column => :employee_id})}  
  end
  
  def test_add_foreign_key_data_with_table_names_only_should_work
    @adapter.expects(:execute).once.with(
      "ALTER TABLE employees ADD CONSTRAINT " +
      "fk_employees_department_id_departments_id FOREIGN KEY (department_id) " +
      "REFERENCES departments(id)").returns(true)
      
    assert(@adapter.add_foreign_key(
      :on => 'employees', :references => 'departments'))
  end

  def test_add_foreign_key_data_with_table_names_only_should_work_with_symbols
    @adapter.expects(:execute).once \
      .with("ALTER TABLE employees ADD CONSTRAINT " +
            "fk_employees_department_id_departments_id FOREIGN KEY (department_id) " +
            "REFERENCES departments(id)").returns(true)
    
    assert(@adapter.add_foreign_key(:on => :employees, :references => :departments))
  end

  
  def test_delete_foreign_key_should_work_with_full_data
    @adapter.expects(:execute).once.with(
      "ALTER TABLE employees DROP FOREIGN KEY " +
      "fk_employees_manager_id_employees_employee_id").returns(true)
    
    assert(@adapter.drop_foreign_key(
      :on => {:table => :employees, :column => :manager_id}, 
      :references => {:table => :employees, :column => :employee_id}))
  end

  def test_delete_foreign_key_should_work_with_only_table_names
    @adapter.expects(:execute).once.with(
      "ALTER TABLE employees DROP FOREIGN KEY " +
      "fk_employees_department_id_departments_id").returns(true)
    
    assert(@adapter.drop_foreign_key(
      :on => 'employees', :references => 'departments'))
  end
  
  def test_delete_foreign_key_should_work_with_ids
    @adapter.expects(:execute).once.with(
      "ALTER TABLE employees DROP FOREIGN KEY " +
      "fk_this_is_a_fake_id").returns(true)
    
    assert(@adapter.drop_foreign_key(
      :on => 'employees', :id => 'fk_this_is_a_fake_id'))
  end
  
  def test_format_action_option_should_format_option
    params = {:restrict => 'RESTRICT', :cascade => 'CASCADE', :set_null => 'SET NULL', :no_action => 'NO ACTION'}
    params.each do |input, expected|
      assert_equal expected, @adapter.send(:format_action_option, input)
    end
  end
  
  def test_format_action_option_with_unrecognized_option_should_raise_exception
    assert_raise(Viget::ForeignKeyMigrations::SchemaStatements::UnsupportedActionOption) { @adapter.send(:format_action_option, :foo)}
  end
  
  def test_build_foreign_key_actions_with_empty_hash_should_return_empty_string
    assert_equal '', @adapter.send(:build_foreign_key_actions, {})
  end
  
  def test_build_foreign_key_actions_with_delete_action_should_return_proper_sql
    assert_equal ' ON DELETE CASCADE', @adapter.send(:build_foreign_key_actions, {:delete => :cascade})
  end
  
  def test_build_foreign_key_actions_with_update_and_delete_action_should_return_proper_sql
    assert_equal ' ON UPDATE SET NULL ON DELETE CASCADE', @adapter.send(:build_foreign_key_actions, {:delete => :cascade, :update => :set_null})
  end

  def test_full_add_foreign_key_syntax
    @adapter.expects(:execute).once.returns(true).with \
    "ALTER TABLE indexings ADD CONSTRAINT " +
      "fk_indexings_media_id_media_id FOREIGN KEY (media_id) " +
      "REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE"

    assert(@adapter.add_foreign_key(:on => {:table => :indexings, :column => :media_id},
                                    :references => {:table => :media, :column => :id},
                                    :actions    => {
                                      :delete => :cascade, 
                                      :update => :cascade}
                                    ))
  end
  
end
