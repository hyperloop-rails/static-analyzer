module Shoppe
  class DeliveryServicePricesController < Shoppe::ApplicationController
    before_filter { @active_nav = :delivery_services }
    before_filter { @delivery_service = Shoppe::DeliveryService.find(params[:delivery_service_id]) }
    before_filter { params[:id] && @delivery_service_price = @delivery_service.delivery_service_prices.find(params[:id]) }

    def index
      @delivery_service_prices = @delivery_service.delivery_service_prices.ordered
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
 link_to t('shoppe.delivery_service_prices.new_price'), [:new, @delivery_service, :delivery_service_price], :class => 'button green' 
 link_to t('shoppe.delivery_service_prices.back_to_delivery_services'), :delivery_services, :class => 'button' 
 t('shoppe.delivery_service_prices.pricing_for', delivery_name: @delivery_service.name) 
 display_flash 
 @page_title = t('shoppe.delivery_service_prices.delivery_services') 
  
 t('shoppe.delivery_service_prices.code') 
 t('shoppe.delivery_service_prices.weight_allowance') 
 t('shoppe.delivery_service_prices.price') 
 t('shoppe.delivery_service_prices.cost') 
 for price in @delivery_service_prices 
 link_to price.code, [:edit, @delivery_service, price] 
 number_to_currency(price.price) 
 number_to_currency price.cost_price 
 end 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def new
      @delivery_service_price = @delivery_service.delivery_service_prices.build
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
 link_to t('shoppe.delivery_service_prices.back') , [@delivery_service, :delivery_service_prices], :class => 'button' 
 t('shoppe.delivery_service_prices.delivery_services') 
 display_flash 
 @page_title = t('shoppe.delivery_service_prices.delivery_services') 
  
  form_for [@delivery_service, @delivery_service_price] do |f| 
 f.error_messages 
 field_set_tag t('shoppe.delivery_service_prices.identification_weight')  do 
 f.label :code, t('shoppe.delivery_service_prices.code') 
 f.text_field :code, :class => 'focus text' 
 f.label :min_weight, t('shoppe.delivery_service_prices.min_weight') 
 f.text_field :min_weight, :class => 'text' 
 f.label :max_weight, t('shoppe.delivery_service_prices.max_weight') 
 f.text_field :max_weight, :class => 'text' 
 end 
 field_set_tag t('shoppe.delivery_service_prices.pricing') do 
 f.label :price, t('shoppe.delivery_service_prices.price') 
 Shoppe.settings.currency_unit.html_safe 
 f.text_field :price, :class => 'text' 
 f.label :cost_price, t('shoppe.delivery_service_prices.cost_price') 
 Shoppe.settings.currency_unit.html_safe 
 f.text_field :cost_price, :class => 'text' 
 f.label :tax_rate_id, t('shoppe.delivery_service_prices.tax_rate') 
 f.collection_select :tax_rate_id, Shoppe::TaxRate.ordered, :id, :description,  t('shoppe.delivery_service_prices.countries') do 
 f.collection_select :country_ids, Shoppe::Country.ordered, :id, :name, t('shoppe.delivery_service_prices.help.countries') 
 end 
 unless @delivery_service_price.new_record? 
 link_to t('shoppe.delete'), [@delivery_service, @delivery_service_price], :class => 'button purple', :method => :delete, :data => {:confirm => "Are you sure you wish to remove this price?"} 
 end 
 f.submit t('shoppe.submit'), :class => 'button green' 
 link_to t('shoppe.cancel'), [@delivery_service, :delivery_service_prices], :class => 'button' 
 end 
end
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def create
      @delivery_service_price = @delivery_service.delivery_service_prices.build(safe_params)
      if @delivery_service_price.save
        redirect_to [@delivery_service, :delivery_service_prices], notice: t('shoppe.delivery_service_prices.create_notice')
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
 link_to t('shoppe.delivery_service_prices.back') , [@delivery_service, :delivery_service_prices], :class => 'button' 
 t('shoppe.delivery_service_prices.delivery_services') 
 display_flash 
 @page_title = t('shoppe.delivery_service_prices.delivery_services') 
  
  form_for [@delivery_service, @delivery_service_price] do |f| 
 f.error_messages 
 field_set_tag t('shoppe.delivery_service_prices.identification_weight')  do 
 f.label :code, t('shoppe.delivery_service_prices.code') 
 f.text_field :code, :class => 'focus text' 
 f.label :min_weight, t('shoppe.delivery_service_prices.min_weight') 
 f.text_field :min_weight, :class => 'text' 
 f.label :max_weight, t('shoppe.delivery_service_prices.max_weight') 
 f.text_field :max_weight, :class => 'text' 
 end 
 field_set_tag t('shoppe.delivery_service_prices.pricing') do 
 f.label :price, t('shoppe.delivery_service_prices.price') 
 Shoppe.settings.currency_unit.html_safe 
 f.text_field :price, :class => 'text' 
 f.label :cost_price, t('shoppe.delivery_service_prices.cost_price') 
 Shoppe.settings.currency_unit.html_safe 
 f.text_field :cost_price, :class => 'text' 
 f.label :tax_rate_id, t('shoppe.delivery_service_prices.tax_rate') 
 f.collection_select :tax_rate_id, Shoppe::TaxRate.ordered, :id, :description,  t('shoppe.delivery_service_prices.countries') do 
 f.collection_select :country_ids, Shoppe::Country.ordered, :id, :name, t('shoppe.delivery_service_prices.help.countries') 
 end 
 unless @delivery_service_price.new_record? 
 link_to t('shoppe.delete'), [@delivery_service, @delivery_service_price], :class => 'button purple', :method => :delete, :data => {:confirm => "Are you sure you wish to remove this price?"} 
 end 
 f.submit t('shoppe.submit'), :class => 'button green' 
 link_to t('shoppe.cancel'), [@delivery_service, :delivery_service_prices], :class => 'button' 
 end 
end
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
    end

    def update
      if @delivery_service_price.update(safe_params)
        redirect_to [@delivery_service, :delivery_service_prices], notice: t('shoppe.delivery_service_prices.update_notice')
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
 link_to t('shoppe.delivery_service_prices.back'), [@delivery_service, :delivery_service_prices], :class => 'button' 
 t('shoppe.delivery_service_prices.delivery_services') 
 display_flash 
 @page_title = t('shoppe.delivery_service_prices.delivery_services') 
  
  form_for [@delivery_service, @delivery_service_price] do |f| 
 f.error_messages 
 field_set_tag t('shoppe.delivery_service_prices.identification_weight')  do 
 f.label :code, t('shoppe.delivery_service_prices.code') 
 f.text_field :code, :class => 'focus text' 
 f.label :min_weight, t('shoppe.delivery_service_prices.min_weight') 
 f.text_field :min_weight, :class => 'text' 
 f.label :max_weight, t('shoppe.delivery_service_prices.max_weight') 
 f.text_field :max_weight, :class => 'text' 
 end 
 field_set_tag t('shoppe.delivery_service_prices.pricing') do 
 f.label :price, t('shoppe.delivery_service_prices.price') 
 Shoppe.settings.currency_unit.html_safe 
 f.text_field :price, :class => 'text' 
 f.label :cost_price, t('shoppe.delivery_service_prices.cost_price') 
 Shoppe.settings.currency_unit.html_safe 
 f.text_field :cost_price, :class => 'text' 
 f.label :tax_rate_id, t('shoppe.delivery_service_prices.tax_rate') 
 f.collection_select :tax_rate_id, Shoppe::TaxRate.ordered, :id, :description,  t('shoppe.delivery_service_prices.countries') do 
 f.collection_select :country_ids, Shoppe::Country.ordered, :id, :name, t('shoppe.delivery_service_prices.help.countries') 
 end 
 unless @delivery_service_price.new_record? 
 link_to t('shoppe.delete'), [@delivery_service, @delivery_service_price], :class => 'button purple', :method => :delete, :data => {:confirm => "Are you sure you wish to remove this price?"} 
 end 
 f.submit t('shoppe.submit'), :class => 'button green' 
 link_to t('shoppe.cancel'), [@delivery_service, :delivery_service_prices], :class => 'button' 
 end 
end
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
    end

    def destroy
      @delivery_service_price.destroy
      redirect_to [@delivery_service, :delivery_service_prices], notice: t('shoppe.delivery_service_prices.destroy_notice')
    end

    private

    def safe_params
      params[:delivery_service_price].permit(:price, :cost_price, :tax_rate_id, :min_weight, :max_weight, :code, country_ids: [])
    end
  end
end
