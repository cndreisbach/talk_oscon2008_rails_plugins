class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :post_id, :integer, :null => false
      t.column :poster_id, :integer, :null => false
      t.column :poster_type, :string, :null => false
      t.column :content, :text, :null => false, :default => ''
      t.timestamps 
    end
  end

  def self.down
    drop_table :comments
  end
end
