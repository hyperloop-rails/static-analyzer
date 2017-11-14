module Shoppe
  class CustomersController < Shoppe::ApplicationController
    before_filter { @active_nav = :customers }
    before_filter { params[:id] && @customer = Shoppe::Customer.find(params[:id]) }

    def index
      @query = Shoppe::Customer.ordered.page(params[:page]).search(params[:q])
      @customers = @query.result
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
 link_to t('shoppe.customers.new_customer'), :new_customer, class: 'button green' 
 link_to t('shoppe.customers.search_customer'), '#', class: 'button', rel: 'searchCustomers' 
 t('shoppe.customers.customers') 
 display_flash 
 @page_title = t('shoppe.customers.customers') 
  
  (action_name == 'search' ? 'display:block' : '') 
 search_form_for @query, url: search_customers_path, html: { method: :post } do |f| 
 f.label :first_name_or_last_name_or_company_cont, t('shoppe.customers.first_or_last_name') 
 f.text_field :first_name_or_last_name_or_company_cont 
 f.label :company_cont, t('shoppe.customers.company') 
 f.text_field :company_cont 
 f.label :email_cont, t('shoppe.customers.email') 
 f.text_field :email_cont 
 f.label :phone_cont, t('shoppe.customers.phone') 
 f.text_field :phone_cont 
 f.submit t('shoppe.customers.search'), class: 'button green button' 
 end 
 
 t('shoppe.customers.name') 
 t('shoppe.customers.company') 
 t('shoppe.customers.email') 
 t('shoppe.customers.phone') 
 t('shoppe.customers.mobile_phone') 
 if @customers.empty? 
 t('shoppe.customers.no_customers') 
 else 
 for customer in @customers 
 link_to customer.full_name, customer 
 link_to customer.company, customer 
 customer.email 
 customer.phone 
 customer.mobile 
 end 
 end 
 paginate @customers 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def new
      @customer = Shoppe::Customer.new
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
 link_to t('shoppe.customers.back_to_customers_list'), :customers, class: 'button' 
 t('shoppe.customers.customers') 
 display_flash 
 @page_title = t('shoppe.customers.customers') 
  
  form_for @customer do |f| 
 f.error_messages 
 field_set_tag t('shoppe.customers.customer_information') do 
 f.label :first_name, t('shoppe.customers.first_name') 
 f.text_field :first_name, class: 'text focus' 
 f.label :last_name, t('shoppe.customers.last_name') 
 f.text_field :last_name, class: 'text' 
 f.label :company, t('shoppe.customers.company') 
 f.text_field :company, class: 'text' 
 f.label :email, t('shoppe.customers.email') 
 f.text_field :email, class: 'text' 
 f.label :phone, t('shoppe.customers.phone') 
 f.text_field :phone, class: 'text' 
 f.label :mobile, t('shoppe.customers.mobile_phone') 
 f.text_field :mobile, class: 'text' 
 end 
 unless @customer.new_record? 
 link_to t('shoppe.customers.delete'),                  @customer,                  class: 'button purple',                  method: :delete,                  data: {confirm: t('shoppe.customers.delete_confirmation')} 
 end 
 f.submit t('shoppe.customers.save'),               class: 'button green',               data: {disable_with: (@customer.new_record? ? t('shoppe.customers.creating_customer') : t('shoppe.customers.updating_customer'))} 
 link_to t('shoppe.customers.cancel'), :customers, class: 'button' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def show
      @addresses = @customer.addresses.ordered.load
      @orders = @customer.orders.ordered.load
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
 link_to t('shoppe.customers.new_address'), [:new, @customer, :address], class: 'button' 
 link_to t('shoppe.customers.edit'), [:edit, @customer], class: 'button' 
 t('shoppe.customers.customers') + "- #{@customer.name}" 
 display_flash 
 @page_title = t('shoppe.customers.customers') + " - #{@customer.name}" 
  
 t('shoppe.customers.name') 
 @customer.full_name 
 t('shoppe.customers.company') 
 @customer.company.blank? ? '-' : @customer.company 
 t('shoppe.customers.email') 
 mail_to @customer.email 
 t('shoppe.customers.phone') 
 @customer.phone 
 t('shoppe.customers.mobile_phone') 
 @customer.mobile 
 field_set_tag t('shoppe.customers.addresses'), class: 'padded' do 
  t('shoppe.customers.type') 
 t('shoppe.customers.default') 
 t('shoppe.custoemrs.address') 
 if @addresses.empty? 
 t('shoppe.customers.no_addresses') 
 else 
 for address in @addresses 
 address.address_type.capitalize 
 boolean_tag address.default 
 address.full_address 
 link_to t('shoppe.customers.edit'), edit_customer_address_path(@customer, address) 
 end 
 end 
 
 end 
 field_set_tag t('shoppe.orders.orders'), class: 'padded' do 
 t('shoppe.orders.number') 
 t('shoppe.orders.status') 
 t('shoppe.orders.products') 
 t('shoppe.orders.total') 
 t('shoppe.orders.payment') 
 if @orders.empty? 
 t('shoppe.orders.no_orders') 
 else 
 for order in @orders 
 link_to order.number, order 
 status_tag order.status 
 for item in order.order_items 
 end 
 number_to_currency order.total 
 boolean_tag order.paid_in_full?, nil, true_text: number_to_currency(order.amount_paid), false_text: number_to_currency(order.amount_paid) 
 end 
 end 
 end 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def create
      @customer = Shoppe::Customer.new(safe_params)
      if @customer.save
        redirect_to @customer, flash: { notice: t('shoppe.customers.created_successfully') }
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
 link_to t('shoppe.customers.back_to_customers_list'), :customers, class: 'button' 
 t('shoppe.customers.customers') 
 display_flash 
 @page_title = t('shoppe.customers.customers') 
  
  form_for @customer do |f| 
 f.error_messages 
 field_set_tag t('shoppe.customers.customer_information') do 
 f.label :first_name, t('shoppe.customers.first_name') 
 f.text_field :first_name, class: 'text focus' 
 f.label :last_name, t('shoppe.customers.last_name') 
 f.text_field :last_name, class: 'text' 
 f.label :company, t('shoppe.customers.company') 
 f.text_field :company, class: 'text' 
 f.label :email, t('shoppe.customers.email') 
 f.text_field :email, class: 'text' 
 f.label :phone, t('shoppe.customers.phone') 
 f.text_field :phone, class: 'text' 
 f.label :mobile, t('shoppe.customers.mobile_phone') 
 f.text_field :mobile, class: 'text' 
 end 
 unless @customer.new_record? 
 link_to t('shoppe.customers.delete'),                  @customer,                  class: 'button purple',                  method: :delete,                  data: {confirm: t('shoppe.customers.delete_confirmation')} 
 end 
 f.submit t('shoppe.customers.save'),               class: 'button green',               data: {disable_with: (@customer.new_record? ? t('shoppe.customers.creating_customer') : t('shoppe.customers.updating_customer'))} 
 link_to t('shoppe.customers.cancel'), :customers, class: 'button' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
    end

    def update
      if @customer.update(safe_params)
        redirect_to @customer, flash: { notice: t('shoppe.customers.updated_successfully') }
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
 link_to t('shoppe.customers.back_to_customers_list'), :customers, class: 'button' 
 t('shoppe.customers.customers') 
 display_flash 
 @page_title = t('shoppe.customers.customers') 
  
  form_for @customer do |f| 
 f.error_messages 
 field_set_tag t('shoppe.customers.customer_information') do 
 f.label :first_name, t('shoppe.customers.first_name') 
 f.text_field :first_name, class: 'text focus' 
 f.label :last_name, t('shoppe.customers.last_name') 
 f.text_field :last_name, class: 'text' 
 f.label :company, t('shoppe.customers.company') 
 f.text_field :company, class: 'text' 
 f.label :email, t('shoppe.customers.email') 
 f.text_field :email, class: 'text' 
 f.label :phone, t('shoppe.customers.phone') 
 f.text_field :phone, class: 'text' 
 f.label :mobile, t('shoppe.customers.mobile_phone') 
 f.text_field :mobile, class: 'text' 
 end 
 unless @customer.new_record? 
 link_to t('shoppe.customers.delete'),                  @customer,                  class: 'button purple',                  method: :delete,                  data: {confirm: t('shoppe.customers.delete_confirmation')} 
 end 
 f.submit t('shoppe.customers.save'),               class: 'button green',               data: {disable_with: (@customer.new_record? ? t('shoppe.customers.creating_customer') : t('shoppe.customers.updating_customer'))} 
 link_to t('shoppe.customers.cancel'), :customers, class: 'button' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
    end

    def destroy
      @customer.destroy
      redirect_to customers_path, flash: { notice: t('shoppe.customers.deleted_successfully') }
    end

    def search
      index
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
 link_to t('shoppe.customers.new_customer'), :new_customer, class: 'button green' 
 link_to t('shoppe.customers.search_customer'), '#', class: 'button', rel: 'searchCustomers' 
 t('shoppe.customers.customers') 
 display_flash 
 @page_title = t('shoppe.customers.customers') 
  
  (action_name == 'search' ? 'display:block' : '') 
 search_form_for @query, url: search_customers_path, html: { method: :post } do |f| 
 f.label :first_name_or_last_name_or_company_cont, t('shoppe.customers.first_or_last_name') 
 f.text_field :first_name_or_last_name_or_company_cont 
 f.label :company_cont, t('shoppe.customers.company') 
 f.text_field :company_cont 
 f.label :email_cont, t('shoppe.customers.email') 
 f.text_field :email_cont 
 f.label :phone_cont, t('shoppe.customers.phone') 
 f.text_field :phone_cont 
 f.submit t('shoppe.customers.search'), class: 'button green button' 
 end 
 
 t('shoppe.customers.name') 
 t('shoppe.customers.company') 
 t('shoppe.customers.email') 
 t('shoppe.customers.phone') 
 t('shoppe.customers.mobile_phone') 
 if @customers.empty? 
 t('shoppe.customers.no_customers') 
 else 
 for customer in @customers 
 link_to customer.full_name, customer 
 link_to customer.company, customer 
 customer.email 
 customer.phone 
 customer.mobile 
 end 
 end 
 paginate @customers 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    private

    def safe_params
      params[:customer].permit(:first_name, :last_name, :company, :email, :phone, :mobile)
    end
  end
end
