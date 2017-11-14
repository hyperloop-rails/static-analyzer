  module Admin
    class CategoriesController < BaseController
      before_filter :find_category, :only => [:edit, :update, :destroy]

      def index
        @categories = Category.by_position
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("forem.admin.category.index") 
 link_to t('back_to_admin', :scope => "forem.admin"), forem.admin_root_path 
 link_to t("forem.admin.category.new_link"), forem.new_admin_category_path, :class => "btn btn-primary" 
 t('edit', :scope => 'forem.admin.categories') 
 t('delete', :scope => 'forem.admin.categories') 
 t('category', :scope => 'forem.admin.categories') 
 @categories.each do |category| 
 cycle("odd", "even") 
 link_to t('edit', :scope => 'forem.admin.categories'), forem.edit_admin_category_path(category), :class => "btn btn-info" 
 link_to t('delete', :scope => 'forem.admin.categories'), forem.admin_category_path(category), :method => :delete, 
        data: { :confirm => t("delete_confirm", :scope => 'forem.admin.categories') }, :class => "btn btn-danger" 
 forem_emojify(category.name) 
 end 
 link_to t('forem.admin.forum.index'), forem.admin_forums_path 

end

      end

      def new
        @category =  Category.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t('new', :scope => 'forem.admin.category') 
  simple_form_for [forem, :admin, @category] do |f| 
 f.input :name 
 f.input :position 
 f.submit :class => "btn btn-primary" 
 end 
 

end

      end

      def create
        if @category = Category.create(category_params)
          create_successful
        else
          create_failed
        end
      end

      def update
        if @category.update_attributes(category_params)
          update_successful
        else
          update_failed
        end
      end

      def destroy
        @category.destroy
        destroy_successful
      end

      private

      def category_params
        params.require(:category).permit(:name, :position)
      end

      def find_category
        @category = Category.friendly.find(params[:id])
      end

      def create_successful
        flash[:notice] = t("forem.admin.category.created")
        redirect_to admin_categories_path
      end

      def create_failed
        flash.now.alert = t("forem.admin.category.not_created")
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t('new', :scope => 'forem.admin.category') 
  simple_form_for [forem, :admin, @category] do |f| 
 f.input :name 
 f.input :position 
 f.submit :class => "btn btn-primary" 
 end 
 

end

      end

      def destroy_successful
        flash[:notice] = t("forem.admin.category.deleted")
        redirect_to admin_categories_path
      end

      def update_successful
        flash[:notice] = t("forem.admin.category.updated")
        redirect_to admin_categories_path
      end

      def update_failed
        flash.now.alert = t("forem.admin.category.not_updated")
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("forem.admin.category.edit", :title => @category.name) 
  simple_form_for [forem, :admin, @category] do |f| 
 f.input :name 
 f.input :position 
 f.submit :class => "btn btn-primary" 
 end 
 

end

      end

    end
  end
