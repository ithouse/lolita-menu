module Lolita
	module Menu
		module NestedTree

			module ClassMethods
				def default_root_position
					{
						:lft=>1,
						:rgt=>2,
						:depth=>0,
						:parent_id=>nil
					}
				end

				def with_tree_scope(record)
					criteria = {}
					self.nested_tree.scope.classes.each do |scope|
						criteria[scope.foreign_key.to_sym] = record.send(scope.foreign_key.to_sym)
					end
					where(criteria)
				end
			end

		end
	end
end

