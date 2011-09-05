# encoding: utf-8
class MenuItemsController < ActionController::Base
  include Lolita::Controllers::UserHelpers
  include Lolita::Controllers::InternalHelpers

  before_filter :authenticate_lolita_user!
  
  def autocomplete_menu_item_url
    urls = Lolita::Menu::Autocomplete::Collector.new(params[:term])
    render :json => urls.to_json
  end

  def create
    menu=Menu.find_by_id(params[:menu_id])
    item=MenuItem.create!(:name=>"new item",:url=>"/",:menu_id => params[:menu_id])
    menu.append(item)
    notice(I18n.t("lolita.menu.branch created"))
    render_component "lolita/menu_items", :row, :item => item, :menu => menu
  end

  def update
    if item=MenuItem.find_by_id(params[:id])
      item.send(:"#{params[:attribute]}=",params[:value])
      item.save
      render :json=>{:status=>item.errors.any? ? "error" : "saved"}
    else
      render :json=>{:status=>"error"}
    end
  end

  def update_tree
    menu=Menu.find_by_id(params[:menu_id])

    if menu && menu.update_whole_tree(params[:items])
      notice I18n.t("lolita.menu.notice")
    else
      error I18n.t("lolita.menu.error")
    end

    render :nothing=>true
  end

  def destroy
    item=MenuItem.find_by_id(params[:id])
    item.destroy
    notice I18n.t("lolita.menu.branch deleted")
    render :json=>{:id=>item.id}
  end

  def is_lolita_resource?
    true
  end 
end
