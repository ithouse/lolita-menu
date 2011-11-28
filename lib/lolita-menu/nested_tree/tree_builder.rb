module Lolita
	module Menu
		module NestedTree
			class TreeBuilder

				def initialize(klass, items, scope_attributes = {})
					@klass  = klass
					@scope_attributes = scope_attributes
					@root = find_or_create_root
					@items = items.map do |item| 
						Lolita::Menu::NestedTree::BranchBuilder.new(@root, item)
					end
				end

				private

				def find_or_create_root
					if root = @klass.with_tree_scope(scope_attributes).root.first
						root
					else
						root = nil
						@klass.with_tree_scope(scope_attributes) do
							root = create_root!
						end
						root
					end
				end

			end
		end
	end
end

