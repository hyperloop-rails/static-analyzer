module Shoppe
  class OrdersController < Shoppe::ApplicationController
    before_filter { @active_nav = :orders }
    before_filter { params[:id] && @order = Shoppe::Order.find(params[:id]) }

    def index
      @query = Shoppe::Order.ordered.received.includes(order_items: :ordered_item).page(params[:page]).search(params[:q])
      @orders = @query.result
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
 link_to t('shoppe.orders.new_order'), :new_order, :class => 'button green' 
 link_to t('shoppe.orders.search_orders'), '#', :class => 'button', :rel => 'searchOrders' 
 t('shoppe.orders.orders') 
 page_entries_info @orders 
 display_flash 
 @page_title = t('shoppe.orders.orders') 
  
  (action_name == 'search' ? "display:block" : '') 
 search_form_for @query, :url => search_orders_path, :html => { :method => :post } do |f| 
 f.label :id_eq, t('shoppe.orders.order_number') 
 f.text_field :id_eq 
 f.label :first_name_or_last_name_or_company_cont, t('shoppe.orders.customer') 
 f.text_field :first_name_or_last_name_or_company_cont 
 f.label :address1_or_address2_or_address3_or_address4_or_postcode_cont, t('shoppe.orders.billing_address') 
 f.text_field :billing_address1_or_billing_address2_or_billing_address3_or_billing_address4_or_billing_postcode_cont 
 f.label :consignment_number_cont, t('shoppe.orders.consignment_number') 
 f.text_field :consignment_number_cont 
 f.label :received_at_eq, t('shoppe.orders.received_between') 
 f.text_field :received_at_gteq, :class => 'small' 
 f.text_field :received_at_lteq, :class => 'small' 
 f.label :email_address_cont, t('shoppe.orders.email_address') 
 f.text_field :email_address_cont 
 f.label :phone_number_cont, t('shoppe.orders.phone_number') 
 f.text_field :phone_number_cont 
 f.label :status_eq, t('shoppe.orders.status') 
 f.select :status_eq, [nil] + Shoppe::Order::STATUSES.map 
 f.submit  t('shoppe.orders.search'), :class => 'button green button' 
 end 
 
 t('shoppe.orders.number') 
 t('shoppe.orders.customer') 
 t('shoppe.orders.status') 
 t('shoppe.orders.products') 
 t('shoppe.orders.total') 
 t('shoppe.orders.payment') 
 if @orders.empty? 
 t('shoppe.orders.no_orders') 
 else 
 for order in @orders 
 link_to order.number, order 
 order.customer_name 
 status_tag order.status 
 for item in order.order_items 
 end 
 number_to_currency order.total 
 boolean_tag order.paid_in_full?, nil, :true_text => number_to_currency(order.amount_paid), :false_text => number_to_currency(order.amount_paid) 
 end 
 end 
 paginate @orders 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def new
      @order = Shoppe::Order.new
      @order.order_items.build(ordered_item_type: 'Shoppe::Product')
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
 link_to t('shoppe.orders.back_to_orders'), :orders, :class => 'button grey' 
 t('shoppe.orders.new_order') 
 display_flash 
 @page_title = t('shoppe.orders.new_order') 
  
 form_for @order, :html => {:class => 'orderForm newOrder'} do |f| 
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
 f.submit t('shoppe.orders.create_order'), :class => 'button green' 
 link_to t('shoppe.cancel'), :orders, :class => 'button grey' 
 end 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def create
      Shoppe::Order.transaction do
        @order = Shoppe::Order.new(safe_params)
        @order.status = 'confirming'

        if safe_params[:customer_id]
          @customer = Shoppe::Customer.find safe_params[:customer_id]
          @order.first_name = @customer.first_name
          @order.last_name = @customer.last_name
          @order.company = @customer.company
          @order.email_address = @customer.email
          @order.phone_number = @customer.phone
          if @customer.addresses.billing.present?
            billing = @customer.addresses.billing.first
            @order.billing_address1 = billing.address1
            @order.billing_address2 = billing.address2
            @order.billing_address3 = billing.address3
            @order.billing_address4 = billing.address4
            @order.billing_postcode = billing.postcode
            @order.billing_country_id = billing.country_id
          end
          if @customer.addresses.delivery.present?
            delivery = @customer.addresses.delivery.first
            @order.delivery_address1 = delivery.address1
            @order.delivery_address2 = delivery.address2
            @order.delivery_address3 = delivery.address3
            @order.delivery_address4 = delivery.address4
            @order.delivery_postcode = delivery.postcode
            @order.delivery_country_id = delivery.country_id
          end
        end

        if !request.xhr? && @order.save
          @order.confirm!
          redirect_to @order, flash: { notice: t('shoppe.orders.create_notice') }
        else
          @order.order_items.build(ordered_item_type: 'Shoppe::Product')
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
 link_to t('shoppe.orders.back_to_orders'), :orders, :class => 'button grey' 
 t('shoppe.orders.new_order') 
 display_flash 
 @page_title = t('shoppe.orders.new_order') 
  
 form_for @order, :html => {:class => 'orderForm newOrder'} do |f| 
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
 f.submit t('shoppe.orders.create_order'), :class => 'button green' 
 link_to t('shoppe.cancel'), :orders, :class => 'button grey' 
 end 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

        end
      end
    rescue Shoppe::Errors::InsufficientStockToFulfil => e
      flash.now[:alert] = t('shoppe.orders.insufficient_stock_order', out_of_stock_items: e.out_of_stock_items.map { |t| t.ordered_item.full_name }.to_sentence)
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
 link_to t('shoppe.orders.back_to_orders'), :orders, :class => 'button grey' 
 t('shoppe.orders.new_order') 
 display_flash 
 @page_title = t('shoppe.orders.new_order') 
  
 form_for @order, :html => {:class => 'orderForm newOrder'} do |f| 
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
 f.submit t('shoppe.orders.create_order'), :class => 'button green' 
 link_to t('shoppe.cancel'), :orders, :class => 'button grey' 
 end 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def show
      @payments = @order.payments.to_a
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
 link_to t('shoppe.edit'), [:edit, @order], :class => 'button' 
 if @order.accepted? 
 link_to t('shoppe.orders.despatch_note.despatch_note'), [:despatch_note, @order], :class => 'button', :rel => 'print' 
 end 
 link_to t('shoppe.orders.back_to_orders'), :orders, :class => 'button grey' 
 t('shoppe.orders.order_no_html', order_number: @order.number) 
 display_flash 
 @page_title = "#{t('shoppe.orders.order')} ##{@order.number}" 
  
 if @order.received? 
  t('shoppe.orders.name') 
 @order.full_name 
 t('shoppe.orders.company') 
 @order.company.blank? ? '-' : @order.company 
 if @order.separate_delivery_address? 
 t('shoppe.orders.billing_address') 
 else 
 t('shoppe.orders.billing_delivery_address') 
 end 
 @order.billing_address1 
 @order.billing_address2 
 @order.billing_address3 
 @order.billing_address4 
 @order.billing_postcode 
 @order.billing_country.try(:name) 
 if @order.separate_delivery_address? 
 t('shoppe.orders.delivery_address') 
 @order.delivery_name 
 @order.delivery_address1 
 @order.delivery_address2 
 @order.delivery_address3 
 @order.delivery_address4 
 @order.delivery_postcode 
 @order.delivery_country.try(:name) 
 end 
 t('shoppe.orders.email_address') 
 mail_to @order.email_address 
 t('shoppe.orders.telephone') 
 @order.phone_number 
 t('shoppe.orders.weight') 
 number_to_weight @order.total_weight 
 if @order.received? 
 t('shoppe.orders.build_time') 
 distance_of_time_in_words(@order.created_at, @order.received_at) 
 end 
 if @order.invoiced? 
 t('shoppe.orders.invoice_number') 
 @order.invoice_number 
 end 
 t('shoppe.orders.order_balance') 
 boolean_tag @order.paid_in_full?, nil, :true_text => number_to_currency(@order.balance), :false_text => number_to_currency(@order.balance) 
 if @order.accepted? && !@order.shipped? 
 form_tag [:ship, @order] do 
 label_tag 'consignment_number', t('shoppe.orders.consignment_number') 
 text_field_tag 'consignment_number', '', :class => 'text' 
 submit_tag t('shoppe.orders.mark_as_shipped') , :class => 'button green button-mini' 
 end 
 end 
 unless @order.accepted? || @order.rejected? 
 link_to t('shoppe.orders.accept'), [:accept, @order], :method => :post, :class => 'button green' 
 link_to t('shoppe.orders.reject'), [:reject, @order], :method => :post, :class => 'button purple' 
 end 
 
 else 
 t('shoppe.orders.in_progress_warning') 
 end 
 field_set_tag t('shoppe.orders.order_items'), :class => 'padded' do 
  t('shoppe.orders.qty') 
 t('shoppe.orders.item') 
 t('shoppe.orders.sku') 
 t('shoppe.orders.cost') 
 t('shoppe.orders.price') 
 Shoppe.settings.tax_name 
 t('shoppe.orders.sub_total') 
 for item in @order.order_items 
 item.quantity 
 item.ordered_item.full_name 
 item.ordered_item.sku 
 number_to_currency item.total_cost 
 number_to_currency item.sub_total 
 number_to_currency item.tax_amount 
 number_to_currency item.total 
 end 
 if @order.delivery_service 
 link_to @order.delivery_service.name, [:edit, @order.delivery_service] 
 number_to_currency @order.delivery_cost_price 
 number_to_currency @order.delivery_price 
 number_to_currency @order.delivery_tax_amount 
 number_to_currency @order.delivery_price + @order.delivery_tax_amount 
 end 
 @order.total_items 
 number_to_currency @order.total_cost 
 number_to_currency @order.total_before_tax 
 number_to_currency @order.tax 
 number_to_currency @order.total 
 
 end 
 if @order.received? 
 field_set_tag t('shoppe.orders.payments'), :class => 'padded orderPayments' do 
  unless @payments.empty? 
 t('shoppe.orders.id') 
 t('shoppe.orders.type') 
 t('shoppe.orders.method') 
 t('shoppe.orders.reference') 
 t('shoppe.orders.amount') 
 t('shoppe.orders.refunded?') 
 for payment in @payments 
 payment.id 
 (payment.refund? ? t('shoppe.orders.refund') : t('shoppe.orders.payment')) 
 boolean_tag payment.confirmed? 
 payment.method 
 link_to_if payment.transaction_url, payment.reference, payment.transaction_url 
 if payment.refund? 
 number_to_currency payment.amount 
 if payment.parent_payment_id 
 else 
 number_to_currency payment.amount 
 boolean_tag payment.refunded?, nil, :true_text => number_to_currency(payment.amount_refunded) 
 end 
 if payment.refundable? 
 link_to t('shoppe.orders.refund'), [:refund, @order, payment], :class => 'button purple button-mini', :rel => 'dialog' 
 else 
 link_to t('shoppe.delete'), [@order, payment], :class => 'button purple button-mini', :data => {:confirm => t('shoppe.orders.payment_remove_confirmation') }, :method => :delete 
 end 
 end 
 t('shoppe.orders.no_payments') 
end
end
 
 end 
 end 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def update
      @order.attributes = safe_params
      if !request.xhr? && @order.update_attributes(safe_params)
        redirect_to @order, flash: { notice: t('shoppe.orders.update_notice') }
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
 link_to t('shoppe.orders.back_to_order'), @order, :class => 'button grey' 
 display_flash 
 @page_title = "#{t('shoppe.orders.edit_order')} ##{@order.number}" 
  
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
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
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
 link_to t('shoppe.orders.new_order'), :new_order, :class => 'button green' 
 link_to t('shoppe.orders.search_orders'), '#', :class => 'button', :rel => 'searchOrders' 
 t('shoppe.orders.orders') 
 page_entries_info @orders 
 display_flash 
 @page_title = t('shoppe.orders.orders') 
  
  (action_name == 'search' ? "display:block" : '') 
 search_form_for @query, :url => search_orders_path, :html => { :method => :post } do |f| 
 f.label :id_eq, t('shoppe.orders.order_number') 
 f.text_field :id_eq 
 f.label :first_name_or_last_name_or_company_cont, t('shoppe.orders.customer') 
 f.text_field :first_name_or_last_name_or_company_cont 
 f.label :address1_or_address2_or_address3_or_address4_or_postcode_cont, t('shoppe.orders.billing_address') 
 f.text_field :billing_address1_or_billing_address2_or_billing_address3_or_billing_address4_or_billing_postcode_cont 
 f.label :consignment_number_cont, t('shoppe.orders.consignment_number') 
 f.text_field :consignment_number_cont 
 f.label :received_at_eq, t('shoppe.orders.received_between') 
 f.text_field :received_at_gteq, :class => 'small' 
 f.text_field :received_at_lteq, :class => 'small' 
 f.label :email_address_cont, t('shoppe.orders.email_address') 
 f.text_field :email_address_cont 
 f.label :phone_number_cont, t('shoppe.orders.phone_number') 
 f.text_field :phone_number_cont 
 f.label :status_eq, t('shoppe.orders.status') 
 f.select :status_eq, [nil] + Shoppe::Order::STATUSES.map 
 f.submit  t('shoppe.orders.search'), :class => 'button green button' 
 end 
 
 t('shoppe.orders.number') 
 t('shoppe.orders.customer') 
 t('shoppe.orders.status') 
 t('shoppe.orders.products') 
 t('shoppe.orders.total') 
 t('shoppe.orders.payment') 
 if @orders.empty? 
 t('shoppe.orders.no_orders') 
 else 
 for order in @orders 
 link_to order.number, order 
 order.customer_name 
 status_tag order.status 
 for item in order.order_items 
 end 
 number_to_currency order.total 
 boolean_tag order.paid_in_full?, nil, :true_text => number_to_currency(order.amount_paid), :false_text => number_to_currency(order.amount_paid) 
 end 
 end 
 paginate @orders 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def accept
      @order.accept!(current_user)
      redirect_to @order, flash: { notice: t('shoppe.orders.accept_notice') }
    rescue Shoppe::Errors::PaymentDeclined => e
      redirect_to @order, flash: { alert: e.message }
    end

    def reject
      @order.reject!(current_user)
      redirect_to @order, flash: { notice: t('shoppe.orders.reject_notice') }
    rescue Shoppe::Errors::PaymentDeclined => e
      redirect_to @order, flash: { alert: e.message }
    end

    def ship
      @order.ship!(params[:consignment_number], current_user)
      redirect_to @order, flash: { notice: t('shoppe.orders.ship_notice') }
    end

    def despatch_note
      render layout: 'shoppe/printable'
    end

    private

    def safe_params
      params[:order].permit(
        :customer_id,
        :first_name, :last_name, :company,
        :billing_address1, :billing_address2, :billing_address3, :billing_address4, :billing_postcode, :billing_country_id,
        :separate_delivery_address,
        :delivery_name, :delivery_address1, :delivery_address2, :delivery_address3, :delivery_address4, :delivery_postcode, :delivery_country_id,
        :delivery_price, :delivery_service_id, :delivery_tax_amount,
        :email_address, :phone_number,
        :notes,
        order_items_attributes: [:ordered_item_id, :ordered_item_type, :quantity, :unit_price, :tax_amount, :id, :weight]
      )
    end
  end
end
