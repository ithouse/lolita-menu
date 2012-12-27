require 'spec_helper'

describe Menu do

   describe "save whole tree" do

    it "should save tree for menu when array given" do
      menu=Menu.create!(:name=>"menu")
      root=menu.root(MenuItem)
      items=[]
      1.upto(3) do |index|
        item=MenuItem.create!(:name=>"item-#{index}")
        items << menu.append(item)
      end

      new_positions={
        :"0"=>{
          :item_id=>"root",
          :parent_id=>"none",
          :depth=>"0",
          :left => "1",
          :right => "8"
        },
        :"1"=>{
          :item_id => "#{items[0].id}",
          :parent_id => "root",
          :depth => "1",
          :left => "2",
          :right => "7"
        },
        :"2"=>{
          :item_id => "#{items[1].id}",
          :parent_id => "#{items[0].id}",
          :depth => "2",
          :left => "3",
          :right=> "6"
        },
        :"3"=>{
          :item_id => "#{items[2].id}",
          :parent_id => "#{items[1].id}",
          :depth => "3",
          :left => "4",
          :right=> "5"
        }
      }
      
      MenuItem.update_whole_tree(new_positions, {:menu_id => menu.id})

      menu.children(MenuItem).should have(1).item
      menu.children(MenuItem).first.children.should have(1).item
      menu.children(MenuItem).first.children.first.children.should have(1).item
    end
  end

  it "should create new menu item with name" do
    Menu.create!(:name=>"my menu").name.should == "my menu"
  end

  it "should not create menu without name" do
    lambda{
      Menu.create!
    }.should raise_error
  end

  describe "menu items" do

    let(:menu){Menu.create!(:name=>"new menu")}

    it "should create root item on create" do
      menu.root(MenuItem).should_not be_nil
    end

    it "should add new item to menu" do
      item=MenuItem.create!(:name=>"item",:url=>"/")
      menu.append(item)
      menu.items.should have(2).items
    end
 end
end
