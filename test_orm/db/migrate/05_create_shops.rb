class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops, :force=>true do |t|
      t.string  :name
      t.timestamps
    end
  end
end
