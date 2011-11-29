require "spec_helper"

describe "Nested tree" do
	let(:btree) {Btree.new}

	it "should create new Category instance" do
		Category.new.should_not be_nil
	end

	it "should create root tree item" do
		Category.create_root!.should be_an_instance_of(Category)
	end

	describe "adding records" do
		let(:root) { Category.find_or_create_root }
		
		it "should be root" do
			root.root?.should be_true
		end

		it "should find root" do
			root = Category.create_root!
			root.should == Category.root
		end

		it "add item to root" do
			root.append(Category.create!)
			root.reload
			root.children.size.should == 1
		end

		it "should be parent of new item" do
			new_item = Category.create!
			new_item.parent = root
			new_item.reload
			new_item.parent.should == root
		end
	end

	it "should change behavior when module is included" do
		Btree.respond_to?(:create_root!).should be_false
		btree.respond_to?(:root?).should be_false
		Btree.send(:include, Lolita::Menu::NestedTree)
		Btree.respond_to?(:create_root!).should be_true
		btree.respond_to?(:root?).should be_true
	end

	describe "configuration" do
		let(:complex) { Lolita::Menu::NestedTree::Configuration.new(Btree, {:scope => [:shop, :category]}) }		
		before(:each) do
			Btree.send(:include, Lolita::Menu::NestedTree)
		end

		def add_associations(names)
			names.each { |name| Btree.belongs_to(name) }
		end

		it "should be created without options" do
			expect do 
				Lolita::Menu::NestedTree::Configuration.new(Btree)	
			end.to_not raise_error
		end

		it "should be created without options" do
			expect do 
				Lolita::Menu::NestedTree::Configuration.new(Btree, :scope => :shop)	
			end.to raise_error(ArgumentError, /Btree should reflect/)
		end

		it "should be created" do
			add_associations([:shop])
			config = Lolita::Menu::NestedTree::Configuration.new(Btree, {:scope => :shop})
			config.scope.sort.should == [:shop]
		end

		it "should be created when scope array is given" do
			add_associations([:shop, :category])
			complex.scope.sort.should == [:category, :shop]
		end

		it "should return foreign keys for scope" do
			add_associations([:shop, :category])
			complex.scope_keys.sort.should == [:"category_id", :"shop_id"]
		end

		it "should notify scope classes" do
			add_associations([:shop, :category])
			complex.scope_classes.each do |klass|
				klass.respond_to?(:sees?, complex.klass).should be_true
				klass.new.respond_to?(:sees?, complex.klass).should be_true
			end
		end
	end

	describe "scoping" do
		before(:each) do
			@item_1 = MenuItem.create!(:name => "Item1", :menu_id => 3)
			@item_2 = MenuItem.create!(:name => "Item2", :menu_id => 2)
		end

		it "should return criteria based on record" do
			MenuItem.with_tree_scope(@item_1).should have(1).item
		end

		it "should return criteria based on hash" do
			MenuItem.with_tree_scope(:menu_id => 2).should have(1).item
		end

		it "should accept block" do
			MenuItem.with_tree_scope(@item_1) do
				where(with_tree_scope).count.should == 1
			end
		end
	end
end
