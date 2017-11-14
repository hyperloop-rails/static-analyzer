module Shoppe
  class ProductCategoriesController < Shoppe::ApplicationController
    before_filter { @active_nav = :product_categories }
    before_filter { params[:id] && @product_category = Shoppe::ProductCategory.find(params[:id]) }

    def index
      @product_categories_without_parent = Shoppe::ProductCategory.without_parent.ordered
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag 'shoppe/application' 
 javascript_include_tag 'shoppe/application' 
 csrf_meta_tags 
 link_to "Shoppe", root_path 
 t('.logged_in_as', user_name: current_user.full_name) 
 for item in Shoppe::NavigationManager.find(:admin_primary).items 
 navigation_manager_link item 
 end 
 link_to t('.logout'), [:logout], :method => :delete 
 link_to t('shoppe.product_category.new_category'), :new_product_category, :class => 'button green' 
 t('shoppe.product_category.product_categories') 
 display_flash 
 @page_title = t('shoppe.product_category.product_categories') 
  
 t('shoppe.product_category.name') 
 unless @product_categories_without_parent.empty? 
 I18n.available_locales.each do |i| 
 end 
 end 
 if @product_categories_without_parent.empty? 
 t('shoppe.product_category.no_categories') 
 else 
 for cat in @product_categories_without_parent 
 link_to cat.name, [:edit, cat] 
 I18n.available_locales.each do |i| 
 if cat.translations.where(locale: i).count >= 1 
 link_to i, edit_product_category_localisation_path(cat, cat.translations.where(locale: i).first.id) 
 else 
 link_to i, new_product_category_localisation_path(cat, locale_field: i) 
 end 
 end 
 nested_product_category_rows(cat) 
 end 
 end 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def new
      @product_category = Shoppe::ProductCategory.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag 'shoppe/application' 
 javascript_include_tag 'shoppe/application' 
 csrf_meta_tags 
 link_to "Shoppe", root_path 
 t('.logged_in_as', user_name: current_user.full_name) 
 for item in Shoppe::NavigationManager.find(:admin_primary).items 
 navigation_manager_link item 
 end 
 link_to t('.logout'), [:logout], :method => :delete 
 link_to t('shoppe.product_category.back_to_categories'), :product_categories, :class => 'button' 
 t('shoppe.product_category.product_categories') 
 display_flash 
 @page_title = t('shoppe.product_category.product_categories') 
  
  form_for @product_category do |f| 
 f.error_messages 
 field_set_tag t('shoppe.product_category.category_details') do 
 f.label :name, t('shoppe.product_category.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :permalink, t('shoppe.product_category.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.check_box :permalink_includes_ancestors 
 f.label :permalink_includes_ancestors, t('shoppe.product_category.permalink_includes_ancestors') 
 f.label :description, t('shoppe.product_category.description') 
 f.text_area :description, :class => 'text' 
 end 
 field_set_tag t('shoppe.product_category.nesting.category_nesting') do 
 f.label :parent_id, t('shoppe.product_category.nesting.category_parent') 
 f.collection_select :parent_id, Shoppe::ProductCategory.except_descendants(@product_category).ordered, :id, :name, {:include_blank => t('shoppe.product_category.nesting.blank_option')}, {:class => 'chosen'} 
 f.label :child_ids, t('shoppe.product_category.nesting.hierarchy') 
 if @product_category.children.count == 0 
 t('shoppe.product_category.nesting.no_children') 
 else 
 "#{@product_category.name} (#{t('shoppe.product_category.nesting.current_category')})" 
 nested_product_category_rows(@product_category, current_category = @product_category, link_to_current = false, relative_depth = @product_category.depth) 
 end 
 end 
 field_set_tag t('shoppe.product_category.attachments') do 
 f.label "attachments[image][file]", t('shoppe.product_category.image') 
 attachment_preview @product_category.image 
 f.file_field "attachments[image][file]" 
 f.hidden_field "attachments[image][role]", value: "image" 
 f.hidden_field "attachments[image][parent_id]", value: @product_category.id 
 end 
 unless @product_category.new_record? 
 link_to t('shoppe.delete') , @product_category, :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.product_category.delete_confirmation') } 
 end 
 f.submit t('shoppe.submit'),  :class => 'button green' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def create
      @product_category = Shoppe::ProductCategory.new(safe_params)
      if @product_category.save
        redirect_to :product_categories, flash: { notice: t('shoppe.product_category.create_notice') }
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag 'shoppe/application' 
 javascript_include_tag 'shoppe/application' 
 csrf_meta_tags 
 link_to "Shoppe", root_path 
 t('.logged_in_as', user_name: current_user.full_name) 
 for item in Shoppe::NavigationManager.find(:admin_primary).items 
 navigation_manager_link item 
 end 
 link_to t('.logout'), [:logout], :method => :delete 
 link_to t('shoppe.product_category.back_to_categories'), :product_categories, :class => 'button' 
 t('shoppe.product_category.product_categories') 
 display_flash 
 @page_title = t('shoppe.product_category.product_categories') 
  
  form_for @product_category do |f| 
 f.error_messages 
 field_set_tag t('shoppe.product_category.category_details') do 
 f.label :name, t('shoppe.product_category.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :permalink, t('shoppe.product_category.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.check_box :permalink_includes_ancestors 
 f.label :permalink_includes_ancestors, t('shoppe.product_category.permalink_includes_ancestors') 
 f.label :description, t('shoppe.product_category.description') 
 f.text_area :description, :class => 'text' 
 end 
 field_set_tag t('shoppe.product_category.nesting.category_nesting') do 
 f.label :parent_id, t('shoppe.product_category.nesting.category_parent') 
 f.collection_select :parent_id, Shoppe::ProductCategory.except_descendants(@product_category).ordered, :id, :name, {:include_blank => t('shoppe.product_category.nesting.blank_option')}, {:class => 'chosen'} 
 f.label :child_ids, t('shoppe.product_category.nesting.hierarchy') 
 if @product_category.children.count == 0 
 t('shoppe.product_category.nesting.no_children') 
 else 
 "#{@product_category.name} (#{t('shoppe.product_category.nesting.current_category')})" 
 nested_product_category_rows(@product_category, current_category = @product_category, link_to_current = false, relative_depth = @product_category.depth) 
 end 
 end 
 field_set_tag t('shoppe.product_category.attachments') do 
 f.label "attachments[image][file]", t('shoppe.product_category.image') 
 attachment_preview @product_category.image 
 f.file_field "attachments[image][file]" 
 f.hidden_field "attachments[image][role]", value: "image" 
 f.hidden_field "attachments[image][parent_id]", value: @product_category.id 
 end 
 unless @product_category.new_record? 
 link_to t('shoppe.delete') , @product_category, :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.product_category.delete_confirmation') } 
 end 
 f.submit t('shoppe.submit'),  :class => 'button green' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
    end

    def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag 'shoppe/application' 
 javascript_include_tag 'shoppe/application' 
 csrf_meta_tags 
 link_to "Shoppe", root_path 
 t('.logged_in_as', user_name: current_user.full_name) 
 for item in Shoppe::NavigationManager.find(:admin_primary).items 
 navigation_manager_link item 
 end 
 link_to t('.logout'), [:logout], :method => :delete 
 link_to t('shoppe.localisations.localisations') , [@product_category, :localisations], :class => 'button' 
 link_to t('shoppe.product_category.back_to_categories'), :product_categories, :class => 'button' 
 t('shoppe.product_category.product_categories') 
 display_flash 
 @page_title = t('shoppe.product_category.product_categories') 
  
  form_for @product_category do |f| 
 f.error_messages 
 field_set_tag t('shoppe.product_category.category_details') do 
 f.label :name, t('shoppe.product_category.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :permalink, t('shoppe.product_category.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.check_box :permalink_includes_ancestors 
 f.label :permalink_includes_ancestors, t('shoppe.product_category.permalink_includes_ancestors') 
 f.label :description, t('shoppe.product_category.description') 
 f.text_area :description, :class => 'text' 
 end 
 field_set_tag t('shoppe.product_category.nesting.category_nesting') do 
 f.label :parent_id, t('shoppe.product_category.nesting.category_parent') 
 f.collection_select :parent_id, Shoppe::ProductCategory.except_descendants(@product_category).ordered, :id, :name, {:include_blank => t('shoppe.product_category.nesting.blank_option')}, {:class => 'chosen'} 
 f.label :child_ids, t('shoppe.product_category.nesting.hierarchy') 
 if @product_category.children.count == 0 
 t('shoppe.product_category.nesting.no_children') 
 else 
 "#{@product_category.name} (#{t('shoppe.product_category.nesting.current_category')})" 
 nested_product_category_rows(@product_category, current_category = @product_category, link_to_current = false, relative_depth = @product_category.depth) 
 end 
 end 
 field_set_tag t('shoppe.product_category.attachments') do 
 f.label "attachments[image][file]", t('shoppe.product_category.image') 
 attachment_preview @product_category.image 
 f.file_field "attachments[image][file]" 
 f.hidden_field "attachments[image][role]", value: "image" 
 f.hidden_field "attachments[image][parent_id]", value: @product_category.id 
 end 
 unless @product_category.new_record? 
 link_to t('shoppe.delete') , @product_category, :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.product_category.delete_confirmation') } 
 end 
 f.submit t('shoppe.submit'),  :class => 'button green' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def update
      if @product_category.update(safe_params)
        redirect_to [:edit, @product_category], flash: { notice: t('shoppe.product_category.update_notice') }
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag 'shoppe/application' 
 javascript_include_tag 'shoppe/application' 
 csrf_meta_tags 
 link_to "Shoppe", root_path 
 t('.logged_in_as', user_name: current_user.full_name) 
 for item in Shoppe::NavigationManager.find(:admin_primary).items 
 navigation_manager_link item 
 end 
 link_to t('.logout'), [:logout], :method => :delete 
 link_to t('shoppe.localisations.localisations') , [@product_category, :localisations], :class => 'button' 
 link_to t('shoppe.product_category.back_to_categories'), :product_categories, :class => 'button' 
 t('shoppe.product_category.product_categories') 
 display_flash 
 @page_title = t('shoppe.product_category.product_categories') 
  
  form_for @product_category do |f| 
 f.error_messages 
 field_set_tag t('shoppe.product_category.category_details') do 
 f.label :name, t('shoppe.product_category.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :permalink, t('shoppe.product_category.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.check_box :permalink_includes_ancestors 
 f.label :permalink_includes_ancestors, t('shoppe.product_category.permalink_includes_ancestors') 
 f.label :description, t('shoppe.product_category.description') 
 f.text_area :description, :class => 'text' 
 end 
 field_set_tag t('shoppe.product_category.nesting.category_nesting') do 
 f.label :parent_id, t('shoppe.product_category.nesting.category_parent') 
 f.collection_select :parent_id, Shoppe::ProductCategory.except_descendants(@product_category).ordered, :id, :name, {:include_blank => t('shoppe.product_category.nesting.blank_option')}, {:class => 'chosen'} 
 f.label :child_ids, t('shoppe.product_category.nesting.hierarchy') 
 if @product_category.children.count == 0 
 t('shoppe.product_category.nesting.no_children') 
 else 
 "#{@product_category.name} (#{t('shoppe.product_category.nesting.current_category')})" 
 nested_product_category_rows(@product_category, current_category = @product_category, link_to_current = false, relative_depth = @product_category.depth) 
 end 
 end 
 field_set_tag t('shoppe.product_category.attachments') do 
 f.label "attachments[image][file]", t('shoppe.product_category.image') 
 attachment_preview @product_category.image 
 f.file_field "attachments[image][file]" 
 f.hidden_field "attachments[image][role]", value: "image" 
 f.hidden_field "attachments[image][parent_id]", value: @product_category.id 
 end 
 unless @product_category.new_record? 
 link_to t('shoppe.delete') , @product_category, :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.product_category.delete_confirmation') } 
 end 
 f.submit t('shoppe.submit'),  :class => 'button green' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
    end

    def destroy
      @product_category.destroy
      redirect_to :product_categories, flash: { notice: t('shoppe.product_category.destroy_notice') }
    end

    private

    def safe_params
      file_params = [:file, :parent_id, :role, :parent_type, file: []]
      params[:product_category].permit(:name, :permalink, :description, :parent_id, :permalink_includes_ancestors, attachments: [image: file_params])
    end
  end
end
