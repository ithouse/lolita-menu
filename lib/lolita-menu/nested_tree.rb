require "lolita-menu/nested_tree/configuration"
require "lolita-menu/nested_tree/scope"
require "lolita-menu/nested_tree/branch_builder"
require "lolita-menu/nested_tree/tree_builder"

module Lolita
  module Menu
    module NestedTree
      def self.included(base_class)
        base_class.extend(Lolita::Menu::NestedTree::ClassMethods)
        base_class.class_eval do
          include Lolita::Menu::NestedTree::InstanceMethods
          attr_accessor :place
          before_create :set_default_positions
          after_create :put_in_place
        end
        if base_class.respond_to?(:after_lolita_loaded)
          base_class.after_lolita_loaded do
            if self.lolita_nested_tree.scope_classes.any?
              parent_scope_columns = self.lolita_nested_tree.scope_classes.first.lolita.list.columns
              parent_scope_actions = self.lolita_nested_tree.scope_classes.first.lolita.list.actions
              #parent_scope_columns.actions = self.lolita.list.columns.actions
              self.lolita.list.columns = parent_scope_columns
              self.lolita.list.instance_variable_set(:@temp_actions, parent_scope_actions)
            end
            self.lolita.list.pagination_method ||= :paginate_nested_tree
            self.lolita.list.builder = {:name => "/lolita/menu/nested_tree", :state => :display, :if =>{:state =>:display}}
          end
        end
      end

      def self.is_tree?(klass)
        klass.respond_to?(:lolita_nested_tree) && klass.lolita_nested_tree
      end

      module ClassMethods

        def paginate_nested_tree(page,per_page,options)
          if scope_class = self.lolita_nested_tree.scope_classes.first
            scope_class.page(page).per(per_page)
          else
            where(nil)
          end
        end

        def create_root!
          new_branch = self.build_empty_branch(default_root_position)
          new_branch.save!
          new_branch
        end

        def find_or_create_root(attributes = {})
          if root = self.with_tree_scope(attributes).root
            root
          else
            root = nil
            self.with_tree_scope(attributes) do
              root = create_root!
            end
            root
          end
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
          where(with_tree_scope.merge(:parent_id=>nil)).where("lft>0").order("lft asc").first
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

        def build_empty_branch(attributes)
          if self.lolita_nested_tree.build_method && self.respond_to?(self.lolita_nested_tree.build_method)
            self.send(self.lolita_nested_tree.build_method, attributes.merge(with_tree_scope))
          else
            self.new(attributes)
          end
        end

        def update_item(item)
          self.where(:id => item.value_for(:item_id)).update_all(item.attribute_value_pairs_hash)
        end

        def remove_items(ids)
          self.where(:id => ids).delete_all
        end

        def all_tree_item_ids
          self.all.map(&:id)
        end

        def only_children
          where("rgt-lft=1")
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
          @children ||= self.class.where(:parent_id => self.id).with_tree_scope(self).order("lft asc")
        end

        def self_and_descendants
          @self_and_descendants ||= self.class.where("lft>=:left AND rgt<=:right",{
            :left => self.lft,:right => self.rgt
          }).with_tree_scope(self).order("lft asc")
        end

        def descendants
          @descendants ||= self.class.where("lft>:left AND rgt<:right",{
            :left => self.lft, :right => self.rgt
          }).with_tree_scope(self).order("lft asc")
        end

        def ancestors
          @ancestors ||= self.class.where("lft<:left AND rgt>:right AND parent_id IS NOT NULL",{
            :left => self.lft, :right => self.rgt
          }).with_tree_scope(self).order("lft asc")
        end

        def parents
          unless @parent
            current_parent_id = self.parent_id
            @parents = self.ancestors.reverse.inject([]){|results,item|
              if item.parent_id && item.id == current_parent_id
                current_parent_id = item.parent_id
                [item] + results
              else
                results
              end
            }
          end
          @parents
        end

        def only_children
          @only_children ||= self.class.with_tree_scope(self).order("lft asc")
        end

        def root
          if self.parent_id.nil?
            self
          else
            self.class.root
          end
        end

        def append(item)
          raise ArgumentError, "can't append itself" if self == item
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

        def am_i_new_root?
          #scope_ids.all? && scope_records.all? &&
          !(self.class.with_tree_scope(self) do
            root
          end)
        end

        #def scope_ids
        # self.class.lolita_nested_tree.scope_keys.map do |key|
        #   self.send(key)
        # end
        #end

        #def scope_records
        # self.class.lolita_nested_tree.scope_keys.map do |scope|
        #   scope.constantize.exists?(self.send(scope.foreign_key.to_sym))
        # end
        #end

        def put_in_place
          if place==:append
            item = self
            self.class.with_tree_scope(self) do
              root.append(item)
            end
          end
        end

        def set_root_position
          self.class.default_root_position.each do |method,value|
            unless self.send(method)
              self.send(:"#{method}=",value)
            end
          end
        end

        def append_item(item)
          attributes = self.class.with_tree_scope.merge(position_for_append)
          builder = Lolita::Menu::NestedTree::BranchBuilder.new(nil, attributes)
          self.class.where(:id => item.id).update_all(builder.attribute_value_pairs_hash)
        end

        def recalculate_positions_after(action)
          if action==:append
            self.class.where(:id => self.id).update_all(:rgt=> self.rgt+2)
          end
        end

        def position_for_append
          {
            :left => self.rgt,
            :right => self.rgt+1,
            :depth => self.depth+1,
            :parent_id => self.id
          }
        end
      end

    end
  end
end
