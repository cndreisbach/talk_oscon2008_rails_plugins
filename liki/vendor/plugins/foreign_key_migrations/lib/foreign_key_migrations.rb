require 'rubygems'
require 'activerecord'

module Viget #:nodoc:
  module ForeignKeyMigrations #:nodoc:
    module VERSION #:nodoc:
      MAJOR = 0
      MINOR = 3
      TINY  = 1

      STRING = [MAJOR, MINOR, TINY].join('.')
    end
  end
end

module_name = 'ActiveRecord::ConnectionAdapters'
adapter_names = [ 'MysqlAdapter', 'PostgreSQLAdapter', 'SQLiteAdapter', 'SQLite3Adapter' ]

libdir = File.dirname(__FILE__)

adapter_names.each do |name|
  filename = name.downcase.sub(/adapter$/, '_adapter')
  begin
    require "#{module_name.underscore}/#{filename}"
  rescue LoadError
    nil
  end
end

require File.join(libdir, "foreign_key_migrations/database_support")
require File.join(libdir, "foreign_key_migrations/database_support/postgresql_adapter")
require File.join(libdir, "foreign_key_migrations/database_support/sqlite_adapter")

require File.join(libdir, "foreign_key_migrations/schema_statements")
require File.join(libdir, "foreign_key_migrations/table_definition")
require File.join(libdir, "foreign_key_migrations/foreign_key_definition")

ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:alias_method, :pre_fk_create_table, :create_table)
ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, Viget::ForeignKeyMigrations::SchemaStatements)

# Enable foreign key migration support for the following databases.

adapter_names.each do |adapter_name|

  if module_name.constantize.const_defined?(adapter_name)
    adapter = "#{module_name}::#{adapter_name}".constantize
    adapter.send(:include, Viget::ForeignKeyMigrations::DatabaseSupport)
  end
  
end
