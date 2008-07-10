class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :permalink, :null => false, :unique => true
      t.integer :poster_id, :null => false
      t.string :poster_type, :null => false
      t.string :title, :null => false
      t.text :content, :null => false, :default => ''
      t.string :state, :null => false, :default => 'draft'
      t.timestamps 
    end
  end

  def self.down
    drop_table :posts
  end
end
