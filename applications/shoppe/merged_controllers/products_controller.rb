class ProductsController < ApplicationController
  
  before_filter do
    if params[:category_id]
      @product_category = Shoppe::ProductCategory.where(:permalink => params[:category_id]).first!
    end
    if @product_category && params[:product_id]
      @product = @product_category.products.where(:permalink => params[:product_id]).active.first!      
    end
  end
  
  def index
    @products = @product_category.products.includes(:product_categories, :variants).root.active
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
 active_nav_item :catalogue 
 @page_title = @product_category.name 
 @product_category.name 
 unless @product_category.description.blank? 
 @product_category.description 
 end 
 if @products.empty? 
 else 
  for product in products 
 link_to product.name, product_path(product.product_category.permalink, product.permalink) 
 truncate product.short_description, :length => 90 
 link_to "Info", product_path(product.product_category.permalink, product.permalink) 
 if product.orderable? 
 link_to "Add", buy_product_path(product.product_category.permalink, product.permalink), :class => 'add', :method => :post 
 end 
 number_to_currency product.price 
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
  
  def filter
    @products = Shoppe::Product.active.with_attributes(params[:key].to_s, params[:value].to_s)
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
 active_nav_item :catalogue 
 @page_title = "#{params[:value]} - Products" 
 if @products.empty? 
 else 
  for product in products 
 link_to product.name, product_path(product.product_category.permalink, product.permalink) 
 truncate product.short_description, :length => 90 
 link_to "Info", product_path(product.product_category.permalink, product.permalink) 
 if product.orderable? 
 link_to "Add", buy_product_path(product.product_category.permalink, product.permalink), :class => 'add', :method => :post 
 end 
 number_to_currency product.price 
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
  
  def categories
    @product_categories = Shoppe::ProductCategory.ordered
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
 active_nav_item :catalogue 
 @page_title = 'Catalogue' 
 for category in @product_categories 
 link_to category.name, products_path(category.permalink) 
 category.description 
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
  
  def show
    @attributes = @product.product_attributes.public.to_a
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
 active_nav_item :catalogue 
 @page_title = @product.name + " - " + @product.product_category.name 
 if @product.default_image 
 end 
 @product.name 
 @product.short_description 
 if @product.has_variants? 
 for variant in @product.variants 
 if variant.in_stock? 
 else 
 end 
 variant.name 
 number_to_currency variant.price 
 form_tag buy_product_path(@product.product_category.permalink, @product.permalink, :variant => variant.id), :class => (variant.in_stock? ? 'in-stock' : 'no-stock') do 
 select_tag 'quantity', options_for_select([1,2,3,4,5,6,7,8,9]), :disabled => !variant.in_stock? 
 submit_tag 'Add to basket', :disabled => !variant.in_stock? 
 end 
 end 
 else 
 number_to_currency @product.price 
 form_tag buy_product_path(@product.product_category.permalink, @product.permalink), :class => (@product.in_stock? ? 'in-stock' : 'no-stock') do 
 select_tag 'quantity', options_for_select([1,2,3,4,5,6,7,8,9]), :disabled => !@product.in_stock? 
 submit_tag 'Add to basket', :disabled => !@product.in_stock? 
 end 
 if @product.in_stock? 
 else 
 end 
 if @product.data_sheet 
 link_to "Read product datasheet", @product.data_sheet.path 
 end 
 unless @product.in_the_box.blank? 
 link_to "What's in the box?" 
 markdown @product.in_the_box 
 end 
 mail_to Shoppe.settings.email_address, "Ask us a question about this", :subject => "Question about the #{@product.name}" 
 end 
 unless @attributes.empty? 
 for attribute in @attributes 
 attribute.key 
 link_to attribute.value, product_filter_path(:key => attribute.key, :value => attribute.value) 
 end 
 end 
 markdown @product.description 
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
  
  def add_to_basket
    product_to_order = params[:variant] ? @product.variants.find(params[:variant].to_i) : @product
    current_order.order_items.add_item(product_to_order, params[:quantity].blank? ? 1 : params[:quantity].to_i)
    respond_to do |wants|
      wants.html { redirect_to request.referer }
      wants.json { render :json => {:added => true} }
    end
  rescue Shoppe::Errors::NotEnoughStock => e
    respond_to do |wants|
      wants.html { redirect_to request.referer, :alert => "We're sorry but we don't have enough stock to add that many products. We currently have #{e.available_stock} item(s) in stock. Please try again."}
      wants.json { render :json => {:error => 'NotEnoughStock', :available_stock => e.available_stock}}
    end
  end
  
end
