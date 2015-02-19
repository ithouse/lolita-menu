class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories, :force=>true do |t|
      t.string  :name
      t.string  :url
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.integer :parent_id
      t.boolean :is_visible
      t.timestamps null: false
    end

    add_index :categories, [:lft,:rgt,:parent_id]
    add_index :categories, :lft # for sorting
    add_index :categories, :rgt
    add_index :categories, :depth
    add_index :categories, :parent_id
    add_index :categories, :is_visible
  end

  def self.down
    drop_table :categories
  end
end
