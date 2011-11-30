module Lolita
	module MenuHelper
		def lolita_menu_data_attributes_for_branch(scope)
			if scope
				key = self.resource_class.lolita_nested_tree.scope_key_for(scope.class)
				{:"data-id" => scope.id, :"data-url" => nested_trees_path(key.to_sym => scope.id, :tree_class => resource_class.to_s)}
			else
				{:"data-id" => "", :"data-url" => nested_trees_path(:tree_class => resource_class.to_s)}
			end
		end

		def lolita_menu_data_attributes_for_tree(scope)
			if scope
				key = self.resource_class.lolita_nested_tree.scope_key_for(scope.class)
				{:id => "nested_tree_#{scope.id}", :"data-url" => update_tree_nested_trees_path(key.to_sym => scope.id, :tree_class => resource_class.to_s)}
			else
				{:id => "nested_tree_", :"data-url" => update_tree_nested_trees_path(:tree_class => resource_class.to_s)}
			end
		end

		def lolita_menu_data_attributes_for_branch_delete(scope, item)
			default = {:"data-url" => nested_tree_path(item.id, :tree_class => resource_class.to_s), :"data-row" => "#item-#{item.id}"}
			if scope
				key = self.resource_class.lolita_nested_tree.scope_key_for(scope.class)
				default.merge({:"data-scope" => "#nested_tree_#{scope.id}"})
			else
				default.merge({:"data-scope" => "#nested_tree_"})
			end
		end
	end
end
