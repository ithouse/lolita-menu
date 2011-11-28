require "lolita-menu/nested_tree/configuration"
require "lolita-menu/nested_tree/scope"
require "lolita-menu/nested_tree/branch_builder"

module Lolita
	module Menu
		module NestedTree
			def self.included(base_class)
				base_class.extend(Lolita::Menu::NestedTree::ClassMethods)
				base_class.class_eval do
					include Lolita::Menu::NestedTree::InstanceMethods
					attr_accessor :place
					before_validation :set_default_name, :if => :new_record?
					before_create :set_default_positions
					after_create :put_in_place
				end
			end

			module ClassMethods
				def create_root!
					item = self.create!(with_tree_scope.merge(default_root_position))
					self.refresh_scopes(item)
					item
				end

				def default_root_position
					{
						:lft=>1,
						:rgt=>2,
						:depth=>0,
						:parent_id=>nil
					}
				end

				def root
					where(with_tree_scope.merge(:parent_id=>nil)).first
				end

				def with_tree_scope(record_or_hash=nil, &block)
					if record_or_hash
						scope_hash = record_or_hash.respond_to?(:to_scope_hash) ? record_or_hash.to_scope_hash : record_or_hash
						if block_given?
							begin
								@lolita_menu_nested_tree_scope = scope_hash
								instance_eval(&block)
							ensure
								@lolita_menu_nested_tree_scope = nil
							end
						else
							where(scope_hash)
						end
					else
						@lolita_menu_nested_tree_scope || {}
					end
				end

				def update_whole_tree(items, params = {})
					begin
						self.transaction do
							tree_builder = Lolita::Menu::NestedTree::TreeBuilder.new(self, items, params)
							tree_builder.update_items
							true
						end
					end
				end

				def refresh_scopes(item)
					
				end
			end

			module InstanceMethods
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
						self.class.root
					end
				end

				def append(item)
					append_item(item)
					recalculate_positions_after(:append)
				end

				def to_scope_hash
					self.class.lolita_nested_tree.scope_keys.inject({}) do |result, key|
						result[key] = self.send(key)
						result
					end					
				end

				private

				def set_default_positions
					if am_i_new_root? #|| !scope_ids.all?
						set_root_position
					else
						self.place=:append
					end
				end

				def set_default_name
					self.name ||= "root"
				end

				def am_i_new_root?
					#scope_ids.all? && scope_records.all? && 
					first_record_within_scope?
				end

				#def scope_ids
				#	self.class.lolita_nested_tree.scope_keys.map do |key|
				#		self.send(key)
				#	end
				#end

				#def scope_records
				#	self.class.lolita_nested_tree.scope_keys.map do |scope|
				#		scope.constantize.exists?(self.send(scope.foreign_key.to_sym))
				#	end
				#end
				
				def put_in_place
					if place==:append
						item = self
						self.class.with_tree_scope(self) do 
							root.append(item)
						end
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
end
