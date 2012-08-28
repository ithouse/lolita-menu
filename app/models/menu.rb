class Menu < ActiveRecord::Base
  
  has_many :items, :class_name => "MenuItem", :dependent => :destroy

  validates :name, :presence => true

  include Lolita::Configuration

  lolita do
    list do
      column :name
      column :system_name
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
    tab(:content) do
      field :name
      field :system_name, :on => :create
    end
  end

  class << self
    def table_name
      "lolita_menus"
    end
  end
end
