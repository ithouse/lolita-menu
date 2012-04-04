class Menu < ActiveRecord::Base
  
  has_many :items, :class_name => "MenuItem", :dependent => :destroy

  validates :name, :presence => true

  include Lolita::Configuration

  lolita do
    list do
      column :name
    end
    tab(:content) do
      field :name
    end
  end

  class << self
    def table_name
      "lolita_menus"
    end
  end
end
