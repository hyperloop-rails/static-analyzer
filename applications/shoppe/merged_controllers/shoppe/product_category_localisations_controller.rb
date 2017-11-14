require 'globalize'

module Shoppe
  class ProductCategoryLocalisationsController < ApplicationController
    before_filter { @active_nav = :product_categories }
    before_filter { @product_category = Shoppe::ProductCategory.find(params[:product_category_id]) }
    before_filter { params[:id] && @localisation = @product_category.translations.find(params[:id]) }

    def index
      @localisations = @product_category.translations
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
 @page_title = "#{t('shoppe.localisations.localisations')} - #{@product_category.name}" 
 content_for :header do 
 link_to t('shoppe.localisations.back'), product_categories_path, :class => 'button' 
 link_to t('shoppe.localisations.new_localisation'), [:new, @product_category, :localisation], :class => 'button green' 
 t('shoppe.localisations.localisations_of', name: @product_category.name) 
 end 
 t('shoppe.localisations.language') 
 t('shoppe.products.name') 
 t('shoppe.products.permalink') 
 if @localisations.empty? 
 t('shoppe.localisations.no_localisations') 
 else 
 for localisation in @localisations 
 localisation.locale 
 link_to localisation.name, edit_product_category_localisation_path(@product_category, localisation) 
 localisation.permalink 
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
      @localisation = @product_category.translations.new
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
 @page_title = "#{t('shoppe.localisations.localisations')} - #{@product_category.name}" 
 content_for :header do 
 link_to t('shoppe.localisations.back_to_localisations'), [@product_category, :localisations], :class => 'button' 
 t('shoppe.localisations.localisations_of', name: @product_category.name) 
 end 
 loc = @localisation.new_record? ? :en : @localisation.locale.to_sym 
 Globalize.with_locale(loc) do 
 form_for [@product_category, @localisation], :url => @localisation.new_record? ? product_category_localisations_path(@product_category) : product_category_localisation_path(@product_category, @localisation), :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag t('shoppe.product_category.category_details') do 
 f.label :name, t('shoppe.product_category.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :locale 
 f.select :locale, I18n.available_locales, {selected: @localisation.locale || params[:locale_field]}, {class: "chosen"} 
 f.label :permalink, t('shoppe.product_category.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :description, t('shoppe.product_category.description') 
 f.text_area :description, :class => 'text' 
 end 
 unless @localisation.new_record? 
 link_to t('shoppe.delete'), product_category_localisation_path(@product_category, @localisation), :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.localisations.delete_confirmation')} 
 end 
 f.submit t('shoppe.localisations.save_localisation'), :class => 'button green' 
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
      if I18n.available_locales.include? safe_params[:locale].to_sym
        I18n.locale = safe_params[:locale].to_sym

        if @product_category.update(safe_params)
          I18n.locale = I18n.default_locale
          redirect_to [@product_category, :localisations], flash: { notice: t('shoppe.localisations.localisation_created') }
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
 @page_title = "#{t('shoppe.orders.edit_order')} ##{@order.number}" 
 content_for :header do 
 link_to t('shoppe.orders.back_to_order'), @order, :class => 'button grey' 
 end 
 form_for @order, :html => {:class => 'orderForm'} do |f| 
 f.error_messages 
  field_set_tag t('shoppe.orders.billing_address') do 
 f.label :customer_id, t('shoppe.orders.customer') 
 f.collection_select :customer_id, Shoppe::Customer.ordered, :id, :name
 f.label :first_name, t('shoppe.orders.first_name') 
 f.text_field :first_name, :class => 'focus text' 
 f.label :last_name, t('shoppe.orders.last_name') 
 f.text_field :last_name, :class => 'text' 
 f.label :company, t('shoppe.orders.company') 
 f.text_field :company, :class => 'text' 
 f.label :billing_address1, t('shoppe.orders.address') 
 f.text_field :billing_address1, :class => 'text' 
 f.text_field :billing_address2, :class => 'text' 
 f.text_field :billing_address3, :class => 'text' 
 f.text_field :billing_address4, :class => 'text' 
 f.label :billing_postcode, t('shoppe.orders.post_code') 
 f.text_field :billing_postcode, :class => 'text' 
 f.label :billing_country_id, t('shoppe.orders.country') 
 f.collection_select :billing_country_id, Shoppe::Country.ordered, :id, :name
 f.label :email_address, t('shoppe.orders.email_address') 
 f.text_field :email_address, :class => 'text' 
 f.label :phone_number, t('shoppe.orders.phone_number') 
 f.text_field :phone_number, :class => 'text' 
 f.label :separate_delivery_address, t('shoppe.orders.separate_delivery_address') 
 f.check_box :separate_delivery_address 
 f.label :separate_delivery_address, t('shoppe.orders.use_separate_delivery_address?') 
 end 
 field_set_tag t('shoppe.orders.delivery_address'), :class => 'delivery' do 
 f.label :delivery_name, t('shoppe.orders.delivery_name') 
 f.text_field :delivery_name, :class => 'text' 
 f.label :delivery_address1, t('shoppe.orders.address') 
 f.text_field :delivery_address1, :class => 'text' 
 f.text_field :delivery_address2, :class => 'text' 
 f.text_field :delivery_address3, :class => 'text' 
 f.text_field :delivery_address4, :class => 'text' 
 f.label :delivery_postcode, t('shoppe.orders.post_code') 
 f.text_field :delivery_postcode, :class => 'text' 
 f.label :delivery_country_id, t('shoppe.orders.country') 
 f.collection_select :delivery_country_id, Shoppe::Country.ordered, :id, :name 
 end 
 
 field_set_tag  t('shoppe.orders.notes') do 
 f.text_area :notes, :class => 'text' 
 end 
 field_set_tag t('shoppe.orders.ordered_products'), :class => 'padded' do 
  t('shoppe.orders.product') 
 t('shoppe.orders.quantity') 
 t('shoppe.orders.stock') 
 t('shoppe.orders.unit_price') 
 t('shoppe.orders.tax') 
 t('shoppe.orders.sub_total') 
 t('shoppe.orders.weight') 
 products = Shoppe::Product.ordered 
 f.fields_for :order_items do |of| 
 of.hidden_field :ordered_item_type 
 (of.object.ordered_item ? 'existing' : 'new') 
 if of.object.ordered_item 
 of.text_field :quantity, :class => 'text' 
 (@order.new_record? && !of.object.in_stock? ? 'oos' : '') 
 of.object.ordered_item.stock 
 of.text_field :unit_price, :placeholder => number_to_currency(of.object.unit_price, :unit => ''), :class =>'text short' 
 of.text_field :tax_amount, :placeholder => number_to_currency(of.object.tax_amount, :unit => ''), :class =>'text short' 
 text_field_tag '_', number_to_currency(of.object.total, :unit => ''), :disabled => true, :class => 'text short' 
 of.text_field :weight, :placeholder => of.object.weight, :class =>'text short' 
 end 
 end 
 if @order.available_delivery_services.empty? 
 if @order.delivery_required? 
 t('shoppe.orders.missing_delivery_service') 
 else 
 t('shoppe.orders.no_delivery_required') 
 end 
 else 
 f.collection_select :delivery_service_id, @order.available_delivery_services, :id, :name 
 f.text_field :delivery_price, :placeholder => number_to_currency(@order.delivery_price, :unit => ''), :class =>'text short' 
 f.text_field :delivery_tax_amount, :placeholder => number_to_currency(@order.delivery_tax_amount, :unit => ''), :class => 'text short' 
 text_field_tag '_', number_to_currency(@order.delivery_price + @order.delivery_tax_amount, :unit => ''), :class => 'text short', :disabled => true 
 end 
 text_field_tag '_', number_to_currency(@order.total_before_tax, :unit => ''), :class => 'text short', :disabled => true 
 text_field_tag '_', number_to_currency(@order.tax, :unit => ''), :class => 'text short', :disabled => true 
 text_field_tag '_', number_to_currency(@order.total, :unit => ''), :class => 'text short', :disabled => true 
 text_field_tag '_', number_to_currency(@order.total_weight, :unit => ''), :class => 'text short', :disabled => true 
 unless @order.new_record? 
 t('shoppe.orders.sla_warning') 
 end 
 
 end 
 f.submit t('shoppe.orders.save_order') , :class => 'button green' 
 link_to t('shoppe.cancel'), @order, :class => 'button' 
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
      else
        redirect_to [@product_category, :localisations]
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
 @page_title = "#{t('shoppe.localisations.localisations')} - #{@product_category.name}" 
 content_for :header do 
 link_to t('shoppe.localisations.back_to_localisations'), [@product_category, :localisations], :class => 'button' 
 t('shoppe.localisations.localisations_of', name: @product_category.name) 
 end 
 loc = @localisation.new_record? ? :en : @localisation.locale.to_sym 
 Globalize.with_locale(loc) do 
 form_for [@product_category, @localisation], :url => @localisation.new_record? ? product_category_localisations_path(@product_category) : product_category_localisation_path(@product_category, @localisation), :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag t('shoppe.product_category.category_details') do 
 f.label :name, t('shoppe.product_category.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :locale 
 f.select :locale, I18n.available_locales, {selected: @localisation.locale || params[:locale_field]}, {class: "chosen"} 
 f.label :permalink, t('shoppe.product_category.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :description, t('shoppe.product_category.description') 
 f.text_area :description, :class => 'text' 
 end 
 unless @localisation.new_record? 
 link_to t('shoppe.delete'), product_category_localisation_path(@product_category, @localisation), :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.localisations.delete_confirmation')} 
 end 
 f.submit t('shoppe.localisations.save_localisation'), :class => 'button green' 
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
      if @localisation.update(safe_params)
        redirect_to [@product_category, :localisations], notice: t('shoppe.localisations.localisation_updated')
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
 @page_title = "#{t('shoppe.localisations.localisations')} - #{@product_category.name}" 
 content_for :header do 
 link_to t('shoppe.localisations.back_to_localisations'), [@product_category, :localisations], :class => 'button' 
 t('shoppe.localisations.localisations_of', name: @product_category.name) 
 end 
 loc = @localisation.new_record? ? :en : @localisation.locale.to_sym 
 Globalize.with_locale(loc) do 
 form_for [@product_category, @localisation], :url => @localisation.new_record? ? product_category_localisations_path(@product_category) : product_category_localisation_path(@product_category, @localisation), :html => {:multipart => true} do |f| 
 f.error_messages 
 field_set_tag t('shoppe.product_category.category_details') do 
 f.label :name, t('shoppe.product_category.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :locale 
 f.select :locale, I18n.available_locales, {selected: @localisation.locale || params[:locale_field]}, {class: "chosen"} 
 f.label :permalink, t('shoppe.product_category.permalink') 
 f.text_field :permalink, :class => 'text' 
 f.label :description, t('shoppe.product_category.description') 
 f.text_area :description, :class => 'text' 
 end 
 unless @localisation.new_record? 
 link_to t('shoppe.delete'), product_category_localisation_path(@product_category, @localisation), :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.localisations.delete_confirmation')} 
 end 
 f.submit t('shoppe.localisations.save_localisation'), :class => 'button green' 
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
      @localisation.destroy
      redirect_to [@product_category, :localisations], notice: t('shoppe.localisations.localisation_destroyed')
    end

    private

    def safe_params
      params[:product_category_translation].permit(:name, :locale, :permalink, :description)
    end
  end
end
