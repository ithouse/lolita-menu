module Lolita
	module Menu
		module NestedTree
			module Scope
	
				def self.included(base_class)
					base_class.extend(ClassMethods)
					base_class.send(:include, InstanceMethods)
				end

				module ClassMethods
					def sees?(tree_class)
						tree_class.lolita_nested_tree.scope_classes.include?(self)
					end
				end

				module InstanceMethods
					def sees?(tree_class)
						self.class.sees?(tree_class)
					end

					#def root
					#	if branch = self.items.first
					#		item.root
					#	end
					#end

					#def children
					#	self.root.children
					#end

					#def append(item)
					#	unless item.menu_id == self.id
					#		item.menu_id = self.id
					#		item.save!
					#	end
					#	self.root.append(item)
					#	item.reload
					#	item
					#end

					#def have_root?
					#	!!self.root
					#end
				end

			end
		end
	end
end
