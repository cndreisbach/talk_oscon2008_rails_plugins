require File.join(File.dirname(__FILE__), '../lib/foreign_key_migrations')
require 'test/unit'
require 'mocha'

ActiveRecord::Migration.verbose = false

class TestDB < ActiveRecord::Migration
  def self.up
    create_table :factories do |t|
      t.string :name
    end

    create_table :widgets do |t|
      t.string :name
      t.integer :factory_id
    end
  end

  def self.down
    drop_table :widgets
    drop_table :factories
  end
end

