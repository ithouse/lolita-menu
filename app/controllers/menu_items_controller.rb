# encoding: utf-8
class MenuItemsController < NestedTreesController

  before_action :authenticate_lolita_user!
  
  def index
    super
  end
  
  def autocomplete_menu_item_url
    authorization_proxy.authorize!(:read, Menu)
    urls = Lolita::Menu::Autocomplete::Collector.new(params[:term])
    render :json => urls.to_json
  end
end
