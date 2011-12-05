module LolitaMenu
  class Engine < Rails::Engine

  end
end

# Lolita::Hooks.component(:"/lolita/configuration/list/display").around do
# 	list = self.component_locals[:list]
# 	page = self.component_locals[:page]
# 	self.extend(Lolita::MenuHelper)

# 	if Lolita::Menu::NestedTree.is_tree?(list.dbi.klass)
# 		self.send(:render_component, "lolita/menu/nested_tree", :display, :list => list, :page => page)
# 	else
# 		let_content
# 	end
# end
