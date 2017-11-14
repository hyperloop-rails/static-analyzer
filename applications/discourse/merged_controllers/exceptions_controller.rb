class ExceptionsController < ApplicationController
  skip_before_filter :check_xhr, :preload_json

  def not_found
    @hide_google = true if SiteSetting.login_required

    # centralize all rendering of 404 into app controller
    raise Discourse::NotFound
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 local_domain = "#{request.protocol}#{request.host_with_port}" 
 t 'page_not_found.title' 
 t 'page_not_found.popular_topics' 
 @top_viewed.each do |t| 
 link_to t.title, t.relative_url 
 category_badge(t.category) 
 end 
 path "/latest" 
 t 'page_not_found.see_more' 
 t 'page_not_found.recent_topics' 
 @recent.each do |t| 
 link_to t.title, t.relative_url 
 category_badge(t.category) 
 end 
 path "/latest" 
 t 'page_not_found.see_more' 
 unless @hide_google 
 t 'page_not_found.search_title' 
 @slug 
 t 'page_not_found.search_google' 
 local_domain 
 end 

end

  end

  # Give us an endpoint to use for 404 content in the ember app
  def not_found_body

    # Don't show google search if it's embedded in the Ember app
    @hide_google = true

    render text: build_not_found_page(200, false)
  end

end
