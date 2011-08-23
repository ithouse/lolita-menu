Rails.application.routes.draw do 
  lolita_for :menus
  resources :menu_items, :only=>[:create,:destroy,:update] do
    collection do
      put :update_tree
      get :autocomplete_menu_item_url
    end
  end
end