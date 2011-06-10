class Menu < ActiveRecord::Base
  set_table_name "lolita_menus"
  
  has_many :items, :class_name => "MenuItem", :dependent => :destroy

  validates :name, :presence => true

  after_create :create_root, :unless=>:have_root?

  include Lolita::Configuration

  lolita do
    list do
      column :name
      builder :name=>"/lolita/menu",:state=>"list", :if=>{:state=>:display}
    end
    tab(:content) do
      field :name
    end
  end

  POSITION_ATTRIBUTES = {:left => :lft,:right => :rgt,:depth => :depth,:parent_id => :parent_id}
  ROOT = "root"
  NONE = "none"

  def position_attributes
    POSITION_ATTRIBUTES
  end

  def root
    if item=self.items.first
      item.root
    end
  end

  def children
    self.root.children
  end

  def append(item)
    unless item.menu_id == self.id
      item.menu_id = self.id
      item.save!
    end
    self.root.append(item)
    item.reload
    item
  end

  def have_root?
    !!self.root
  end

  def update_whole_tree(items)
    begin
      self.class.transaction do
        update_all_items(items)
        true
      end
    end
  end

  protected


  def update_all_items(items)
    items_ids=items_with_acumulated_ids(items) do |item|
      update_item(item)
    end
    remove_deleted_items(items_ids)
  end

  def items_with_acumulated_ids(items)
    item_ids=[]
    items.each do |key,item|
      item_ids << item[:item_id]
      yield item
    end
    return item_ids
  end

  def update_item(item)
    if is_root?(item)
      update_root(item)
    else
      update_branch(item)
    end
  end

  def is_root?(item)
    item[:item_id]==ROOT
  end

  def update_root(item)
    MenuItem.update_all(update_values_for(item),"id=#{root.id}")
  end

  def update_branch(item)
    MenuItem.update_all(update_values_for(item),"id=#{item[:item_id].to_i}")
  end

  def update_values_for(item)
    values=[]
    position_attributes.each do |attr_name,field|
      value = value_for_attribute(attr_name,item)
      values<<"#{field}=#{value}"
    end
    values.join(", ")
  end

  def value_for_attribute(attr_name,item)
    if item[attr_name]==NONE || !item[attr_name]
      "NULL"
    elsif item[attr_name]==ROOT
      root.id
    else
      item[attr_name].to_i
    end
  end

  def remove_deleted_items(ids)
    deleted_ids=deleted_items_ids(ids)
    if deleted_ids.any?
      MenuItem.delete_all("id IN (#{deleted_ids.join(",")})")
    end
  end

  def deleted_items_ids(ids)
    ids = ids.map{|id| id=="root" ? root.id : id.to_i}
    all_ids = MenuItem.where(:menu_id=>self.id).map{|item| item.id}
    all_ids - ids
  end

  private

  def create_root
    MenuItem.create_root!(self)
  end

end
