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

          def root(tree_class, scope_attributes = {})
            tree_class.find_or_create_root(merge_scope_with_self(tree_class, scope_attributes))
          end

          def children(*args)
            self.root(*args).children
          end

          def append(item, scope_attributes = {})
            scope_attributes = merge_scope_with_self(item.class, scope_attributes)
            scope_root = self.root(item.class, scope_attributes)
            item.class.with_tree_scope(scope_attributes) do
              scope_root.append(item)
              item.reload
            end
            item
          end

          private

          def merge_scope_with_self(tree_class, scope_attributes)
            scope_attributes.merge(tree_key(tree_class) => self.id)
          end

          def tree_key(klass)
            klass.lolita_nested_tree.scope_key_for(self.class)
          end

        end
      end
    end
  end
end
