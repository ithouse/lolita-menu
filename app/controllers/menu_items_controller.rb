# encoding: utf-8
class MenuItemsController < ActionController::Base
  include Lolita::Controllers::UserHelpers

  before_filter :authenticate_lolita_user!

  def create
    menu=Menu.find_by_id(params[:menu_id])
    item=MenuItem.create!(:name=>"new item",:url=>"/",:menu_id=>params[:menu_id])
    menu.append(item)
    render :partial=>"row", :locals=>{:item=>item}
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
      response.headers["Lolita-Notice"] = I18n.t("lolita.menu.notice")
    else
      response.headers["Lolita-Error"] = I18n.t("lolita.menu.error")
    end

    render :nothing=>true
  end

  def destroy
    item=MenuItem.find_by_id(params[:id])
    item.destroy
    render :json=>{:id=>item.id}
  end
end
