require "lolita-menu/nested_tree/configuration"
require "lolita-menu/nested_tree/modules"
require "lolita-menu/nested_tree/scope"

module Lolita
	module Menu
		module NestedTree
			# Extending base class with class methods
			def self.included(base_class)
				base_class.extend(Lolita::Menu::NestedTree::ClassMethods)
			end

			def visible?
				self.is_visible
			end

			def root?
				self.parent_id.nil?
			end

			def parent
				@parent ||= self.class.find_by_id(self.parent_id)
			end

			def parent=(parent_item)
				@parent = parent_item
			end

			def children
				@children ||= self.class.where("lft>:left AND rgt<:right AND depth=:depth",{
					:left => self.lft,:right => self.rgt,:depth => self.depth+1
				}).with_tree_scope(self).order("lft asc")
			end

			def self_and_descendants
				@self_and_descendants ||= self.class.where("lft>=:left AND rgt<=:right",{
					:left => self.lft,:right => self.rgt
				}).with_tree_scope(self).order("lft asc")
			end

			def root
				if self.parent_id.nil?
					self
				else
					criteria = self.class.where(:parent_id=>nil).with_tree_scope(self).first
				end
			end

			def append(item)
				append_item(item)
				recalculate_positions_after(:append)
			end

			private

			def set_default_positions
				if am_i_new_root? || !scope_ids.all?
					set_root_position
				else
					self.place=:append
				end
			end

			def am_i_new_root?
				scope_ids.all? && scope_records.all? && first_record_within_scope?
			end

			def scope_ids
				self.class.nested_tree.scope.classes.map do |scope|
					self.send(scope.foreign_key.to_sym)
				end
			end

			def scope_records
				self.class.nested_tree.scope.classes.map do |scope|
					scope.constantize.exists?(self.send(scope.foreign_key.to_sym))
				end
			end

			def first_record_within_scope?
				!self.class.with_tree_scope(self).first
			end

			def set_root_position
				self.class.default_root_position.each do |method,value|
					unless self.send(method)
						self.send(:"#{method}=",value)
					end
				end
			end

			def append_item(item)
				position=position_for_append
				self.class.update_all(positions_to_update_string(position),"id=#{item.id}")
			end

			def recalculate_positions_after(action)
				if action==:append
					self.class.update_all("rgt=#{self.rgt+2}","id=#{self.id}")
				end
			end

			def positions_to_update_string(positions)
				result=[]
				positions.each do |field,value|
					result<<"#{field}=#{value}"
				end
				result.join(", ")
			end

			def position_for_append
				{
					:lft => self.rgt,
					:rgt => self.rgt+1,
					:depth => self.depth+1,
					:parent_id => self.id
				}
			end

		end
	end
end
