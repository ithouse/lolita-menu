require "spec_helper"

describe "TreeBuilder" do
	before(:each) { MenuItem }
	let(:builder_class) { Lolita::Menu::NestedTree::TreeBuilder }
	let(:items) {[
		{:depth => 0, :item_id => "root", :left => 1, :parent_id => "none", :right => 4}, 
		{:depth => 1, :item_id => "2", :left => 2, :parent_id => "root", :right => 3} 
	]}
	let(:builder) {builder_class.new(MenuItem, items)}

	def menu_item
		MenuItem.create!(:name => "Item")
	end

	it "should create new" do
		expect do 
			builder_class.new(MenuItem, [{:depth => 0, :item_id => "root", :left => 1, :parent_id => "none", :right => 12}])
		end.not_to raise_error
	end

	it "should include BranchBuilder objects as items" do
		builder.items.each do |item|
			item.should be_a(Lolita::Menu::NestedTree::BranchBuilder)
		end
	end

	it "should collect item ids" do
		builder.item_ids.sort.should == [builder.root.id, 2].sort
	end

	it "should update items" do
		MenuItem.delete_all
		root = MenuItem.create_root!
		item_1 = menu_item
		item_2 = menu_item
		root.append(item_1)
		root.append(item_2)
		items = [
			{:left => 1, :right => 6, :depth => 0, :parent_id => "none", :item_id => "root"},
			{:left => 2, :right => 3, :depth => 1, :parent_id => "root", :item_id => item_1.id}
		]
		MenuItem.count.should == 3
		builder = builder_class.new(MenuItem, items)
		builder.update_items
		MenuItem.all.should have(2).items
	end

end
