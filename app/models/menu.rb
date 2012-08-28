class Menu < ActiveRecord::Base
  
  has_many :items, :class_name => "MenuItem", :dependent => :destroy

  validates :name, :presence => true

  include Lolita::Configuration

  lolita do
    list do
      column :name
      column :system_name
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
