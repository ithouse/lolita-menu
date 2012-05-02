class Category < ActiveRecord::Base
  include Lolita::Configuration
	include Lolita::Menu::NestedTree

	belongs_to :shop

	lolita_nested_tree
end
