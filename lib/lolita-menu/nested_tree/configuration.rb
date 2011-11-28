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
				def lolita_nested_tree(options = {})
					@config ||= Lolita::Menu::NestedTree::Configuration.new(self, options)
				end
			end

			class Configuration

				attr_reader :klass, :options, :scope

				def initialize(base_class, options = {})
					@klass = base_class					
					@options = options || {}
					initialize_options
					normalize_attributes
					validate
					extend_scope_classes
				end

				def scope_keys
					@scope.map do |scope|
						@klass.reflect_on_association(scope.to_sym).foreign_key.to_sym
					end
				end

				def scope_classes
					@scope.map do |scope|
						@klass.reflect_on_association(scope.to_sym).klass
					end
				end

				private

				def initialize_options
					@options.each do |attr, value|
						self.respond_to?(attr.to_sym) && instance_variable_set(:"@#{attr}", value)
					end
				end

				def normalize_attributes
					@scope = (@scope.is_a?(Array) && @scope || [@scope]).compact
				end

				def validate
					@scope.each do |scope|
						raise ArgumentError, "#{@klass} should reflect on association #{scope}" unless @klass.reflect_on_association(scope.to_sym)
					end
				end

				def extend_scope_classes
					scope_classes.each do |klass|
						klass.send(:include, Lolita::Menu::NestedTree::Scope)
					end
				end

			end
		end
	end
end
