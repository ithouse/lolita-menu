module Lolita
	module Menu
		module NestedTree
			class BranchBuilder

				ROOT = "root"
				NONE = "none"

				def initialize(root, attributes)
					@root = root
					@attributes = {}
					(attributes || {}).each do |key,value|
						@attributes[key.to_sym] = value
					end
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

				def attribute_value_pairs_hash
					hash = {}
					attribute_value_pairs.each do |pair|
						next if pair[0] == :item_id
						hash[pair[0]] = pair[1]
					end
					hash
				end

				private

				def mapping
					unless @mapping
						@mapping = {
							:left => :lft,
							:right => :rgt
						}
						class << @mapping
							def [](key)
								self.keys.include?(key) ? self.fetch(key) : key
							end
						end
					end
					@mapping
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
