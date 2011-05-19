Rails.application.routes.draw do 
  lolita_for :menus
  resources :menu_items, :only=>[:create,:destroy,:update] do
    collection do
      put :update_tree
    end
  end
end