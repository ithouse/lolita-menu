# encoding: utf-8
class MenuItemsController < NestedTreesController

  before_filter :authenticate_lolita_user!
  
  def autocomplete_menu_item_url
    authorize!(:read, Menu)
    urls = Lolita::Menu::Autocomplete::Collector.new(params[:term])
    render :json => urls.to_json
  end
end
