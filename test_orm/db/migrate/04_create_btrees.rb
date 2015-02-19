class CreateBtrees < ActiveRecord::Migration
  def self.up
    create_table :btrees, :force=>true do |t|
      t.string  :name
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.integer :parent_id
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :btrees
  end
end
