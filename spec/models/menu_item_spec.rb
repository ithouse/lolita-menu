require 'spec_helper'

describe MenuItem do

  it "should create valid menu item" do
    MenuItem.create!(:name=>"item",:url=>"/")
  end

  describe "recognize active item" do

    let(:menu){Menu.create!(:name=>"new menu")}

    let(:request){
      mock_obj = double
      mock_obj.stub(:params).and_return({})
      mock_obj
    }

    it "should recognize full paths" do
      item = menu.append(MenuItem.create!(:name => "Name", :url => "http://google.lv"))
      request.stub(:url).and_return("http://google.lv")
      item.active?(request).should be_truthy
    end

    it "should recognize relative paths" do
      item = menu.append(MenuItem.create!(:name => "Name", :url => "/posts"))
      request.stub(:path).and_return("/posts?page=1")
      item.active?(request).should be_truthy
    end

    it "should recognize relative paths with arguments" do
      item = menu.append(MenuItem.create!(:name => "Name", :url => "/:whoes/posts"))
      request.stub(:path).and_return("/my/posts?page=1")
      request.stub(:params).and_return({:whoes => "my"})
      item.active?(request).should be_truthy
    end
  end

  describe "positioning items" do
      
    let(:menu){Menu.create!(:name=>"new menu")}

    it "should append" do
      root=MenuItem.create!(:name => "root")
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
      menu.root(MenuItem).children.count.should eq(1)
      menu.root(MenuItem).children.first == item
    end

    it "should find parent" do
      menu.append(item)
      item.reload
      item.parent.should == menu.root(MenuItem)
    end

    it "should find root for any item" do
      menu.append(item)
      item.reload
      item.root.should == menu.root(MenuItem)
      menu.root(MenuItem).root.should == menu.root(MenuItem)
    end
  end
end
