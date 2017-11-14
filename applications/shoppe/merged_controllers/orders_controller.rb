class OrdersController < ApplicationController
  
  before_filter(:except => :status) { redirect_to root_path unless has_order? }
  
  def status
    @order = Shoppe::Order.find_by_token!(params[:token])
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
 @page_title = "Order Status ##{@order.number} " 
 @order.first_name + ' ' + @order.last_name 
 @order.company.blank? ? '-' : @order.company 
 @order.delivery_address1 
 @order.delivery_address2 
 @order.delivery_address3 
 @order.delivery_address4 
 @order.delivery_postcode 
 @order.delivery_country.try(:id) 
 @order.number 
 @order.email_address 
 @order.phone_number 
 if @order.received? 
 end 
 if @order.paid? 
 end 
 if @order.accepted? 
 elsif @order.rejected? 
 end 
 if @order.shipped? 
 if @order.courier_tracking_url 
 link_to "Track the delivery", @order.courier_tracking_url 
 else 
 end 
 end 
  Shoppe.settings.tax_name 
 for item in order.order_items 
 unless defined?(readonly) 
 link_to "+", adjust_basket_item_quantity_path(item.id), :method => :post, :class => 'ajax' 
 link_to "-", adjust_basket_item_quantity_path(item.id), :method => :delete, :class => 'ajax' 
 end 
 item.quantity 
 item.ordered_item.full_name 
 unless defined?(readonly) 
 link_to "Delete", remove_basket_item_path(item), :method => :delete, :class => 'delete ajax' 
 end 
 number_to_currency item.sub_total 
 number_to_currency item.tax_amount 
 number_to_currency item.total 
 end 
 if order.delivery_service 
 if defined?(readonly) 
 order.delivery_service.name 
 else 
 form_tag change_delivery_service_path do 
 select_tag 'delivery_service', options_from_collection_for_select(order.available_delivery_services, :id, :name, order.delivery_service.id) 
 end 
 end 
 number_to_currency order.delivery_price 
 end 
 number_to_currency order.total_before_tax 
 Shoppe.settings.tax_name 
 number_to_currency order.tax 
 number_to_currency order.total 
 
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
  
  def destroy
    current_order.destroy
    session[:order_id] = nil
    respond_to do |wants|
      wants.html { redirect_to root_path, :notice => "Your basket has been emptied successfully."}
      wants.json do
        flash[:notice] = "Your shopping bag is now empty."
        render :json => {:status => 'complete', :redirect => root_path}
      end
    end
  end
  
  def remove_item
    item = current_order.order_items.find(params[:order_item_id])
    if current_order.order_items.count == 1
      destroy
    else
      item.remove
      respond_to do |wants|
        wants.html { redirect_to request.referer, :notice => "Item has been removed from your basket successfully"}
        wants.json do
          current_order.reload
          render :json => {:status => 'complete', :items => render_to_string(:partial => 'shared/order_items.html', :locals => {:order => current_order})}
        end
      end
    end
  end
  
  def change_item_quantity
    item = current_order.order_items.find(params[:order_item_id])
    request.delete? ? item.decrease! : item.increase!
    respond_to do |wants|
      wants.html { redirect_to request.referer || root_path, :notice => "Quantity has been updated successfully." }
      wants.json do
        current_order.reload
        if current_order.empty?
          destroy
        else
          render :json => {:status => 'complete', :items => render_to_string(:partial => 'shared/order_items.html', :locals => {:order => current_order})}
        end
      end
    end    
  rescue Shoppe::Errors::NotEnoughStock => e
    respond_to do |wants|
      wants.html { redirect_to request.referer, :alert => "Unfortunately, we don't have enough stock. We only have #{e.available_stock} items available at the moment. Please get in touch though, we're always receiving new stock." }
      wants.json { render :json => {:status => 'error', :message => "Unfortunateley, we don't have enough stock to add more items."} }
    end
  end

  def change_delivery_service
    if current_order.delivery_service = current_order.available_delivery_services.select { |s| s.id == params[:delivery_service].to_i}.first
      current_order.save
      respond_to do |wants|
        wants.html { redirect_to request.referer, :notice => "Delivery service has been changed"}
        wants.json do
          current_order.reload
          render :json => {:status => 'complete', :items => render_to_string(:partial => 'shared/order_items.html', :locals => {:order => current_order})}
        end
      end
    else
      respond_to do |wants|
        wants.html { redirect_to request.referer, :alert => "You cannot select this delivery method."}
        wants.json { render :json => {:status => 'error', :message => 'InvalidDeliveryMethod'}, :status => 422 }
      end
    end
  end
  
  def checkout
    @order = Shoppe::Order.find(current_order.id)
    
    
    if request.patch?
      @order.attributes = params[:order].permit(:first_name, :last_name, :company, :billing_address1, :billing_address2, :billing_address3, :billing_address4, :billing_country_id, :billing_postcode, :email_address, :phone_number, :delivery_name, :delivery_address1, :delivery_address2, :delivery_address3, :delivery_address4, :delivery_postcode, :delivery_country_id, :separate_delivery_address)
      @order.ip_address = request.ip
      if @order.proceed_to_confirm
        redirect_to checkout_payment_path
      end
    else
      # Add some example order data for the example. In a real application
      # this shouldn't be present.
      Faker::Config.locale = 'en-GB'
      @order.first_name = Faker::Name.first_name                                            if @order.first_name.blank?
      @order.last_name = Faker::Name.last_name                                              if @order.last_name.blank?
      @order.company = Faker::Company.name                                                  if @order.company.blank?
      @order.email_address = Faker::Internet.email                                          if @order.email_address.blank?
      @order.phone_number = Faker::PhoneNumber.phone_number                                 if @order.phone_number.blank?
      @order.billing_address1 = Faker::Address.building_number + " " + Faker::Address.street_name   if @order.billing_address1.blank?
      @order.billing_address3 = Faker::Address.city                                                 if @order.billing_address3.blank?
      @order.billing_address4 = Faker::Address.country                                               if @order.billing_address4.blank?
      @order.billing_postcode = Faker::Address.zip                                                  if @order.billing_postcode.blank?
    end
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
  
 else 
  if has_order? && current_order.has_items? 
 link_to "View my bag", basket_path 
 link_to "Checkout", checkout_path, :class => 'checkout' 
 else 
 end 
 
 end 
 @page_title = 'Checkout' 
   
 
  Shoppe.settings.tax_name 
 for item in order.order_items 
 unless defined?(readonly) 
 link_to "+", adjust_basket_item_quantity_path(item.id), :method => :post, :class => 'ajax' 
 link_to "-", adjust_basket_item_quantity_path(item.id), :method => :delete, :class => 'ajax' 
 end 
 item.quantity 
 item.ordered_item.full_name 
 unless defined?(readonly) 
 link_to "Delete", remove_basket_item_path(item), :method => :delete, :class => 'delete ajax' 
 end 
 number_to_currency item.sub_total 
 number_to_currency item.tax_amount 
 number_to_currency item.total 
 end 
 if order.delivery_service 
 if defined?(readonly) 
 order.delivery_service.name 
 else 
 form_tag change_delivery_service_path do 
 select_tag 'delivery_service', options_from_collection_for_select(order.available_delivery_services, :id, :name, order.delivery_service.id) 
 end 
 end 
 number_to_currency order.delivery_price 
 end 
 number_to_currency order.total_before_tax 
 Shoppe.settings.tax_name 
 number_to_currency order.tax 
 number_to_currency order.total 
 
 unless @order.delivery_required? && @order.delivery_service.nil? 
 form_for @order, :url => checkout_path, :html => {:class => 'checkout disableable'} do |f| 
 f.error_messages 
 field_set_tag do 
 f.label :first_name, "Name", :class => 'req' 
 f.text_field :first_name, :placeholder => 'First Name' 
 f.text_field :last_name, :placeholder => 'Last Name' 
 f.label :company, "Company Name (optional)" 
 f.text_field :company 
 f.label :email_address, 'Your E-Mail Address', :class => 'req' 
 f.text_field :email_address 
 f.label :phone_number, 'Your Contact Phone Number', :class => 'req' 
 f.text_field :phone_number 
 end 
 field_set_tag do 
 f.label :billing_address1, "Billing Address", :class => 'req' 
 f.text_field :billing_address1, :placeholder => "Line 1" 
 f.text_field :billing_address3, :placeholder => "Town/City" 
 f.text_field :billing_address4, :placeholder => "County" 
 f.text_field :billing_postcode, :placeholder => "Postcode", :class => 'postcode' 
 f.collection_select :billing_country_id, Shoppe::Country.ordered, :id, :name 
 f.check_box :separate_delivery_address 
 f.label :separate_delivery_address, "Deliver to a different address?" 
 f.label :delivery_address1, "Delivery Address", :class => 'req' 
 f.text_field :delivery_name, :placeholder => "Deliver to (name/company)" 
 f.text_field :delivery_address1, :placeholder => "Line 1" 
 f.text_field :delivery_address3, :placeholder => "Town/City" 
 f.text_field :delivery_address4, :placeholder => "County" 
 f.text_field :delivery_postcode, :placeholder => "Postcode", :class => 'postcode' 
 f.collection_select :delivery_country_id, Shoppe::Country.ordered, :id, :name 
 end 
 f.submit "Continue to payment" 
 end 
 else 
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
  
  def payment
    @order = Shoppe::Order.find(current_order.id)
    if request.patch?
      redirect_to checkout_confirmation_path
    end
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
  
 else 
  if has_order? && current_order.has_items? 
 link_to "View my bag", basket_path 
 link_to "Checkout", checkout_path, :class => 'checkout' 
 else 
 end 
 
 end 
 @page_title = 'Checkout' 
   
 
 form_for @order, :url => checkout_payment_path, :html => {:class => 'checkout'} do |f| 
 field_set_tag nil, :class => 'payment' do 
 label_tag 'card_number', "Full Card Number" 
 text_field_tag 'card_number', '', :name => nil 
 label_tag 'exp_month', "Expiry Date (mm/yyyy)" 
 select_tag nil, options_for_select((1..12).to_a) 
 select_tag nil, options_for_select((Date.today.year..Date.today.year + 10).to_a), :class => 'year' 
 label_tag 'cvc', "Security Code" 
 text_field_tag 'cvc', '', :name => nil, :maxlength => 4 
 end 
 f.submit "Review your order", :class => 'review' 
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
  
  def confirmation
    unless current_order.confirming?
      redirect_to checkout_path
      return
    end
    
    if request.patch?
      begin
        current_order.confirm!
        # This payment method should usually be called in a payment module or elsewhere but for the demo
        # we are adding a payment to the order straight away.
        current_order.payments.create(:method => "Credit Card", :amount => current_order.total, :reference => rand(10000) + 10000, :refundable => true)
        session[:order_id] = nil
        redirect_to root_path, :notice => "Order has been placed!"
      rescue Shoppe::Errors::PaymentDeclined => e
        flash[:alert] = "Payment was declined by the bank. #{e.message}"
        redirect_to checkout_path
      rescue Shoppe::Errors::InsufficientStockToFulfil
        flash[:alert] = "We're terribly sorry but while you were checking out we ran out of stock of some of the items in your basket. Your basket has been updated with the maximum we can currently supply. If you wish to continue just use the button below."
        redirect_to checkout_path
      end
    end
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
  
 else 
  if has_order? && current_order.has_items? 
 link_to "View my bag", basket_path 
 link_to "Checkout", checkout_path, :class => 'checkout' 
 else 
 end 
 
 end 
 @page_title = 'Checkout' 
   
 
  Shoppe.settings.tax_name 
 for item in order.order_items 
 unless defined?(readonly) 
 link_to "+", adjust_basket_item_quantity_path(item.id), :method => :post, :class => 'ajax' 
 link_to "-", adjust_basket_item_quantity_path(item.id), :method => :delete, :class => 'ajax' 
 end 
 item.quantity 
 item.ordered_item.full_name 
 unless defined?(readonly) 
 link_to "Delete", remove_basket_item_path(item), :method => :delete, :class => 'delete ajax' 
 end 
 number_to_currency item.sub_total 
 number_to_currency item.tax_amount 
 number_to_currency item.total 
 end 
 if order.delivery_service 
 if defined?(readonly) 
 order.delivery_service.name 
 else 
 form_tag change_delivery_service_path do 
 select_tag 'delivery_service', options_from_collection_for_select(order.available_delivery_services, :id, :name, order.delivery_service.id) 
 end 
 end 
 number_to_currency order.delivery_price 
 end 
 number_to_currency order.total_before_tax 
 Shoppe.settings.tax_name 
 number_to_currency order.tax 
 number_to_currency order.total 
 
 form_tag checkout_confirmation_path, :method => :patch, :class => 'disableable' do 
 submit_tag "Place Order", :class => 'order' 
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
