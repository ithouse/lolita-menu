class MenuItem < ActiveRecord::Base
  set_table_name "lolita_menu_items"
  
  attr_accessor :place
  
  belongs_to :menu, :class_name => "Menu"

  validates :name,:presence => true
  validates :url, :format => {:with => /^(\/)|(http).*/}, :unless=>:root?

  before_create :set_default_positions
  after_create :put_in_place
  before_validation :set_default_values, :if=>:new_record?

  class << self
    def create_root!(menu)
      new_item = self.create!({:menu_id => menu.id}.merge(default_root_position))
      menu.items << new_item
    end

    def default_root_position
      {
        :lft=>1,
        :rgt=>2,
        :depth=>0,
        :parent_id=>nil
      }
    end
  end
  # instance methods

  def active?(request,options={})
    active_item = self_and_all_children.detect{|item|
      item.url_match?(request,options[:fullpath])
    }
    
    !!active_item
  endg

  def url_match?(request,fullpath=false)
    
    if self.url.match(/^http/)
      self.url==request.url
    else
      only_path = (fullpath ? request.fullpath : request.path).gsub(/\?.*/,"")
      self.real_url(request.params) == only_path
    end
  end

  def real_url(params)
    self.url.gsub(/(:\w+)\/?/) do |m|
      params_key = $1.gsub(":","").to_sym
      params.has_key?(params_key) ? "#{params[params_key]}#{m[m.size-1]=="/" ? "/" : ""}" : ""
    end
  end

  def visible?
    self.is_visible
  end

  def root?
    self.parent_id.nil?
  end

  def parent
    @parent||=self.class.find_by_id(self.parent_id)
    @parent
  end

  def parent=(parent_item)
    @parent=parent_item
  end

  def children
    @children||=self.class.where("lft>:left AND rgt<:right AND depth=:depth AND menu_id=:menu",{
      :left => self.lft,:right => self.rgt,:depth => self.depth+1, :menu=>self.menu_id 
    }).order("lft asc")
    @children
  end

  def self_and_all_children
    @self_and_all_children||=self.class.where("lft>=:left AND rgt<=:right AND menu_id=:menu",{
      :left => self.lft,:right => self.rgt, :menu=>self.menu_id 
    }).order("lft asc")
    @self_and_all_children
  end

  def root
    if self.parent_id.nil?
      self
    else
      self.class.where(:menu_id=>self.menu_id,:parent_id=>nil).first
    end
  end

  def append(item)
    append_item(item)
    recalculate_positions_after(:append)
  end

  private

  def append_item(item)
    position=position_for_append
    self.class.update_all(positions_to_update_string(position),"id=#{item.id}")
  end

  def recalculate_positions_after(action)
    if action==:append
      self.class.update_all("rgt=#{self.rgt+2}","id=#{self.id}")
    end
  end

  def positions_to_update_string(positions)
    result=[]
    positions.each do |field,value|
      result<<"#{field}=#{value}"
    end
    result.join(", ")
  end

  def position_for_append
    {
      :lft => self.rgt,
      :rgt => self.rgt+1,
      :depth => self.depth+1,
      :parent_id => self.id
    }
  end

  def set_default_positions
    if am_i_new_root? || !menu_id
      set_root_position
    else
      self.place=:append
    end
  end

  def am_i_new_root?
    self.menu_id && Menu.exists?(menu_id) && !MenuItem.where(:menu_id=>menu_id).first
  end

  def set_root_position
    self.class.default_root_position.each do |method,value|
      unless self.send(method)
        self.send(:"#{method}=",value)
      end
    end
  end

  def put_in_place
    if place==:append
      self.menu.root.append(self)
    end
  end

  def set_default_values
    self.name||="root"
    self.url||="/"
  end

end
