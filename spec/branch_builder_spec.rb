require "spec_helper"

describe "BranchBuilder" do
	before(:each) { MenuItem }
	let(:builder_class) { Lolita::Menu::NestedTree::BranchBuilder }
	it "should create new" do
		expect { builder_class.new(Object.new, {}) }.to_not raise_error
	end

	it "should detect if item is root" do
		builder = builder_class.new(Object.new, {:item_id => "root"})
		builder.root?.should be_true
	end

	it "should return value for attribute" do
		root = MenuItem.create_root!
		builder = builder_class.new(root, {:left => 1, :right => 4, :depth => 0, :parent_id => "none", :item_id => "root"})
		builder.value_for(:left).should == 1
		builder.value_for(:parent_id).should be_nil
		builder.value_for(:item_id).should == root.id
	end

	it "should return attribute value pairs" do
		root = MenuItem.create_root!
		builder = builder_class.new(root, {:left => 1, :right => 4, :depth => 0, :parent_id => "none", :item_id => "root"})
		builder.attribute_value_pairs.sort.should == [[:depth, 0], [:item_id, root.id], [:"lft", 1], [:"parent_id", nil], [:"rgt", 4]]
	end

	it "should return attribute value pairs hash" do
		root = MenuItem.create_root!
		builder = builder_class.new(root, {:left => 1, :right => 4, :depth => 0, :parent_id => "none", :item_id => "root"})
		builder.attribute_value_pairs_hash.should == {:lft => 1, :rgt => 4, :depth => 0, :parent_id => nil}
	end
end
