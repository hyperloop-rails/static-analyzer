module Shoppe
  class TaxRatesController < Shoppe::ApplicationController
    before_filter { @active_nav = :tax_rates }
    before_filter { params[:id] && @tax_rate = Shoppe::TaxRate.find(params[:id]) }

    def index
      @tax_rates = Shoppe::TaxRate.ordered.all
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
 link_to t('shoppe.tax_rates.new_tax_rate'), :new_tax_rate, :class => 'button green' 
 t('shoppe.tax_rates.tax_rates') 
 display_flash 
 @page_title = t('shoppe.tax_rates.tax_rates') 
  
 t('shoppe.tax_rates.name') 
 t('shoppe.tax_rates.rate') 
 for tax_rate in @tax_rates 
 link_to tax_rate.name, [:edit, tax_rate] 
 tax_rate.rate 
 end 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def new
      @tax_rate = Shoppe::TaxRate.new
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
 link_to t('shoppe.tax_rates.back_to_tax_rates'), :tax_rates, :class => 'button grey' 
 t('shoppe.tax_rates.tax_rates') 
 display_flash 
 @page_title = t('shoppe.tax_rates.tax_rates') 
  
 form_for @tax_rate do |f| 
 f.error_messages 
 field_set_tag t('shoppe.tax_rates.rate_details') do 
 f.label :name, t('shoppe.tax_rates.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :rate, t('shoppe.tax_rates.rate') 
 f.text_field :rate, :class => 'text' 
 end 
 field_set_tag t('shoppe.tax_rates.country_restriction') do 
 f.select :address_type, Shoppe::TaxRate::ADDRESS_TYPES.map , :class => 'chosen-basic' 
 f.collection_select :country_ids, Shoppe::Country.ordered, :id, :name
 unless @tax_rate.new_record? 
 link_to t('shoppe.delete'), @tax_rate, :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.tax_rates.delete_confirmation') } 
 end 
 f.submit t('shoppe.submit'), :class => 'button green' 
 link_to t('shoppe.cancel'), :tax_rates, :class => 'button' 
 end 
 end 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def create
      @tax_rate = Shoppe::TaxRate.new(safe_params)
      if @tax_rate.save
        redirect_to :tax_rates, flash: { notice: t('shoppe.tax_rates.create_notice') }
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
 link_to t('shoppe.tax_rates.back_to_tax_rates'), :tax_rates, :class => 'button grey' 
 t('shoppe.tax_rates.tax_rates') 
 display_flash 
 @page_title = t('shoppe.tax_rates.tax_rates') 
  
 form_for @tax_rate do |f| 
 f.error_messages 
 field_set_tag t('shoppe.tax_rates.rate_details') do 
 f.label :name, t('shoppe.tax_rates.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :rate, t('shoppe.tax_rates.rate') 
 f.text_field :rate, :class => 'text' 
 end 
 field_set_tag t('shoppe.tax_rates.country_restriction') do 
 f.select :address_type, Shoppe::TaxRate::ADDRESS_TYPES.map , :class => 'chosen-basic' 
 f.collection_select :country_ids, Shoppe::Country.ordered, :id, :name
 unless @tax_rate.new_record? 
 link_to t('shoppe.delete'), @tax_rate, :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.tax_rates.delete_confirmation') } 
 end 
 f.submit t('shoppe.submit'), :class => 'button green' 
 link_to t('shoppe.cancel'), :tax_rates, :class => 'button' 
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
 link_to t('shoppe.tax_rates.back_to_tax_rates'), :tax_rates, :class => 'button grey' 
 t('shoppe.tax_rates.tax_rates') 
 display_flash 
 @page_title = t('shoppe.tax_rates.tax_rates') 
  
 form_for @tax_rate do |f| 
 f.error_messages 
 field_set_tag t('shoppe.tax_rates.rate_details') do 
 f.label :name, t('shoppe.tax_rates.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :rate, t('shoppe.tax_rates.rate') 
 f.text_field :rate, :class => 'text' 
 end 
 field_set_tag t('shoppe.tax_rates.country_restriction') do 
 f.select :address_type, Shoppe::TaxRate::ADDRESS_TYPES.map , :class => 'chosen-basic' 
 f.collection_select :country_ids, Shoppe::Country.ordered, :id, :name
 unless @tax_rate.new_record? 
 link_to t('shoppe.delete'), @tax_rate, :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.tax_rates.delete_confirmation') } 
 end 
 f.submit t('shoppe.submit'), :class => 'button green' 
 link_to t('shoppe.cancel'), :tax_rates, :class => 'button' 
 end 
 end 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end
end

    def update
      if @tax_rate.update(safe_params)
        redirect_to [:edit, @tax_rate], flash: { notice: t('shoppe.tax_rates.update_notice') }
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
 link_to t('shoppe.tax_rates.back_to_tax_rates'), :tax_rates, :class => 'button grey' 
 t('shoppe.tax_rates.tax_rates') 
 display_flash 
 @page_title = t('shoppe.tax_rates.tax_rates') 
  
 form_for @tax_rate do |f| 
 f.error_messages 
 field_set_tag t('shoppe.tax_rates.rate_details') do 
 f.label :name, t('shoppe.tax_rates.name') 
 f.text_field :name, :class => 'focus text' 
 f.label :rate, t('shoppe.tax_rates.rate') 
 f.text_field :rate, :class => 'text' 
 end 
 field_set_tag t('shoppe.tax_rates.country_restriction') do 
 f.select :address_type, Shoppe::TaxRate::ADDRESS_TYPES.map , :class => 'chosen-basic' 
 f.collection_select :country_ids, Shoppe::Country.ordered, :id, :name
 unless @tax_rate.new_record? 
 link_to t('shoppe.delete'), @tax_rate, :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.tax_rates.delete_confirmation') } 
 end 
 f.submit t('shoppe.submit'), :class => 'button green' 
 link_to t('shoppe.cancel'), :tax_rates, :class => 'button' 
 end 
 end 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
    end

    def destroy
      @tax_rate.destroy
      redirect_to :tax_rates, flash: { notice: t('shoppe.tax_rates.destroy_notice') }
    end

    private

    def safe_params
      params[:tax_rate].permit(:name, :rate, :address_type, country_ids: [])
    end
  end
end
