Rails.application.routes.draw do 
	
  resources :menu_items, :only => :none do
    collection do
      get :autocomplete_menu_item_url
    end
  end

	resources :nested_trees, :only => [:create, :update, :destroy] do
		collection do
			put :update_tree
		end
	end

  lolita_for :menu_items
  lolita_for :menus, :visible => false
end
