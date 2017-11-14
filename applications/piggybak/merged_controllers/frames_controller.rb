class FramesController < ApplicationController
  def show
    @frame = Frame.find(1)

    if @frame.nil?
      redirect_to root_url
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @title || "Piggybak Demo" 
 stylesheet_link_tag    "application" 
 javascript_include_tag "application" 
 csrf_meta_tags 
 piggybak_track_order("Piggybak Demo") 
 link_to image_tag("piggybak_demo.png"), "/demo/" 
 render_navigation(false, false) 
 link_to "Professional Frames", main_app.frame_url 
 link_to "Gift Certificates", piggybak_giftcerts.buy_giftcert_url 
 if current_user 
 if current_user.piggybak_orders.any? 
 orders_link("Order History") 
 end 
 if current_user.roles.size > 0 
 link_to 'ADMIN', "/demo/admin" 
 end 
 link_to 'LOGOUT', main_app.destroy_user_session_path, :method => :delete, :class => "last" 
 else 
 link_to 'LOG IN', main_app.new_user_session_path 
 end 
 cart_link 
 if params[:controller] == "home" 
 elsif params[:controller] == "image" 
 link_to "Home", root_url 
 if @image.categories.any? 
 link_to @image.categories.first.title, category_url(@image.categories.first.slug) 
 end 
 @image.title 
 end 
 if false 
 end 
 image_tag @frame.main.url 
 @frame.title 
 @frame.description 
 variant_cart_form(@frame) 
 Time.now.year.to_s 
 RUBY_VERSION 
 Rails::VERSION::STRING 
 Gem.loaded_specs["piggybak"].version.to_s 
 Page.all.each do |page| 
 link_to page.title, "/demo/#{page.slug}/" 
 end 

end

  end
end
