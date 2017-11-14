module Shoppe
  class AddressesController < Shoppe::ApplicationController
    before_filter { @active_nav = :customers }
    before_filter { params[:customer_id] && @customer = Shoppe::Customer.find(params[:customer_id]) }
    before_filter { params[:id] && @address = @customer.addresses.find(params[:id]) }

    def new
      @address = Shoppe::Address.new
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
 link_to 'Back to customer', @customer, class: 'button' 
 display_flash 
 @page_title = "New Address for #{@customer.name}" 
  
  form_for @address, url: [@customer, @address] do |f| 
 f.error_messages 
 field_set_tag 'Address Information' do 
 f.label :address_type 
 f.select :address_type, Shoppe::Address::TYPES, {}, class: 'chosen' 
 f.label :address1 
 f.text_field :address1, class: 'text' 
 f.label :address2 
 f.text_field :address2, class: 'text' 
 f.label :address3 
 f.text_field :address3, class: 'text' 
 f.label :address4 
 f.text_field :address4, class: 'text' 
 f.label :postcode 
 f.text_field :postcode, class: 'text' 
 f.label :country_id 
 f.collection_select :country_id, Shoppe::Country.ordered, :id, :name
 unless @address.new_record? 
 link_to t('shoppe.delete'), [@customer, @address], class: 'button purple', method: :delete, data: {confirm: 'Are you sure you wish to remove this address?'} 
 end 
 f.submit class: 'button green', data: {disable_with: (@address.new_record? ? 'Creating Address...' : 'Updating Address...')} 
 link_to t('shoppe.cancel'), :customers, class: 'button' 
 end 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

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
 link_to 'Back to customer', @customer, :class => 'button' 
 display_flash 
 @page_title = 'Edit Address' 
  
  form_for @address, url: [@customer, @address] do |f| 
 f.error_messages 
 field_set_tag 'Address Information' do 
 f.label :address_type 
 f.select :address_type, Shoppe::Address::TYPES, {}, class: 'chosen' 
 f.label :address1 
 f.text_field :address1, class: 'text' 
 f.label :address2 
 f.text_field :address2, class: 'text' 
 f.label :address3 
 f.text_field :address3, class: 'text' 
 f.label :address4 
 f.text_field :address4, class: 'text' 
 f.label :postcode 
 f.text_field :postcode, class: 'text' 
 f.label :country_id 
 f.collection_select :country_id, Shoppe::Country.ordered, :id, :name
 unless @address.new_record? 
 link_to t('shoppe.delete'), [@customer, @address], class: 'button purple', method: :delete, data: {confirm: 'Are you sure you wish to remove this address?'} 
 end 
 f.submit class: 'button green', data: {disable_with: (@address.new_record? ? 'Creating Address...' : 'Updating Address...')} 
 link_to t('shoppe.cancel'), :customers, class: 'button' 
 end 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def create
      @address = @customer.addresses.build(safe_params)

      @address.default = true if @customer.addresses.count == 0

      if @customer.save
        redirect_to @customer, flash: { notice: t('shoppe.addresses.created_successfully') }
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
 link_to 'Back to customer', @customer, class: 'button' 
 display_flash 
 @page_title = "New Address for #{@customer.name}" 
  
  form_for @address, url: [@customer, @address] do |f| 
 f.error_messages 
 field_set_tag 'Address Information' do 
 f.label :address_type 
 f.select :address_type, Shoppe::Address::TYPES, {}, class: 'chosen' 
 f.label :address1 
 f.text_field :address1, class: 'text' 
 f.label :address2 
 f.text_field :address2, class: 'text' 
 f.label :address3 
 f.text_field :address3, class: 'text' 
 f.label :address4 
 f.text_field :address4, class: 'text' 
 f.label :postcode 
 f.text_field :postcode, class: 'text' 
 f.label :country_id 
 f.collection_select :country_id, Shoppe::Country.ordered, :id, :name
 unless @address.new_record? 
 link_to t('shoppe.delete'), [@customer, @address], class: 'button purple', method: :delete, data: {confirm: 'Are you sure you wish to remove this address?'} 
 end 
 f.submit class: 'button green', data: {disable_with: (@address.new_record? ? 'Creating Address...' : 'Updating Address...')} 
 link_to t('shoppe.cancel'), :customers, class: 'button' 
 end 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
    end

    def update
      if @address.update(safe_params)
        redirect_to @customer, flash: { notice: t('shoppe.addresses.updated_successfully') }
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
 link_to 'Back to customer', @customer, :class => 'button' 
 display_flash 
 @page_title = 'Edit Address' 
  
  form_for @address, url: [@customer, @address] do |f| 
 f.error_messages 
 field_set_tag 'Address Information' do 
 f.label :address_type 
 f.select :address_type, Shoppe::Address::TYPES, {}, class: 'chosen' 
 f.label :address1 
 f.text_field :address1, class: 'text' 
 f.label :address2 
 f.text_field :address2, class: 'text' 
 f.label :address3 
 f.text_field :address3, class: 'text' 
 f.label :address4 
 f.text_field :address4, class: 'text' 
 f.label :postcode 
 f.text_field :postcode, class: 'text' 
 f.label :country_id 
 f.collection_select :country_id, Shoppe::Country.ordered, :id, :name
 unless @address.new_record? 
 link_to t('shoppe.delete'), [@customer, @address], class: 'button purple', method: :delete, data: {confirm: 'Are you sure you wish to remove this address?'} 
 end 
 f.submit class: 'button green', data: {disable_with: (@address.new_record? ? 'Creating Address...' : 'Updating Address...')} 
 link_to t('shoppe.cancel'), :customers, class: 'button' 
 end 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
    end

    def destroy
      @address.destroy
      redirect_to @customer, flash: { notice: t('shoppe.addresses.deleted_successfully') }
    end

    private

    def safe_params
      params[:address].permit(:address_type, :address1, :address2, :address3, :address4, :postcode, :country_id)
    end
  end
end
