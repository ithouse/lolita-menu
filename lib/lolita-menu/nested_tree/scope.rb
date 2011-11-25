module Lolita
	module Menu
		module NestedTree
			class Scope

				attr_reader :classes

				def initialize scope
					@classes = case scope
										 when String; [scope]
										 when Array; scope
										 else; []
										 end
				end

				private

				def create_root
					
				end

			end
		end
	end
end
