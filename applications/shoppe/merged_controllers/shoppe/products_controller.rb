module Shoppe
  class ProductsController < Shoppe::ApplicationController
    before_filter { @active_nav = :products }
    before_filter { params[:id] && @product = Shoppe::Product.root.find(params[:id]) }

    def index
      @products_paged = Shoppe::Product.root
                                       .includes(:translations, :stock_level_adjustments, :product_categories, :variants)
                                       .order(:name)
      case
      when params[:sku]
        @products_paged = @products_paged
                          .with_translations(I18n.locale)
                          .page(params[:page])
                          .ransack(sku_cont_all: params[:sku].split).result
      when params[:name]
        @products_paged = @products_paged
                          .with_translations(I18n.locale)
                          .page(params[:page])
                          .ransack(translations_name_or_translations_description_cont_all: params[:name].split)
                          .result
      else
        @products_paged = @products_paged.page(params[:page])
      end

      @products = @products_paged
                  .group_by(&:product_category)
                  .sort_by { |cat, _pro| cat.name }
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
 link_to t('shoppe.products.new_product'), :new_product, :class => 'button green' 
 link_to t('shoppe.products.import_products'), :import_products, :class => 'button gray' 
 t('shoppe.products.products') 
 display_flash 
 @page_title = t('shoppe.products.products') 
  
  form_tag(:products, method: "get") do 
 t('shoppe.products.sku') 
 search_field_tag :sku, params[:sku], size: 25, min: 2, placeholder: t('shoppe.products.filter.sku') 
 end 
 form_tag(:products, method: "get") do 
 t('shoppe.products.name') 
 search_field_tag :name, params[:name], size: 65, min: 3, placeholder: t('shoppe.products.filter.name_or_description') 
 end 
 t('shoppe.products.price_variants') 
 t('shoppe.products.stock') 
 if products.empty? 
 t('shoppe.products.no_products') 
 else 
 for category, products in products 
 category.name 
 for product in products 
 product.sku 
 link_to product.name, [:edit, product] 
 if product.has_variants? 
 for variant in product.variants 
 link_to variant.name, edit_product_variant_path(product, variant) 
 number_to_currency variant.price 
 if variant.stock_control? 
 link_to t('shoppe.products.edit') , stock_level_adjustments_path(:item_type => variant.class, :item_id => variant.id), :class => 'edit', :rel => 'dialog', :data => {:dialog_width => 700, :dialog_behavior => 'stockLevelAdjustments'} 
 boolean_tag(variant.in_stock?, nil, :true_text => variant.stock, :false_text => t('shoppe.products.no_stock')) 
 else 
 end 
 end 
 else 
 number_to_currency product.price 
 if product.stock_control? 
 link_to t('shoppe.products.edit'), stock_level_adjustments_path(:item_type => product.class, :item_id => product.id), :class => 'edit', :rel => 'dialog', :data => {:dialog_width => 700, :dialog_behavior => 'stockLevelAdjustments'} 
 boolean_tag(product.in_stock?, nil, :true_text => product.stock, :false_text => t('shoppe.products.no_stock')) 
 else 
 end 
 end 
 end 
 end 
 end 
 
 paginate @products_paged 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def new
      @product = Shoppe::Product.new
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
 link_to t('shoppe.products.back_to_products') , :products, :class => 'button' 
 t('shoppe.products.products') 
 display_flash 
 @page_title = t('shoppe.products.products') 
  
  form_for @product, :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag  t('shoppe.products.product_information') do 
 f.label :product_categories, t('shoppe.product_category.product_categories') 
 f.collection_select :product_category_ids, Shoppe::ProductCategory.ordered, :id, :name
 f.label :name, t('shoppe.products.name') 
 f.text_field :name, :class => 'text focus' 
 f.label :permalink, t('shoppe.products.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :sku, t('shoppe.products.sku') 
 f.text_field :sku, :class => 'text' 
 f.label :description, t('shoppe.products.description') 
 f.text_area :description, :class => 'text' 
 f.label :short_description, t('shoppe.products.short_description') 
 f.text_area :short_description, :class => 'text' 
 f.label :in_the_box, t('shoppe.products.in_the_box') 
 f.text_area :in_the_box, :class => 'text' 
 end 
 field_set_tag t('shoppe.products.attributes') do 
 t('shoppe.products.name') 
 t('shoppe.products.value') 
 t('shoppe.products.searchable?') 
 t('shoppe.products.public?') 
 t('shoppe.products.remove') 
 text_field_tag 'product[product_attributes_array][][key]', '', :placeholder => t('shoppe.products.name') 
 text_field_tag 'product[product_attributes_array][][value]', '', :placeholder => t('shoppe.products.value') 
 check_box_tag 'product[product_attributes_array][][searchable]', '1' 
 check_box_tag 'product[product_attributes_array][][public]', '1' 
 link_to t('shoppe.remove') , '#', :class => 'button button-mini purple' 
 for attribute in @product.product_attributes 
 text_field_tag 'product[product_attributes_array][][key]', attribute.key, :placeholder => t('shoppe.products.name') 
 text_field_tag 'product[product_attributes_array][][value]', attribute.value, :placeholder => t('shoppe.products.value') 
 check_box_tag 'product[product_attributes_array][][searchable]', '1', attribute.searchable? 
 check_box_tag 'product[product_attributes_array][][public]', '1', attribute.public? 
 link_to t("shoppe.remove"), '#', :class => 'button button-mini purple' 
 end 
 link_to t('shoppe.products.add_attribute') , '#', :data => {:behavior => 'addAttributeToAttributesTable'}, :class => 'button button-mini green' 
 end 
 field_set_tag t('shoppe.products.attachments') do 
 f.label "attachments[default_image][file]", t('shoppe.products.default_image') 
 attachment_preview @product.default_image 
 f.file_field "attachments[default_image][file]" 
 f.hidden_field "attachments[default_image][role]", value: "default_image" 
 f.hidden_field "attachments[default_image][parent_id]", value: @product.id 
 f.label "attachments[data_sheet][file]", t('shoppe.products.datasheet') 
 attachment_preview @product.data_sheet 
 f.file_field "attachments[data_sheet][file]" 
 f.hidden_field "attachments[data_sheet][role]", value: "data_sheet" 
 f.hidden_field "attachments[data_sheet][parent_id]", value: @product.id 
 attachment_preview nil, hide_if_blank: false 
 f.file_field "attachments[extra][file]", :multiple => true 
 f.hidden_field "attachments[extra][parent_type]", value: "Shoppe::Product" 
 f.hidden_field "attachments[extra][parent_id]", value: @product.id 
 @product.attachments.each do |attachment| 
 unless ["default_image", "data_sheet"].include?(attachment.role) 
 attachment_preview attachment 
 end 
 end 
 link_to t('shoppe.products.add_attachments') , '#', :data => {:behavior => 'addAttachmentToExtraAttachments'}, :class => 'button button-mini green' 
 end 
 unless @product.has_variants? 
 field_set_tag t('shoppe.products.pricing') do 
 f.label :price, t('shoppe.products.price') 
 Shoppe.settings.currency_unit.html_safe 
 f.text_field :price, :class => 'text' 
 f.label :cost_price, t('shoppe.products.cost_price') 
 Shoppe.settings.currency_unit.html_safe 
 f.text_field :cost_price, :class => 'text' 
 f.label :tax_rate_id, t('shoppe.products.tax_rate') 
 f.collection_select :tax_rate_id, Shoppe::TaxRate.ordered, :id, :description, t('shoppe.products.stock_control') do 
 f.label :weight, t('shoppe.products.weight') 
 f.text_field :weight, :class => 'text' 
 f.label :stock_control,  t('shoppe.products.stock_control') 
 f.check_box :stock_control 
 f.label :stock_control, t('shoppe.products.enable_stock_control?') 
 end 
 end 
 field_set_tag  t('shoppe.products.website_properties') do 
 f.label :active,  t('shoppe.products.on_sale?') 
 f.check_box :active 
 f.label :active,  t('shoppe.products.on_sale_info') 
 f.label :featured,  t('shoppe.products.featured?') 
 f.check_box :featured 
 f.label :featured, t('shoppe.products.featured_info') 
 end 
 unless @product.new_record? 
 link_to t('shoppe.delete') , @product, :class => 'button purple', :method => :delete, :data => {:confirm => "Are you sure you wish to remove this product?"} 
 end 
 f.submit t('shoppe.submit'),  :class => 'button green' 
 link_to t('shoppe.cancel'), :products, :class => 'button' 
 end 
end
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def create
      @product = Shoppe::Product.new(safe_params)
      if @product.save
        redirect_to :products, flash: { notice: t('shoppe.products.create_notice') }
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
 link_to t('shoppe.products.back_to_products') , :products, :class => 'button' 
 t('shoppe.products.products') 
 display_flash 
 @page_title = t('shoppe.products.products') 
  
  form_for @product, :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag  t('shoppe.products.product_information') do 
 f.label :product_categories, t('shoppe.product_category.product_categories') 
 f.collection_select :product_category_ids, Shoppe::ProductCategory.ordered, :id, :name
 f.label :name, t('shoppe.products.name') 
 f.text_field :name, :class => 'text focus' 
 f.label :permalink, t('shoppe.products.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :sku, t('shoppe.products.sku') 
 f.text_field :sku, :class => 'text' 
 f.label :description, t('shoppe.products.description') 
 f.text_area :description, :class => 'text' 
 f.label :short_description, t('shoppe.products.short_description') 
 f.text_area :short_description, :class => 'text' 
 f.label :in_the_box, t('shoppe.products.in_the_box') 
 f.text_area :in_the_box, :class => 'text' 
 end 
 field_set_tag t('shoppe.products.attributes') do 
 t('shoppe.products.name') 
 t('shoppe.products.value') 
 t('shoppe.products.searchable?') 
 t('shoppe.products.public?') 
 t('shoppe.products.remove') 
 text_field_tag 'product[product_attributes_array][][key]', '', :placeholder => t('shoppe.products.name') 
 text_field_tag 'product[product_attributes_array][][value]', '', :placeholder => t('shoppe.products.value') 
 check_box_tag 'product[product_attributes_array][][searchable]', '1' 
 check_box_tag 'product[product_attributes_array][][public]', '1' 
 link_to t('shoppe.remove') , '#', :class => 'button button-mini purple' 
 for attribute in @product.product_attributes 
 text_field_tag 'product[product_attributes_array][][key]', attribute.key, :placeholder => t('shoppe.products.name') 
 text_field_tag 'product[product_attributes_array][][value]', attribute.value, :placeholder => t('shoppe.products.value') 
 check_box_tag 'product[product_attributes_array][][searchable]', '1', attribute.searchable? 
 check_box_tag 'product[product_attributes_array][][public]', '1', attribute.public? 
 link_to t("shoppe.remove"), '#', :class => 'button button-mini purple' 
 end 
 link_to t('shoppe.products.add_attribute') , '#', :data => {:behavior => 'addAttributeToAttributesTable'}, :class => 'button button-mini green' 
 end 
 field_set_tag t('shoppe.products.attachments') do 
 f.label "attachments[default_image][file]", t('shoppe.products.default_image') 
 attachment_preview @product.default_image 
 f.file_field "attachments[default_image][file]" 
 f.hidden_field "attachments[default_image][role]", value: "default_image" 
 f.hidden_field "attachments[default_image][parent_id]", value: @product.id 
 f.label "attachments[data_sheet][file]", t('shoppe.products.datasheet') 
 attachment_preview @product.data_sheet 
 f.file_field "attachments[data_sheet][file]" 
 f.hidden_field "attachments[data_sheet][role]", value: "data_sheet" 
 f.hidden_field "attachments[data_sheet][parent_id]", value: @product.id 
 attachment_preview nil, hide_if_blank: false 
 f.file_field "attachments[extra][file]", :multiple => true 
 f.hidden_field "attachments[extra][parent_type]", value: "Shoppe::Product" 
 f.hidden_field "attachments[extra][parent_id]", value: @product.id 
 @product.attachments.each do |attachment| 
 unless ["default_image", "data_sheet"].include?(attachment.role) 
 attachment_preview attachment 
 end 
 end 
 link_to t('shoppe.products.add_attachments') , '#', :data => {:behavior => 'addAttachmentToExtraAttachments'}, :class => 'button button-mini green' 
 end 
 unless @product.has_variants? 
 field_set_tag t('shoppe.products.pricing') do 
 f.label :price, t('shoppe.products.price') 
 Shoppe.settings.currency_unit.html_safe 
 f.text_field :price, :class => 'text' 
 f.label :cost_price, t('shoppe.products.cost_price') 
 Shoppe.settings.currency_unit.html_safe 
 f.text_field :cost_price, :class => 'text' 
 f.label :tax_rate_id, t('shoppe.products.tax_rate') 
 f.collection_select :tax_rate_id, Shoppe::TaxRate.ordered, :id, :description, t('shoppe.products.stock_control') do 
 f.label :weight, t('shoppe.products.weight') 
 f.text_field :weight, :class => 'text' 
 f.label :stock_control,  t('shoppe.products.stock_control') 
 f.check_box :stock_control 
 f.label :stock_control, t('shoppe.products.enable_stock_control?') 
 end 
 end 
 field_set_tag  t('shoppe.products.website_properties') do 
 f.label :active,  t('shoppe.products.on_sale?') 
 f.check_box :active 
 f.label :active,  t('shoppe.products.on_sale_info') 
 f.label :featured,  t('shoppe.products.featured?') 
 f.check_box :featured 
 f.label :featured, t('shoppe.products.featured_info') 
 end 
 unless @product.new_record? 
 link_to t('shoppe.delete') , @product, :class => 'button purple', :method => :delete, :data => {:confirm => "Are you sure you wish to remove this product?"} 
 end 
 f.submit t('shoppe.submit'),  :class => 'button green' 
 link_to t('shoppe.cancel'), :products, :class => 'button' 
 end 
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
 link_to t('shoppe.localisations.localisations') , [@product, :localisations], :class => 'button' 
 link_to t('shoppe.products.variants') , [@product, :variants], :class => 'button' 
 link_to t('shoppe.products.stock_levels') , stock_level_adjustments_path(:item_id => @product.id, :item_type => @product.class), :class => 'button', :rel => 'dialog', :data => {:dialog_width => 700, :dialog_behavior => 'stockLevelAdjustments'} 
 link_to t('shoppe.products.back_to_products') , :products, :class => 'button' 
 t('shoppe.products.products') 
 display_flash 
 @page_title = t('shoppe.products.products') 
  
  form_for @product, :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag  t('shoppe.products.product_information') do 
 f.label :product_categories, t('shoppe.product_category.product_categories') 
 f.collection_select :product_category_ids, Shoppe::ProductCategory.ordered, :id, :name
 f.label :name, t('shoppe.products.name') 
 f.text_field :name, :class => 'text focus' 
 f.label :permalink, t('shoppe.products.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :sku, t('shoppe.products.sku') 
 f.text_field :sku, :class => 'text' 
 f.label :description, t('shoppe.products.description') 
 f.text_area :description, :class => 'text' 
 f.label :short_description, t('shoppe.products.short_description') 
 f.text_area :short_description, :class => 'text' 
 f.label :in_the_box, t('shoppe.products.in_the_box') 
 f.text_area :in_the_box, :class => 'text' 
 end 
 field_set_tag t('shoppe.products.attributes') do 
 t('shoppe.products.name') 
 t('shoppe.products.value') 
 t('shoppe.products.searchable?') 
 t('shoppe.products.public?') 
 t('shoppe.products.remove') 
 text_field_tag 'product[product_attributes_array][][key]', '', :placeholder => t('shoppe.products.name') 
 text_field_tag 'product[product_attributes_array][][value]', '', :placeholder => t('shoppe.products.value') 
 check_box_tag 'product[product_attributes_array][][searchable]', '1' 
 check_box_tag 'product[product_attributes_array][][public]', '1' 
 link_to t('shoppe.remove') , '#', :class => 'button button-mini purple' 
 for attribute in @product.product_attributes 
 text_field_tag 'product[product_attributes_array][][key]', attribute.key, :placeholder => t('shoppe.products.name') 
 text_field_tag 'product[product_attributes_array][][value]', attribute.value, :placeholder => t('shoppe.products.value') 
 check_box_tag 'product[product_attributes_array][][searchable]', '1', attribute.searchable? 
 check_box_tag 'product[product_attributes_array][][public]', '1', attribute.public? 
 link_to t("shoppe.remove"), '#', :class => 'button button-mini purple' 
 end 
 link_to t('shoppe.products.add_attribute') , '#', :data => {:behavior => 'addAttributeToAttributesTable'}, :class => 'button button-mini green' 
 end 
 field_set_tag t('shoppe.products.attachments') do 
 f.label "attachments[default_image][file]", t('shoppe.products.default_image') 
 attachment_preview @product.default_image 
 f.file_field "attachments[default_image][file]" 
 f.hidden_field "attachments[default_image][role]", value: "default_image" 
 f.hidden_field "attachments[default_image][parent_id]", value: @product.id 
 f.label "attachments[data_sheet][file]", t('shoppe.products.datasheet') 
 attachment_preview @product.data_sheet 
 f.file_field "attachments[data_sheet][file]" 
 f.hidden_field "attachments[data_sheet][role]", value: "data_sheet" 
 f.hidden_field "attachments[data_sheet][parent_id]", value: @product.id 
 attachment_preview nil, hide_if_blank: false 
 f.file_field "attachments[extra][file]", :multiple => true 
 f.hidden_field "attachments[extra][parent_type]", value: "Shoppe::Product" 
 f.hidden_field "attachments[extra][parent_id]", value: @product.id 
 @product.attachments.each do |attachment| 
 unless ["default_image", "data_sheet"].include?(attachment.role) 
 attachment_preview attachment 
 end 
 end 
 link_to t('shoppe.products.add_attachments') , '#', :data => {:behavior => 'addAttachmentToExtraAttachments'}, :class => 'button button-mini green' 
 end 
 unless @product.has_variants? 
 field_set_tag t('shoppe.products.pricing') do 
 f.label :price, t('shoppe.products.price') 
 Shoppe.settings.currency_unit.html_safe 
 f.text_field :price, :class => 'text' 
 f.label :cost_price, t('shoppe.products.cost_price') 
 Shoppe.settings.currency_unit.html_safe 
 f.text_field :cost_price, :class => 'text' 
 f.label :tax_rate_id, t('shoppe.products.tax_rate') 
 f.collection_select :tax_rate_id, Shoppe::TaxRate.ordered, :id, :description, t('shoppe.products.stock_control') do 
 f.label :weight, t('shoppe.products.weight') 
 f.text_field :weight, :class => 'text' 
 f.label :stock_control,  t('shoppe.products.stock_control') 
 f.check_box :stock_control 
 f.label :stock_control, t('shoppe.products.enable_stock_control?') 
 end 
 end 
 field_set_tag  t('shoppe.products.website_properties') do 
 f.label :active,  t('shoppe.products.on_sale?') 
 f.check_box :active 
 f.label :active,  t('shoppe.products.on_sale_info') 
 f.label :featured,  t('shoppe.products.featured?') 
 f.check_box :featured 
 f.label :featured, t('shoppe.products.featured_info') 
 end 
 unless @product.new_record? 
 link_to t('shoppe.delete') , @product, :class => 'button purple', :method => :delete, :data => {:confirm => "Are you sure you wish to remove this product?"} 
 end 
 f.submit t('shoppe.submit'),  :class => 'button green' 
 link_to t('shoppe.cancel'), :products, :class => 'button' 
 end 
end
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def update
      if @product.update(safe_params)
        redirect_to [:edit, @product], flash: { notice: t('shoppe.products.update_notice') }
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
 link_to t('shoppe.localisations.localisations') , [@product, :localisations], :class => 'button' 
 link_to t('shoppe.products.variants') , [@product, :variants], :class => 'button' 
 link_to t('shoppe.products.stock_levels') , stock_level_adjustments_path(:item_id => @product.id, :item_type => @product.class), :class => 'button', :rel => 'dialog', :data => {:dialog_width => 700, :dialog_behavior => 'stockLevelAdjustments'} 
 link_to t('shoppe.products.back_to_products') , :products, :class => 'button' 
 t('shoppe.products.products') 
 display_flash 
 @page_title = t('shoppe.products.products') 
  
  form_for @product, :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag  t('shoppe.products.product_information') do 
 f.label :product_categories, t('shoppe.product_category.product_categories') 
 f.collection_select :product_category_ids, Shoppe::ProductCategory.ordered, :id, :name
 f.label :name, t('shoppe.products.name') 
 f.text_field :name, :class => 'text focus' 
 f.label :permalink, t('shoppe.products.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :sku, t('shoppe.products.sku') 
 f.text_field :sku, :class => 'text' 
 f.label :description, t('shoppe.products.description') 
 f.text_area :description, :class => 'text' 
 f.label :short_description, t('shoppe.products.short_description') 
 f.text_area :short_description, :class => 'text' 
 f.label :in_the_box, t('shoppe.products.in_the_box') 
 f.text_area :in_the_box, :class => 'text' 
 end 
 field_set_tag t('shoppe.products.attributes') do 
 t('shoppe.products.name') 
 t('shoppe.products.value') 
 t('shoppe.products.searchable?') 
 t('shoppe.products.public?') 
 t('shoppe.products.remove') 
 text_field_tag 'product[product_attributes_array][][key]', '', :placeholder => t('shoppe.products.name') 
 text_field_tag 'product[product_attributes_array][][value]', '', :placeholder => t('shoppe.products.value') 
 check_box_tag 'product[product_attributes_array][][searchable]', '1' 
 check_box_tag 'product[product_attributes_array][][public]', '1' 
 link_to t('shoppe.remove') , '#', :class => 'button button-mini purple' 
 for attribute in @product.product_attributes 
 text_field_tag 'product[product_attributes_array][][key]', attribute.key, :placeholder => t('shoppe.products.name') 
 text_field_tag 'product[product_attributes_array][][value]', attribute.value, :placeholder => t('shoppe.products.value') 
 check_box_tag 'product[product_attributes_array][][searchable]', '1', attribute.searchable? 
 check_box_tag 'product[product_attributes_array][][public]', '1', attribute.public? 
 link_to t("shoppe.remove"), '#', :class => 'button button-mini purple' 
 end 
 link_to t('shoppe.products.add_attribute') , '#', :data => {:behavior => 'addAttributeToAttributesTable'}, :class => 'button button-mini green' 
 end 
 field_set_tag t('shoppe.products.attachments') do 
 f.label "attachments[default_image][file]", t('shoppe.products.default_image') 
 attachment_preview @product.default_image 
 f.file_field "attachments[default_image][file]" 
 f.hidden_field "attachments[default_image][role]", value: "default_image" 
 f.hidden_field "attachments[default_image][parent_id]", value: @product.id 
 f.label "attachments[data_sheet][file]", t('shoppe.products.datasheet') 
 attachment_preview @product.data_sheet 
 f.file_field "attachments[data_sheet][file]" 
 f.hidden_field "attachments[data_sheet][role]", value: "data_sheet" 
 f.hidden_field "attachments[data_sheet][parent_id]", value: @product.id 
 attachment_preview nil, hide_if_blank: false 
 f.file_field "attachments[extra][file]", :multiple => true 
 f.hidden_field "attachments[extra][parent_type]", value: "Shoppe::Product" 
 f.hidden_field "attachments[extra][parent_id]", value: @product.id 
 @product.attachments.each do |attachment| 
 unless ["default_image", "data_sheet"].include?(attachment.role) 
 attachment_preview attachment 
 end 
 end 
 link_to t('shoppe.products.add_attachments') , '#', :data => {:behavior => 'addAttachmentToExtraAttachments'}, :class => 'button button-mini green' 
 end 
 unless @product.has_variants? 
 field_set_tag t('shoppe.products.pricing') do 
 f.label :price, t('shoppe.products.price') 
 Shoppe.settings.currency_unit.html_safe 
 f.text_field :price, :class => 'text' 
 f.label :cost_price, t('shoppe.products.cost_price') 
 Shoppe.settings.currency_unit.html_safe 
 f.text_field :cost_price, :class => 'text' 
 f.label :tax_rate_id, t('shoppe.products.tax_rate') 
 f.collection_select :tax_rate_id, Shoppe::TaxRate.ordered, :id, :description, t('shoppe.products.stock_control') do 
 f.label :weight, t('shoppe.products.weight') 
 f.text_field :weight, :class => 'text' 
 f.label :stock_control,  t('shoppe.products.stock_control') 
 f.check_box :stock_control 
 f.label :stock_control, t('shoppe.products.enable_stock_control?') 
 end 
 end 
 field_set_tag  t('shoppe.products.website_properties') do 
 f.label :active,  t('shoppe.products.on_sale?') 
 f.check_box :active 
 f.label :active,  t('shoppe.products.on_sale_info') 
 f.label :featured,  t('shoppe.products.featured?') 
 f.check_box :featured 
 f.label :featured, t('shoppe.products.featured_info') 
 end 
 unless @product.new_record? 
 link_to t('shoppe.delete') , @product, :class => 'button purple', :method => :delete, :data => {:confirm => "Are you sure you wish to remove this product?"} 
 end 
 f.submit t('shoppe.submit'),  :class => 'button green' 
 link_to t('shoppe.cancel'), :products, :class => 'button' 
 end 
end
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
    end

    def destroy
      @product.destroy
      redirect_to :products, flash: { notice: t('shoppe.products.destroy_notice') }
    end

    def import
      if request.post?
        if params[:import].nil?
          redirect_to import_products_path, flash: { alert: t('shoppe.imports.errors.no_file') }
        else
          Shoppe::Product.import(params[:import][:import_file])
          redirect_to products_path, flash: { notice: t('shoppe.products.imports.success') }
        end
      end
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
 t('shoppe.products.import_products') 
 display_flash 
 @page_title = t('shoppe.products.products') 
  
 form_for "import", :url => import_products_path, :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag t('shoppe.imports.file_upload') do 
 f.label :import_file, t('shoppe.imports.required_formats') 
 f.file_field :import_file 
 end 
 field_set_tag t('shoppe.imports.example_file') do 
 t('shoppe.products.imports.examples.first.name') 
 t('shoppe.products.imports.examples.first.sku') 
 t('shoppe.products.imports.examples.first.permalink') 
 t('shoppe.products.imports.examples.first.description') 
 t('shoppe.products.imports.examples.first.short_description') 
 t('shoppe.products.imports.examples.first.weight') 
 t('shoppe.products.imports.examples.first.price') 
 t('shoppe.products.imports.examples.first.category_name') 
 t('shoppe.products.imports.examples.first.qty') 
 t('shoppe.products.imports.examples.second.name') 
 t('shoppe.products.imports.examples.second.sku') 
 t('shoppe.products.imports.examples.second.permalink') 
 t('shoppe.products.imports.examples.second.description') 
 t('shoppe.products.imports.examples.second.short_description') 
 t('shoppe.products.imports.examples.second.weight') 
 t('shoppe.products.imports.examples.second.price') 
 t('shoppe.products.imports.examples.second.category_name') 
 t('shoppe.products.imports.examples.second.qty') 
 t('shoppe.products.imports.examples.third.name') 
 t('shoppe.products.imports.examples.third.sku') 
 t('shoppe.products.imports.examples.third.permalink') 
 t('shoppe.products.imports.examples.third.description') 
 t('shoppe.products.imports.examples.third.short_description') 
 t('shoppe.products.imports.examples.third.weight') 
 t('shoppe.products.imports.examples.third.price') 
 t('shoppe.products.imports.examples.third.category_name') 
 t('shoppe.products.imports.examples.third.qty') 
 t('shoppe.products.imports.help') 
 end 
 f.submit t('shoppe.import'), :class => "button green" 
 link_to t('shoppe.cancel'), :products, :class => "button" 
 end 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    private

    def safe_params
      file_params = [:file, :parent_id, :role, :parent_type, file: []]
      params[:product].permit(:name, :sku, :permalink, :description, :short_description, :weight, :price, :cost_price, :tax_rate_id, :stock_control, :active, :featured, :in_the_box, attachments: [default_image: file_params, data_sheet: file_params, extra: file_params], product_attributes_array: [:key, :value, :searchable, :public], product_category_ids: [])
    end
  end
end
