class NestedTreesController < ApplicationController
	include Lolita::ControllerAdditions

  before_filter :authenticate_lolita_user!

	def index
		super
	end

	def create
    authorize!(:create, tree_class)
		item = tree_class.build_empty_branch(attributes.merge(scopes))
    item.save!
		item.reload
    notice(I18n.t("lolita.nested_tree.branch created", :name => tree_class.model_name.human))
		render_component "lolita/menu/nested_tree/branch_builder", :row, :item => item, :scope => scope
	end

	def update
    authorize!(:update,tree_class)
		if params[:attribute].present? && item = tree_class.find_by_id(params[:id]) 
      item.send(:"#{params[:attribute]}=",params[:value])
      item.save
      render :json=>{:status=>item.errors.any? ? "error" : "saved"}
		else
      render :json=>{:status=>"error"}
		end
	end

	def update_tree
    authorize!(:update,tree_class)
		if tree_class.update_whole_tree(params[:items], scopes)
      notice I18n.t("lolita.nested_tree.notice", :name => tree_class.model_name.human)
    else
      error I18n.t("lolita.nested_tree.error", :name => tree_class.model_name.human)
    end

    render :nothing=>true
	end

	def destroy
    authorize!(:destroy,tree_class)
		item = tree_class.find_by_id(params[:id])
		item.destroy
    notice I18n.t("lolita.nested_tree.branch deleted", :name => tree_class.model_name.human)
    render :json=>{:id=>item.id}
	end

  def lolita_mapping
    @lolita_mapping ||= Lolita.mappings[resource_class.to_s.underscore.to_sym]
  end

  def resource_name
		"nested_tree"
  end

	def resource_class
		tree_class
	end

	private

	# URL:
	# /nested_trees?tree_class=MenuItem
	def tree_class
		@tree_class ||= params[:tree_class].constantize
	end

	def scopes
		@scopes ||= tree_class.lolita_nested_tree.scope_keys.inject({}) do |result, key|
			result[key] = params[key]
			result
		end
	end

	def scope
		tree_class.lolita_nested_tree.scope_classes.first && tree_class.lolita_nested_tree.scope_classes.first.find_by_id(scopes.values.first)
	end

	def attributes
		@attributes ||= tree_class.lolita.tabs.first.fields.inject({}) do |result, field|
			result[field.name.to_sym] = params[field.name.to_sym]
			result
		end
	end
end
