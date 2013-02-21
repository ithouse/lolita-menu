module Lolita
  module Menu
    module NestedTree
      class TreeBuilder

        attr_reader :items, :root

        def initialize(klass, items, scope_attributes = {})
          @klass  = klass
          @scope_attributes = scope_attributes
          @root = @klass.find_or_create_root(@scope_attributes)
          @items = items.is_a?(Hash) ? items.values : items
          @items.map! do |item| 
            Lolita::Menu::NestedTree::BranchBuilder.new(@root, item)
          end
        end

        def item_ids
          @items.map { |item| item.value_for(:item_id) }
        end

        def update_items
          @items.each do |item|
            @klass.update_item(item)
          end
          @klass.remove_items(deleted_items)
        end

        private

        def deleted_items
          @klass.with_tree_scope(@scope_attributes).all_tree_item_ids - item_ids
        end

      end
    end
  end
end
