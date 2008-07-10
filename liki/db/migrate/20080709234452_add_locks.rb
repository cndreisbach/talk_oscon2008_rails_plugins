class AddLocks < ActiveRecord::Migration
  def self.up
    create_table "locks" do |t|
      t.integer :page_id
      t.integer :user_id
    end
  end

  def self.down
  end
end
