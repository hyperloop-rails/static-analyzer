  class OrdersController < ApplicationController
    def submit
      response.headers['Cache-Control'] = 'no-cache'
      @cart = Cart.new(request.cookies["cart"])

      if request.post?
        logger = Logger.new("#{Rails.root}/#{Piggybak.config.logging_file}")

        begin
          ActiveRecord::Base.transaction do
            @order = Order.new(orders_params)
            @order.create_payment_shipment

            if Piggybak.config.logging
              clean_params = params[:order].clone
              clean_params[:line_items_attributes].each do |k, li_attr|
                if li_attr[:line_item_type] == "payment" && li_attr.has_key?(:payment_attributes)
                  if li_attr[:payment_attributes].has_key?(:number)
                    li_attr[:payment_attributes][:number] = li_attr[:payment_attributes][:number].mask_cc_number
                  end
                  if li_attr[:payment_attributes].has_key?(:verification_value)
                    li_attr[:payment_attributes][:verification_value] = li_attr[:payment_attributes][:verification_value].mask_csv
                  end
                end
              end
              logger.info "#{request.remote_ip}:#{Time.now.strftime("%Y-%m-%d %H:%M")} Order received with params #{clean_params.inspect}" 
            end
            @order.initialize_user(current_user)

            @order.ip_address = request.remote_ip 
            @order.user_agent = request.user_agent  
            @order.add_line_items(@cart)

            if Piggybak.config.logging
              logger.info "#{request.remote_ip}:#{Time.now.strftime("%Y-%m-%d %H:%M")} Order contains: #{cookies["cart"]} for user #{current_user ? current_user.email : 'guest'}"
            end

            if @order.save
              if Piggybak.config.logging
                logger.info "#{request.remote_ip}:#{Time.now.strftime("%Y-%m-%d %H:%M")} Order saved: #{@order.inspect}"
              end

              cookies["cart"] = { :value => '', :path => '/' }
              session[:last_order] = @order.id
              redirect_to piggybak.receipt_url 
            else
              if Piggybak.config.logging
                logger.warn "#{request.remote_ip}:#{Time.now.strftime("%Y-%m-%d %H:%M")} Order failed to save #{@order.errors.full_messages} with #{@order.inspect}."
              end
              raise Exception, @order.errors.full_messages
            end
          end
        rescue Exception => e
          if Piggybak.config.logging
            logger.warn "#{request.remote_ip}:#{Time.now.strftime("%Y-%m-%d %H:%M")} Order exception: #{e.inspect}"
          end
          if @order.errors.empty?
            @order.errors[:base] << "Your order could not go through. Please try again."
          end
        end
      else
        @order = Order.new
        @order.create_payment_shipment
        @order.initialize_user(current_user)
      end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true 
 javascript_include_tag 'application', 'data-turbolinks-track' => true 
 csrf_meta_tags 
 form_for @order, :url => piggybak.orders_url, :method => "POST" do |f| 
 if @order.errors.any? 
 raw @order.errors.full_messages.collect { |b| b.gsub(/^Line items payment/, 'Payment').gsub(/^Line items shipment shipping/, 'Shipping') }.join("<br />") 
 end 
  if current_user 
 f.label :email 
 f.text_field :email, { :readonly => true, :class => "readonly required" } 
 link_to 'LOGOUT', main_app.destroy_user_session_path, :method => :delete, :class => "last" 
 else 
 f.label :email 
 f.text_field :email, :class => "required" 
 link_to 'LOG IN', main_app.new_user_session_path 
 end 
 f.label :phone 
 f.text_field :phone, :class => "required" 
 
  f.fields_for :billing_address do |billing_address| 
  address.label :firstname 
 address.text_field :firstname, :class => "required" 
 address.label :lastname 
 address.text_field :lastname, :class => "required" 
 address.label :address1, "Address" 
 address.text_field :address1, :class => "required" 
 address.label :address2, "Address cont." 
 address.text_field :address2 
 address.label :city 
 address.text_field :city, :class => "required" 
 address.label :country_id 
 address.collection_select :country_id, Country.send(type), :id, :name, { :selected => address.object.country_id.to_s }, :class => "required" 
 address.label :state_id 
 if address.object.country.states.any? 
 address.collection_select :state_id, address.object.country.states, :id, :name, { :selected => address.object.state_id.to_s }, :class => "required" 
 else 
 address.text_field :state_id, :class => "required" 
 end 
 address.label :zip 
 address.text_field :zip, :class => "required" 
 
 end 
 
  f.fields_for :shipping_address do |shipping_address| 
  address.label :firstname 
 address.text_field :firstname, :class => "required" 
 address.label :lastname 
 address.text_field :lastname, :class => "required" 
 address.label :address1, "Address" 
 address.text_field :address1, :class => "required" 
 address.label :address2, "Address cont." 
 address.text_field :address2 
 address.label :city 
 address.text_field :city, :class => "required" 
 address.label :country_id 
 address.collection_select :country_id, Country.send(type), :id, :name, { :selected => address.object.country_id.to_s }, :class => "required" 
 address.label :state_id 
 if address.object.country.states.any? 
 address.collection_select :state_id, address.object.country.states, :id, :name, { :selected => address.object.state_id.to_s }, :class => "required" 
 else 
 address.text_field :state_id, :class => "required" 
 end 
 address.label :zip 
 address.text_field :zip, :class => "required" 
 
 end 
 
  f.fields_for :line_items, @order.line_items.detect { |li| li.line_item_type == "shipment" } do |line_item_f| 
 line_item_f.hidden_field :line_item_type, { :value => "shipment" } 
 line_item_f.fields_for :shipment do |shipment| 
 shipment.label :shipping_method_id 
 shipment.select :shipping_method_id, [] 
 image_tag "ajax-loader.gif" 
 end 
 end 
 
  f.fields_for :line_items, @order.line_items.detect { |li| li.line_item_type == "payment" } do |line_item_f| 
 line_item_f.hidden_field :line_item_type, { :value => "payment" } 
 line_item_f.fields_for :payment do |payment| 
 payment.label :number 
 if @order.errors.keys.include?("payments.number".to_sym) 
 payment.text_field :number, :class => "required" 
 else 
 payment.text_field :number, :class => "required" 
 end 
 payment.label :verification_value 
 if @order.errors.keys.include?("payments.verification_value".to_sym) 
 payment.text_field :verification_value, :class => "required" 
 else 
 payment.text_field :verification_value, :class => "required" 
 end 
 payment.label :month 
 if @order.errors.keys.include?("payments.verification_value".to_sym) 
 payment.select :month, 1.upto(12).to_a 
 payment.select :year, Time.now.year.upto(Time.now.year + 10).to_a 
 else 
 payment.select :month, 1.upto(12).to_a 
 payment.select :year, Time.now.year.upto(Time.now.year + 10).to_a 
 end 
 end 
 end 
 
 f.submit 
 end 
  if @cart.sellables.any? 
 form_tag piggybak.cart_update_url do 
 if page == "cart" 
 end 
 @cart.sellables.each do |item| 
 item[:sellable].description 
 number_to_currency item[:sellable].price 
 if page == "cart" 
 number_field_tag "quantity[#{item[:sellable].id}]", item[:quantity] 
 else 
 item[:quantity] 
 end 
 number_to_currency item[:quantity]*item[:sellable].price 
 if page == "cart" 
 link_to "Remove", piggybak.remove_item_url(item[:sellable].id), :method => :delete 
 end 
 end 
 page == "cart" ? "5" : "4" 
 page == "cart" ? "3" : "2" 
 @cart.total 
 number_to_currency @cart.total 
 if page != "cart" 
 page == "cart" ? "3" : "2" 
 page == "cart" ? "3" : "2" 
 Piggybak.config.line_item_types.each do |k, v| 
 if v.has_key?(:display_in_cart) 
 "#{k}_row" 
 page == "cart" ? "3" : "2" 
 v[:display_in_cart] 
 'reduce_tax_subtotal' if v.has_key?(:reduce_tax_subtotal) && v[:reduce_tax_subtotal] 
 k 
 end 
 end 
 page == "cart" ? "3" : "2" 
 end 
 if page == "cart" 
 link_to "Proceed to Checkout", piggybak.orders_url, :id => "checkout" 
 submit_tag "Update", :id => "update" 
 end 
 end 
 else 
 end 
 
 piggybak.orders_shipping_url 
 piggybak.orders_tax_url 
 piggybak.orders_geodata_url 
 if params.has_key?(:piggybak_order) &&  params[:piggybak_order].has_key?(:shipments_attributes) 
 params[:piggybak_order][:shipments_attributes]["0"][:shipping_method_id] 
 else 
 end 

end

    end
  
    def receipt
      response.headers['Cache-Control'] = 'no-cache'

      if !session.has_key?(:last_order)
        redirect_to main_app.root_url 
        return
      end

      @order = Order.where(id: session[:last_order]).first
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true 
 javascript_include_tag 'application', 'data-turbolinks-track' => true 
 csrf_meta_tags 
  order.line_items.sellables.each do |line_item| 
 line_item.description 
 number_to_currency line_item.unit_price 
 line_item.quantity 
 number_to_currency line_item.price 
 end 
 number_to_currency order.line_items.sellables.inject(0) { |subtotal, li| subtotal + li.price } 
 number_to_currency order.tax_charge 
 number_to_currency order.shipment_charge 
 Piggybak.config.line_item_types.each do |k, v| 
 if v.has_key?(:display_in_cart) && order.line_items.detect { |li| li.line_item_type == k.to_s } 
 v[:display_in_cart] 
 k 
 number_to_currency order.line_items.detect { |li| li.line_item_type == k.to_s }.price 
 end 
 end 
 number_to_currency order.total 
 order.email 
 order.phone 
 raw order.billing_address.display 
 raw order.shipping_address.display 
 

end

    end

    def list
      redirect_to main_app.root_url if current_user.nil?
    end

    def download
      @order = Order.where(id: params[:id]).first

      if can?(:download, @order)
        render :layout => false
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true 
 javascript_include_tag 'application', 'data-turbolinks-track' => true 
 csrf_meta_tags 

end

      end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true 
 javascript_include_tag 'application', 'data-turbolinks-track' => true 
 csrf_meta_tags 
 @order.id 
 @order.email 
 @order.phone 
 @order.line_items.sellables.each do |line_item| 
 line_item.quantity 
 raw line_item.description 
 number_to_currency line_item.price 
 end 
 LineItem.sorted_line_item_types.each do |type| 
 type.to_s.pluralize.titleize 
 number_to_currency @order.send("#{type}_charge") 
 end 
 number_to_currency @order.total 
 number_to_currency @order.total_due 
 raw @order.billing_address.display.gsub("<br />", "\n") 
 raw @order.shipping_address.display.gsub("<br />", "\n") 

end

    end

    def email
      order = Order.where(id: params[:id]).first

      if can?(:email, order)
        Notifier.order_notification(order).deliver
        flash[:notice] = "Email notification sent."
        OrderNote.create(:order_id => order.id, :note => "Email confirmation manually sent.", :user_id => current_user.id)
      end

      redirect_to rails_admin.edit_path('Order', order.id)
    end

    def cancel
      order = Order.where(id: params[:id]).first

      if can?(:cancel, order)
        order.recorded_changer = current_user.id
        order.disable_order_notes = true

        order.line_items.each do |line_item|
          if line_item.line_item_type != "payment"
            line_item.mark_for_destruction
          end
        end
        order.update_attribute(:total, 0.00)
        order.update_attribute(:to_be_cancelled, true)

        OrderNote.create(:order_id => order.id, :note => "Order set to cancelled. Line items, shipments, tax removed.", :user_id => current_user.id)
        
        flash[:notice] = "Order #{order.id} set to cancelled. Order is now in unbalanced state."
      else
        flash[:error] = "You do not have permission to cancel this order."
      end

      redirect_to rails_admin.edit_path('Order', order.id)
    end

    # AJAX Actions from checkout
    def shipping
      cart = Cart.new(request.cookies["cart"])
      cart.set_extra_data(params)
      shipping_methods = ShippingMethod.lookup_methods(cart)
      render :json => shipping_methods
    end

    def tax
      cart = Cart.new(request.cookies["cart"])
      cart.set_extra_data(params)
      total_tax = TaxMethod.calculate_tax(cart)
      render :json => { :tax => total_tax }
    end

    def geodata
      countries = Country.all.includes(:states)
      data = countries.inject({}) do |h, country|
        h["country_#{country.id}"] = country.states
        h
      end
      render :json => { :countries => data }
    end

    private
    def orders_params
      nested_attributes = [shipment_attributes: [:shipping_method_id], 
                           payment_attributes: [:number, :verification_value, :month, :year]].first.merge(Piggybak.config.additional_line_item_attributes)
      line_item_attributes = [:sellable_id, :price, :unit_price, :description, :quantity, :line_item_type, nested_attributes]
      params.require(:order).permit(:user_id, :email, :phone, :ip_address,
                                    billing_address_attributes: [:firstname, :lastname, :address1, :location, :address2, :city, :state_id, :zip, :country_id],
                                    shipping_address_attributes: [:firstname, :lastname, :address1, :location, :address2, :city, :state_id, :zip, :country_id, :copy_from_billing],
                                    line_items_attributes: line_item_attributes)

    end
  end
