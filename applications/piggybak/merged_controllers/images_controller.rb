class ImagesController < ApplicationController
  def show
    @image = Image.find_by_slug(params[:id])

    if @image.nil?
      image = Image.find_by_id(params[:id])
      if image
        redirect_to image_url(image.slug), :status => 301
      else
        redirect_to root_url
      end
    else
      if @image.piggybak_sellable.navigation_nodes.any?
        @related_images = @image.piggybak_sellable.navigation_nodes.first.sellables.collect { |s| s.item }.select { |p| p != @image }[0..2]
      else
        @related_images = []
      end
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
 taxonomy_breadcrumb(@image) 
 image_tag @image.main.url 
 @image.title 
 @image.description 
 @image.user.display_name 
 cart_form(@image) 
 if @related_images.any? 
 @related_images.each do |image| 
 link_to image_tag(image.gallery.url(:thumb)), image_url(image.slug) 
 link_to image.title, image_url(image.slug) 
 end 
 end 
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
