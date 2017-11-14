module Shoppe
  class DeliveryServicesController < Shoppe::ApplicationController
    before_filter { @active_nav = :delivery_services }
    before_filter { params[:id] && @delivery_service = Shoppe::DeliveryService.find(params[:id]) }

    def index
      @delivery_services = Shoppe::DeliveryService.all
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
 link_to t('shoppe.delivery_services.new'), :new_delivery_service, class: 'button green' 
 t('shoppe.delivery_services.delivery_services') 
 display_flash 
 @page_title = t('shoppe.delivery_services.delivery_services') 
  
 t('shoppe.delivery_services.name') 
 t('shoppe.delivery_services.prices') 
 t('shoppe.delivery_services.courier') 
 t('shoppe.delivery_services.active?') 
 t('shoppe.delivery_services.default?') 
 if @delivery_services.empty? 
 t('shoppe.delivery_services.no_services') 
 else 
 for delivery_service in @delivery_services 
 link_to delivery_service.name, [:edit, delivery_service] 
 link_to t('shoppe.delivery_services.set_prices'), [delivery_service, :delivery_service_prices] 
 delivery_service.courier 
 boolean_tag delivery_service.active? 
 boolean_tag delivery_service.default? 
 end 
 end 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def new
      @delivery_service = Shoppe::DeliveryService.new
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
 link_to t('shoppe.delivery_services.back'), :delivery_services, class: 'button' 
 t('shoppe.delivery_services.delivery_services') 
 display_flash 
 @page_title = t('shoppe.delivery_services.delivery_services') 
  
  form_for @delivery_service do |f| 
 f.error_messages 
 field_set_tag t('shoppe.delivery_services.details') do 
 f.label :name, t('shoppe.delivery_services.name') 
 f.text_field :name, class: 'focus text' 
 f.label :code, t('shoppe.delivery_services.code') 
 f.text_field :code, class: 'text' 
 f.label :active, t('shoppe.delivery_services.active') 
 f.check_box :active 
 f.label :active,  t('shoppe.delivery_services.active_info') 
 f.label :default, t('shoppe.delivery_services.default') 
 f.check_box :default 
 f.label :default,  t('shoppe.delivery_services.default_info') 
 end 
 field_set_tag  t('shoppe.delivery_services.courier') do 
 f.label :courier,  t('shoppe.delivery_services.courier_name') 
 f.text_field :courier, class: 'text' 
 f.label :tracking_url,  t('shoppe.delivery_services.tracking_url') 
 f.text_field :tracking_url, class: 'text' 
 t('shoppe.delivery_services.tracking_url_help_html') 
 end 
 unless @delivery_service.new_record? 
 link_to  t('shoppe.delete'), [@delivery_service], class: 'button purple', method: :delete, data: {confirm: t('shoppe.delivery_services.delete_confirmation')} 
 end 
 f.submit t('shoppe.submit'), class: 'button green' 
 link_to t('shoppe.cancel'), :delivery_services, class: 'button' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def create
      @delivery_service = Shoppe::DeliveryService.new(safe_params)
      if @delivery_service.save
        redirect_to :delivery_services, flash: { notice: t('shoppe.delivery_services.create_notice') }
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
 link_to t('shoppe.delivery_services.back'), :delivery_services, class: 'button' 
 t('shoppe.delivery_services.delivery_services') 
 display_flash 
 @page_title = t('shoppe.delivery_services.delivery_services') 
  
  form_for @delivery_service do |f| 
 f.error_messages 
 field_set_tag t('shoppe.delivery_services.details') do 
 f.label :name, t('shoppe.delivery_services.name') 
 f.text_field :name, class: 'focus text' 
 f.label :code, t('shoppe.delivery_services.code') 
 f.text_field :code, class: 'text' 
 f.label :active, t('shoppe.delivery_services.active') 
 f.check_box :active 
 f.label :active,  t('shoppe.delivery_services.active_info') 
 f.label :default, t('shoppe.delivery_services.default') 
 f.check_box :default 
 f.label :default,  t('shoppe.delivery_services.default_info') 
 end 
 field_set_tag  t('shoppe.delivery_services.courier') do 
 f.label :courier,  t('shoppe.delivery_services.courier_name') 
 f.text_field :courier, class: 'text' 
 f.label :tracking_url,  t('shoppe.delivery_services.tracking_url') 
 f.text_field :tracking_url, class: 'text' 
 t('shoppe.delivery_services.tracking_url_help_html') 
 end 
 unless @delivery_service.new_record? 
 link_to  t('shoppe.delete'), [@delivery_service], class: 'button purple', method: :delete, data: {confirm: t('shoppe.delivery_services.delete_confirmation')} 
 end 
 f.submit t('shoppe.submit'), class: 'button green' 
 link_to t('shoppe.cancel'), :delivery_services, class: 'button' 
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
 link_to t('shoppe.delivery_services.prices'), [@delivery_service, :delivery_service_prices], :class => 'button' 
 link_to t('shoppe.delivery_services.back'), :delivery_services, :class => 'button' 
 t('shoppe.delivery_services.delivery_services') 
 display_flash 
 @page_title = t('shoppe.delivery_services.delivery_services') 
  
  form_for @delivery_service do |f| 
 f.error_messages 
 field_set_tag t('shoppe.delivery_services.details') do 
 f.label :name, t('shoppe.delivery_services.name') 
 f.text_field :name, class: 'focus text' 
 f.label :code, t('shoppe.delivery_services.code') 
 f.text_field :code, class: 'text' 
 f.label :active, t('shoppe.delivery_services.active') 
 f.check_box :active 
 f.label :active,  t('shoppe.delivery_services.active_info') 
 f.label :default, t('shoppe.delivery_services.default') 
 f.check_box :default 
 f.label :default,  t('shoppe.delivery_services.default_info') 
 end 
 field_set_tag  t('shoppe.delivery_services.courier') do 
 f.label :courier,  t('shoppe.delivery_services.courier_name') 
 f.text_field :courier, class: 'text' 
 f.label :tracking_url,  t('shoppe.delivery_services.tracking_url') 
 f.text_field :tracking_url, class: 'text' 
 t('shoppe.delivery_services.tracking_url_help_html') 
 end 
 unless @delivery_service.new_record? 
 link_to  t('shoppe.delete'), [@delivery_service], class: 'button purple', method: :delete, data: {confirm: t('shoppe.delivery_services.delete_confirmation')} 
 end 
 f.submit t('shoppe.submit'), class: 'button green' 
 link_to t('shoppe.cancel'), :delivery_services, class: 'button' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def update
      if @delivery_service.update(safe_params)
        redirect_to [:edit, @delivery_service], flash: { notice: t('shoppe.delivery_services.update_notice') }
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
 link_to t('shoppe.delivery_services.prices'), [@delivery_service, :delivery_service_prices], :class => 'button' 
 link_to t('shoppe.delivery_services.back'), :delivery_services, :class => 'button' 
 t('shoppe.delivery_services.delivery_services') 
 display_flash 
 @page_title = t('shoppe.delivery_services.delivery_services') 
  
  form_for @delivery_service do |f| 
 f.error_messages 
 field_set_tag t('shoppe.delivery_services.details') do 
 f.label :name, t('shoppe.delivery_services.name') 
 f.text_field :name, class: 'focus text' 
 f.label :code, t('shoppe.delivery_services.code') 
 f.text_field :code, class: 'text' 
 f.label :active, t('shoppe.delivery_services.active') 
 f.check_box :active 
 f.label :active,  t('shoppe.delivery_services.active_info') 
 f.label :default, t('shoppe.delivery_services.default') 
 f.check_box :default 
 f.label :default,  t('shoppe.delivery_services.default_info') 
 end 
 field_set_tag  t('shoppe.delivery_services.courier') do 
 f.label :courier,  t('shoppe.delivery_services.courier_name') 
 f.text_field :courier, class: 'text' 
 f.label :tracking_url,  t('shoppe.delivery_services.tracking_url') 
 f.text_field :tracking_url, class: 'text' 
 t('shoppe.delivery_services.tracking_url_help_html') 
 end 
 unless @delivery_service.new_record? 
 link_to  t('shoppe.delete'), [@delivery_service], class: 'button purple', method: :delete, data: {confirm: t('shoppe.delivery_services.delete_confirmation')} 
 end 
 f.submit t('shoppe.submit'), class: 'button green' 
 link_to t('shoppe.cancel'), :delivery_services, class: 'button' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
    end

    def destroy
      @delivery_service.destroy
      redirect_to :delivery_services, flash: { notice: t('shoppe.delivery_services.destroy_notice') }
    end

    private

    def safe_params
      params[:delivery_service].permit(:name, :code, :active, :default, :courier, :tracking_url)
    end
  end
end
