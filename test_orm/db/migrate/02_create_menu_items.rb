class CreateMenuItems < ActiveRecord::Migration
  def self.up
    create_table :menu_items do |t|
      t.string  :name
      t.string  :url
      t.integer :menu_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.integer :parent_id
      t.boolean :is_visible
      t.timestamps
    end

    add_index :menu_items, :menu_id
    add_index :menu_items, [:lft,:rgt,:menu_id,:parent_id]
    add_index :menu_items, :lft # for sorting
    add_index :menu_items, :rgt
    add_index :menu_items, :depth
    add_index :menu_items, :parent_id
    add_index :menu_items, :is_visible
  end

  def self.down
    drop_table :menu_items
  end
end
