module LolitaMenu
  class Engine < Rails::Engine

  end
end

Lolita::Hooks.component(:"/lolita/configuration/tabs/display").before do 
  javascript_include_tag "lolita/menu/application.js"
end