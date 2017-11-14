module Shoppe
  class VariantsController < ApplicationController
    before_filter { @active_nav = :products }
    before_filter { @product = Shoppe::Product.find(params[:product_id]) }
    before_filter { params[:id] && @variant = @product.variants.find(params[:id]) }

    def index
      @variants = @product.variants.ordered
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag :application 
 javascript_include_tag :application 
 csrf_meta_tags 
 yield :head 
 link_to "Play with Shoppe Admin", "/shoppe" 
 link_to "Browse the code", "http://github.com/tryshoppe/core" 
 display_flash 
 link_to "Home", root_path, :nav_item => :home 
 link_to "Our catalogue", catalogue_path, :nav_item => :catalogue, :class => 'noborder' 
 for category in Shoppe::ProductCategory.ordered 
 link_to category.name, products_path(category.permalink) 
 end 
 link_to "Why shop with us?", page_path(:why), :nav_item => :why 
 link_to "FAQs", page_path(:faqs), :nav_item => :faqs 
 link_to "Get in touch", page_path(:contact), :nav_item => :contact 
 link_to Shoppe.settings.store_name, root_path 
 if @full_header 
 end 
 if @full_header 
 end 
 if content_for?(:sidebar) 
 yield :sidebar 
 else 
  if has_order? && current_order.has_items? 
 link_to "View my bag", basket_path 
 link_to "Checkout", checkout_path, :class => 'checkout' 
 else 
 end 
 
 end 
 @page_title = "#{t('shoppe.variants.variants')} - #{@product.name}" 
 content_for :header do 
 link_to t('shoppe.variants.edit_product'), [:edit, @product], :class => 'button' 
 link_to t('shoppe.variants.new_variant'), [:new, @product, :variant], :class => 'button green' 
 t('shoppe.variants.variants_of', product: @product.name) 
 end 
 t('shoppe.variants.sku') 
 t('shoppe.variants.name') 
 t('shoppe.variants.price') 
 t('shoppe.variants.stock') 
 if @variants.empty? 
 t('shoppe.variants.no_products') 
 else 
 for variant in @variants 
 variant.sku 
 link_to variant.name, edit_product_variant_path(@product, variant) 
 number_to_currency variant.price 
 if variant.stock_control? 
 link_to t('shoppe.edit'), stock_level_adjustments_path(:item_type => variant.class, :item_id => variant.id), :class => 'edit', :rel => 'dialog', :data => {:dialog_width => 700, :dialog_behavior => 'stockLevelAdjustments'} 
 boolean_tag(variant.in_stock?, nil, :true_text => variant.stock, :false_text => t('shoppe.variants.no_stock')) 
 else 
 end 
 end 
 end 
 link_to "Terms & Conditions", page_path(:terms) 
 link_to "Privacy policy", page_path(:privacy) 
 link_to "Returns policy", page_path(:returns) 
 link_to "Frequently asked questions", page_path(:faqs) 
 link_to "Cookie policy", page_path(:cookies) 
 link_to "Twitter", 'http://twitter.com/niftyware' 
 link_to "Facebook", "http://facebook.com/niftyware" 
 link_to "Pinterest", "http://pinterest.com" 
 link_to "Linked In", "http://linkedin.com" 
 link_to "Vimeo", "http://vimeo.com" 
 link_to "Youtube", "http://youtube.com" 

end

    end

    def new
      @variant = @product.variants.build
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag :application 
 javascript_include_tag :application 
 csrf_meta_tags 
 yield :head 
 link_to "Play with Shoppe Admin", "/shoppe" 
 link_to "Browse the code", "http://github.com/tryshoppe/core" 
 display_flash 
 link_to "Home", root_path, :nav_item => :home 
 link_to "Our catalogue", catalogue_path, :nav_item => :catalogue, :class => 'noborder' 
 for category in Shoppe::ProductCategory.ordered 
 link_to category.name, products_path(category.permalink) 
 end 
 link_to "Why shop with us?", page_path(:why), :nav_item => :why 
 link_to "FAQs", page_path(:faqs), :nav_item => :faqs 
 link_to "Get in touch", page_path(:contact), :nav_item => :contact 
 link_to Shoppe.settings.store_name, root_path 
 if @full_header 
 end 
 if @full_header 
 end 
 if content_for?(:sidebar) 
 yield :sidebar 
 else 
  if has_order? && current_order.has_items? 
 link_to "View my bag", basket_path 
 link_to "Checkout", checkout_path, :class => 'checkout' 
 else 
 end 
 
 end 
 @page_title = "#{t('shoppe.variants.variants')} - #{@product.name}" 
 content_for :header do 
 link_to t('shoppe.variants.back_to_variants'), [@product, :variants], :class => 'button' 
 t('shoppe.variants.variants_of', product:@product.name) 
 end 
 form_for [@product, @variant], :url => @variant.new_record? ? product_variants_path(@product) : product_variant_path(@product, @variant), :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag t('shoppe.variants.product_information') do 
 f.label :name, t('shoppe.variants.name') 
 f.text_field :name, :class => 'text focus' 
 f.label :permalink, t('shoppe.variants.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :sku, t('shoppe.variants.sku') 
 f.text_field :sku, :class => 'text' 
 end 
 field_set_tag t('shoppe.variants.image') do 
 attachment_preview @variant.default_image, :hide_if_blank => true 
 f.file_field :default_image_file 
 end 
 field_set_tag t("shoppe.variants.pricing") do 
 f.label :price, t('shoppe.variants.price') 
 f.text_field :price, :class => 'text' 
 f.label :cost_price, t('shoppe.variants.cost_price') 
 f.text_field :cost_price, :class => 'text' 
 f.label :tax_rate_id, t('shoppe.variants.tax_rate') 
 f.collection_select :tax_rate_id, Shoppe::TaxRate.ordered, :id, :description,  t('shoppe.variants.stock_control') do 
 f.label :weight, t('shoppe.variants.weight') 
 f.text_field :weight, :class => 'text' 
 f.label :stock_control, t('shoppe.variants.stock_control') 
 f.check_box :stock_control 
 f.label :stock_control, t('shoppe.variants.enable_stock_control?') 
 end 
 field_set_tag t('shoppe.variants.website_properties') do 
 f.label :active, t('shoppe.variants.on_sale?') 
 f.check_box :active 
 f.label :active, t('shoppe.variants.on_sale_info') 
 f.label :default, t('shoppe.variants.default_variant?') 
 f.check_box :default 
 f.label :default, t('shoppe.variants.default_variant_info') 
 end 
 unless @variant.new_record? 
 link_to t('shoppe.delete'), product_variant_path(@product, @variant), :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.variants.delete_confirmation')} 
 end 
 f.submit t('shoppe.variants.save_variant'), :class => 'button green' 
 link_to t('shoppe.cancel'), :products, :class => 'button' 
 end 
end
 link_to "Terms & Conditions", page_path(:terms) 
 link_to "Privacy policy", page_path(:privacy) 
 link_to "Returns policy", page_path(:returns) 
 link_to "Frequently asked questions", page_path(:faqs) 
 link_to "Cookie policy", page_path(:cookies) 
 link_to "Twitter", 'http://twitter.com/niftyware' 
 link_to "Facebook", "http://facebook.com/niftyware" 
 link_to "Pinterest", "http://pinterest.com" 
 link_to "Linked In", "http://linkedin.com" 
 link_to "Vimeo", "http://vimeo.com" 
 link_to "Youtube", "http://youtube.com" 

end

    end

    def create
      @variant = @product.variants.build(safe_params)
      if @variant.save
        redirect_to [@product, :variants], notice: t('shoppe.variants.create_notice')
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag :application 
 javascript_include_tag :application 
 csrf_meta_tags 
 yield :head 
 link_to "Play with Shoppe Admin", "/shoppe" 
 link_to "Browse the code", "http://github.com/tryshoppe/core" 
 display_flash 
 link_to "Home", root_path, :nav_item => :home 
 link_to "Our catalogue", catalogue_path, :nav_item => :catalogue, :class => 'noborder' 
 for category in Shoppe::ProductCategory.ordered 
 link_to category.name, products_path(category.permalink) 
 end 
 link_to "Why shop with us?", page_path(:why), :nav_item => :why 
 link_to "FAQs", page_path(:faqs), :nav_item => :faqs 
 link_to "Get in touch", page_path(:contact), :nav_item => :contact 
 link_to Shoppe.settings.store_name, root_path 
 if @full_header 
 end 
 if @full_header 
 end 
 if content_for?(:sidebar) 
 yield :sidebar 
 else 
  if has_order? && current_order.has_items? 
 link_to "View my bag", basket_path 
 link_to "Checkout", checkout_path, :class => 'checkout' 
 else 
 end 
 
 end 
 @page_title = "#{t('shoppe.variants.variants')} - #{@product.name}" 
 content_for :header do 
 link_to t('shoppe.variants.back_to_variants'), [@product, :variants], :class => 'button' 
 t('shoppe.variants.variants_of', product:@product.name) 
 end 
 form_for [@product, @variant], :url => @variant.new_record? ? product_variants_path(@product) : product_variant_path(@product, @variant), :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag t('shoppe.variants.product_information') do 
 f.label :name, t('shoppe.variants.name') 
 f.text_field :name, :class => 'text focus' 
 f.label :permalink, t('shoppe.variants.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :sku, t('shoppe.variants.sku') 
 f.text_field :sku, :class => 'text' 
 end 
 field_set_tag t('shoppe.variants.image') do 
 attachment_preview @variant.default_image, :hide_if_blank => true 
 f.file_field :default_image_file 
 end 
 field_set_tag t("shoppe.variants.pricing") do 
 f.label :price, t('shoppe.variants.price') 
 f.text_field :price, :class => 'text' 
 f.label :cost_price, t('shoppe.variants.cost_price') 
 f.text_field :cost_price, :class => 'text' 
 f.label :tax_rate_id, t('shoppe.variants.tax_rate') 
 f.collection_select :tax_rate_id, Shoppe::TaxRate.ordered, :id, :description,  t('shoppe.variants.stock_control') do 
 f.label :weight, t('shoppe.variants.weight') 
 f.text_field :weight, :class => 'text' 
 f.label :stock_control, t('shoppe.variants.stock_control') 
 f.check_box :stock_control 
 f.label :stock_control, t('shoppe.variants.enable_stock_control?') 
 end 
 field_set_tag t('shoppe.variants.website_properties') do 
 f.label :active, t('shoppe.variants.on_sale?') 
 f.check_box :active 
 f.label :active, t('shoppe.variants.on_sale_info') 
 f.label :default, t('shoppe.variants.default_variant?') 
 f.check_box :default 
 f.label :default, t('shoppe.variants.default_variant_info') 
 end 
 unless @variant.new_record? 
 link_to t('shoppe.delete'), product_variant_path(@product, @variant), :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.variants.delete_confirmation')} 
 end 
 f.submit t('shoppe.variants.save_variant'), :class => 'button green' 
 link_to t('shoppe.cancel'), :products, :class => 'button' 
 end 
end
 link_to "Terms & Conditions", page_path(:terms) 
 link_to "Privacy policy", page_path(:privacy) 
 link_to "Returns policy", page_path(:returns) 
 link_to "Frequently asked questions", page_path(:faqs) 
 link_to "Cookie policy", page_path(:cookies) 
 link_to "Twitter", 'http://twitter.com/niftyware' 
 link_to "Facebook", "http://facebook.com/niftyware" 
 link_to "Pinterest", "http://pinterest.com" 
 link_to "Linked In", "http://linkedin.com" 
 link_to "Vimeo", "http://vimeo.com" 
 link_to "Youtube", "http://youtube.com" 

end

      end
    end

    def edit
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag :application 
 javascript_include_tag :application 
 csrf_meta_tags 
 yield :head 
 link_to "Play with Shoppe Admin", "/shoppe" 
 link_to "Browse the code", "http://github.com/tryshoppe/core" 
 display_flash 
 link_to "Home", root_path, :nav_item => :home 
 link_to "Our catalogue", catalogue_path, :nav_item => :catalogue, :class => 'noborder' 
 for category in Shoppe::ProductCategory.ordered 
 link_to category.name, products_path(category.permalink) 
 end 
 link_to "Why shop with us?", page_path(:why), :nav_item => :why 
 link_to "FAQs", page_path(:faqs), :nav_item => :faqs 
 link_to "Get in touch", page_path(:contact), :nav_item => :contact 
 link_to Shoppe.settings.store_name, root_path 
 if @full_header 
 end 
 if @full_header 
 end 
 if content_for?(:sidebar) 
 yield :sidebar 
 else 
  if has_order? && current_order.has_items? 
 link_to "View my bag", basket_path 
 link_to "Checkout", checkout_path, :class => 'checkout' 
 else 
 end 
 
 end 
 @page_title = "#{t('shoppe.variants.variants')} - #{@product.name}" 
 content_for :header do 
 link_to t('shoppe.variants.back_to_variants'), [@product, :variants], :class => 'button' 
 t('shoppe.variants.variants_of', product:@product.name) 
 end 
 form_for [@product, @variant], :url => @variant.new_record? ? product_variants_path(@product) : product_variant_path(@product, @variant), :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag t('shoppe.variants.product_information') do 
 f.label :name, t('shoppe.variants.name') 
 f.text_field :name, :class => 'text focus' 
 f.label :permalink, t('shoppe.variants.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :sku, t('shoppe.variants.sku') 
 f.text_field :sku, :class => 'text' 
 end 
 field_set_tag t('shoppe.variants.image') do 
 attachment_preview @variant.default_image, :hide_if_blank => true 
 f.file_field :default_image_file 
 end 
 field_set_tag t("shoppe.variants.pricing") do 
 f.label :price, t('shoppe.variants.price') 
 f.text_field :price, :class => 'text' 
 f.label :cost_price, t('shoppe.variants.cost_price') 
 f.text_field :cost_price, :class => 'text' 
 f.label :tax_rate_id, t('shoppe.variants.tax_rate') 
 f.collection_select :tax_rate_id, Shoppe::TaxRate.ordered, :id, :description,  t('shoppe.variants.stock_control') do 
 f.label :weight, t('shoppe.variants.weight') 
 f.text_field :weight, :class => 'text' 
 f.label :stock_control, t('shoppe.variants.stock_control') 
 f.check_box :stock_control 
 f.label :stock_control, t('shoppe.variants.enable_stock_control?') 
 end 
 field_set_tag t('shoppe.variants.website_properties') do 
 f.label :active, t('shoppe.variants.on_sale?') 
 f.check_box :active 
 f.label :active, t('shoppe.variants.on_sale_info') 
 f.label :default, t('shoppe.variants.default_variant?') 
 f.check_box :default 
 f.label :default, t('shoppe.variants.default_variant_info') 
 end 
 unless @variant.new_record? 
 link_to t('shoppe.delete'), product_variant_path(@product, @variant), :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.variants.delete_confirmation')} 
 end 
 f.submit t('shoppe.variants.save_variant'), :class => 'button green' 
 link_to t('shoppe.cancel'), :products, :class => 'button' 
 end 
end
 link_to "Terms & Conditions", page_path(:terms) 
 link_to "Privacy policy", page_path(:privacy) 
 link_to "Returns policy", page_path(:returns) 
 link_to "Frequently asked questions", page_path(:faqs) 
 link_to "Cookie policy", page_path(:cookies) 
 link_to "Twitter", 'http://twitter.com/niftyware' 
 link_to "Facebook", "http://facebook.com/niftyware" 
 link_to "Pinterest", "http://pinterest.com" 
 link_to "Linked In", "http://linkedin.com" 
 link_to "Vimeo", "http://vimeo.com" 
 link_to "Youtube", "http://youtube.com" 

end
end

    def update
      if @variant.update(safe_params)
        redirect_to edit_product_variant_path(@product, @variant), notice: t('shoppe.variants.update_notice')
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag :application 
 javascript_include_tag :application 
 csrf_meta_tags 
 yield :head 
 link_to "Play with Shoppe Admin", "/shoppe" 
 link_to "Browse the code", "http://github.com/tryshoppe/core" 
 display_flash 
 link_to "Home", root_path, :nav_item => :home 
 link_to "Our catalogue", catalogue_path, :nav_item => :catalogue, :class => 'noborder' 
 for category in Shoppe::ProductCategory.ordered 
 link_to category.name, products_path(category.permalink) 
 end 
 link_to "Why shop with us?", page_path(:why), :nav_item => :why 
 link_to "FAQs", page_path(:faqs), :nav_item => :faqs 
 link_to "Get in touch", page_path(:contact), :nav_item => :contact 
 link_to Shoppe.settings.store_name, root_path 
 if @full_header 
 end 
 if @full_header 
 end 
 if content_for?(:sidebar) 
 yield :sidebar 
 else 
  if has_order? && current_order.has_items? 
 link_to "View my bag", basket_path 
 link_to "Checkout", checkout_path, :class => 'checkout' 
 else 
 end 
 
 end 
 @page_title = "#{t('shoppe.variants.variants')} - #{@product.name}" 
 content_for :header do 
 link_to t('shoppe.variants.back_to_variants'), [@product, :variants], :class => 'button' 
 t('shoppe.variants.variants_of', product:@product.name) 
 end 
 form_for [@product, @variant], :url => @variant.new_record? ? product_variants_path(@product) : product_variant_path(@product, @variant), :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag t('shoppe.variants.product_information') do 
 f.label :name, t('shoppe.variants.name') 
 f.text_field :name, :class => 'text focus' 
 f.label :permalink, t('shoppe.variants.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :sku, t('shoppe.variants.sku') 
 f.text_field :sku, :class => 'text' 
 end 
 field_set_tag t('shoppe.variants.image') do 
 attachment_preview @variant.default_image, :hide_if_blank => true 
 f.file_field :default_image_file 
 end 
 field_set_tag t("shoppe.variants.pricing") do 
 f.label :price, t('shoppe.variants.price') 
 f.text_field :price, :class => 'text' 
 f.label :cost_price, t('shoppe.variants.cost_price') 
 f.text_field :cost_price, :class => 'text' 
 f.label :tax_rate_id, t('shoppe.variants.tax_rate') 
 f.collection_select :tax_rate_id, Shoppe::TaxRate.ordered, :id, :description,  t('shoppe.variants.stock_control') do 
 f.label :weight, t('shoppe.variants.weight') 
 f.text_field :weight, :class => 'text' 
 f.label :stock_control, t('shoppe.variants.stock_control') 
 f.check_box :stock_control 
 f.label :stock_control, t('shoppe.variants.enable_stock_control?') 
 end 
 field_set_tag t('shoppe.variants.website_properties') do 
 f.label :active, t('shoppe.variants.on_sale?') 
 f.check_box :active 
 f.label :active, t('shoppe.variants.on_sale_info') 
 f.label :default, t('shoppe.variants.default_variant?') 
 f.check_box :default 
 f.label :default, t('shoppe.variants.default_variant_info') 
 end 
 unless @variant.new_record? 
 link_to t('shoppe.delete'), product_variant_path(@product, @variant), :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.variants.delete_confirmation')} 
 end 
 f.submit t('shoppe.variants.save_variant'), :class => 'button green' 
 link_to t('shoppe.cancel'), :products, :class => 'button' 
 end 
end
 link_to "Terms & Conditions", page_path(:terms) 
 link_to "Privacy policy", page_path(:privacy) 
 link_to "Returns policy", page_path(:returns) 
 link_to "Frequently asked questions", page_path(:faqs) 
 link_to "Cookie policy", page_path(:cookies) 
 link_to "Twitter", 'http://twitter.com/niftyware' 
 link_to "Facebook", "http://facebook.com/niftyware" 
 link_to "Pinterest", "http://pinterest.com" 
 link_to "Linked In", "http://linkedin.com" 
 link_to "Vimeo", "http://vimeo.com" 
 link_to "Youtube", "http://youtube.com" 

end

      end
    end

    def destroy
      @variant.destroy
      redirect_to [@product, :variants], notice: t('shoppe.variants.destroy_notice')
    end

    private

    def safe_params
      params[:product].permit(:name, :permalink, :sku, :default_image_file, :price, :cost_price, :tax_rate_id, :weight, :stock_control, :active, :default)
    end
  end
end
