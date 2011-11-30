Rails.application.routes.draw do 
  lolita_for :menus
	
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
end
