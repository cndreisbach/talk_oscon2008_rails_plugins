class CreateBloggers < ActiveRecord::Migration
  def self.up
    create_table :bloggers do |t|
      t.column :poster_id, :integer, :null => false
      t.column :poster_type, :string, :null => false
      t.timestamps 
    end
    
    add_index :bloggers, [:poster_id, :poster_type], :unique => true
  end

  def self.down
    drop_table :bloggers
  end
end
