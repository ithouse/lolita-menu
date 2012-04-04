class MenuItem < ActiveRecord::Base
	include Lolita::Configuration
	include Lolita::Menu::NestedTree
  
  belongs_to :menu, :class_name => "Menu"

  validates :name,:presence => true
  validates :url, :format => {:with => /^(\/)|(http).*/}, :unless=>:root?

  before_save :normalize_url
  
	lolita_nested_tree :scope => :menu, :build_method => :build_new_item

	lolita do
    list do 
      action :edit do 
        title ::I18n.t("lolita.shared.edit")
        url Proc.new{|view,record| view.send(:edit_lolita_resource_path, Lolita.mappings[:menu], :id => record.id)}
      end

      action :destroy do 
        title ::I18n.t("lolita.shared.delete")
        url Proc.new{|view,record| view.send(:lolita_resource_path,Lolita.mappings[:menu],:id => record.id)}
        html :method => :delete, :confirm => ::I18n.t("lolita.list.confirm")
      end
    end
		tab(:default) do
			field :name
			field :url
		end
	end

  class << self

    def table_name
      "lolita_menu_items"
    end

    def build_new_item(attributes)
      self.new(attributes.merge(:url => "/", :name => I18n.t("lolita.menu_item.new")))
    end
  end

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

  def normalize_url
    self.url = self.url.to_s.strip
  end

end
