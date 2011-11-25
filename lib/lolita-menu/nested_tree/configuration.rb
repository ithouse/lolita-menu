module Lolita
	module Menu
		module NestedTree
			module ClassMethods
				# Allows to use tree structure relationship between model records
				#
				# ===
				#
				# Usage:
				#
				# lolita_nested_tree :scope => "User"
				#
				# ===
				#
				# Configuration options:
				# * <tt>:scope</tt> - model name (as String)
				#
				def lolita_nested_tree(*attrs)
					@config ||= Lolita::Menu::NestedTree::Configuration.new(self, *attrs)
				end
			end

			class Configuration

				attr_reader :klass, :options, :attrs, :scope

				def initialize(base_class, *attrs)
					@klass = base_class					
					@attrs = attrs
					initialize_options
					initialize_attributes
					extend_class
				end

				private

				def initialize_options
					@options = {
						:scope => nil
					}.merge(@attrs.extract_options!)
					@options.assert_valid_keys(:scope)
				end

				def initialize_attributes
					@scope ||= Lolita::Menu::NestedTree::Scope.new(@options[:scope])
				end

				def extend_class
					config = self
					@klass.class_eval do

						class_attribute :nested_tree
						self.nested_tree = config

					end
				end
			end
		end
	end
end
