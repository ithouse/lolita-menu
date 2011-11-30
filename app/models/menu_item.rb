class MenuItem < ActiveRecord::Base
	include Lolita::Configuration
	include Lolita::Menu::NestedTree
  set_table_name "lolita_menu_items"
  
  belongs_to :menu, :class_name => "Menu"

  validates :name,:presence => true
  validates :url, :format => {:with => /^(\/)|(http).*/}, :unless=>:root?

  before_save :normalize_url
  before_validation :set_default_url, :if=>:new_record?

	lolita_nested_tree :scope => :menu

	lolita do
		tab(:default) do
			field :menu
			field :url
		end
	end

	# class methods
	
  #class << self
   # def create_root!(menu)
   #   new_item = self.create!({:menu_id => menu.id}.merge(default_root_position))
   #   menu.items << new_item
   # end
  #end
	
  # instance methods

  def active?(request,options={})
    active_item = self_and_descendants.detect{|item|
      item.url_match?(request,options[:fullpath])
    }
    
    !!active_item
  end

	def visible?
		self.is_visible
	end

  def url_match?(request,fullpath=false)
    if self.url.strip.match(/^http/)
      self.url.strip==request.url
    else
      only_path = (fullpath ? request.fullpath : request.path).gsub(/\?.*/,"")
      self.real_url(request.params) == only_path
    end
  end

  def real_url(params)
    self.url.strip.gsub(/(:\w+)\/?/) do |m|
      params_key = $1.gsub(":","").to_sym
      params.has_key?(params_key) ? "#{params[params_key]}#{m[m.size-1]=="/" ? "/" : ""}" : ""
    end
  end

  private

  def set_default_url
    self.url||="/"
  end

  def normalize_url
    self.url = self.url.to_s.strip
  end

end
