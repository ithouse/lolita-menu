require 'spec_helper'

describe MenuItem do

  it "should create valid menu item" do
    MenuItem.create!(:name=>"item",:url=>"/")
  end

  describe "positioning items" do
      
    let(:menu){Menu.create!(:name=>"new menu")}

    it "should append" do
      root=MenuItem.create!
      item=MenuItem.create!(:name=>"child",:url=>"/")
      root.append(item)
      item.reload
      item.parent.should == root
    end

  end

  describe "getting by possitions" do

    let(:menu){Menu.create!(:name=>"menu")}
    let(:item){MenuItem.create!(:name=>"child",:url=>"/")}

    it "should find children" do
      menu.append(item)
      menu.root.children.should have(1).item
      menu.root.children.first == item
    end

    it "should find parent" do
      menu.append(item)
      item.reload
      item.parent.should == menu.root
    end

    it "should find root for any item" do
      menu.append(item)
      item.reload
      item.root.should == menu.root
      menu.root.root.should == menu.root
    end
  end
end
