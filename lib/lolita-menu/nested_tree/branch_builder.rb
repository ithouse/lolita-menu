module Lolita
	module Menu
		module NestedTree
			class BranchBuilder

				ROOT = "root"
				NONE = "none"

				def initialize(root, attributes)
					@root = root
					@attributes = attributes || {}
				end

				def root?
					@attributes[:item_id] == "root"
				end

				def value_for(attribute)
					convert(@attributes[attribute.to_sym])
				end

				def attribute_value_pairs
					@attributes.map do |attr, value|
						[mapping[attr], convert(value)]
					end
				end

				private

				def mapping
					{
						:left => :lft,
						:right => :rgt,
						:depth => :depth,
						:parent_id => :parent_id,
						:item_id => :item_id
					}
				end

				def convert(value)
					if value == ROOT
						@root.id
					elsif value == NONE || !value 
						nil
					else 
						value.to_i
					end
				end

			end
		end
	end
end
