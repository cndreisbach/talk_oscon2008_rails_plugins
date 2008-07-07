class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |table|
      table.with_options :null => false do |t|
        t.string :title
        t.text :body
        t.integer :version
      end
      table.timestamp :deleted_at
      table.timestamps
    end
    
    create_table :page_versions do |table|
      table.with_options :null => false do |t|
        t.string :title
        t.text :body
        t.integer :version
        t.references :page
      end
      table.timestamps
    end
    
  end

  def self.down
    drop_table :pages
  end
end
