#   Copyright (c) 2010-2012, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class HomeController < ApplicationController
  def show
    partial_dir = Rails.root.join("app", "views", "home")
    if user_signed_in?
      redirect_to stream_path
    elsif request.format == :mobile
      if partial_dir.join("_show.mobile.haml").exist? ||
         partial_dir.join("_show.mobile.erb").exist? ||
         partial_dir.join("_show.haml").exist?
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 og_prefix 
 page_title yield(:page_title) 
  if @post.present? 
 og_page_post_tags(@post) 
 else 
 og_general_tags 
 end 
 
 chartbeat_head_block 
 include_mixpanel 
 include_color_theme 
 if rtl? 
 stylesheet_link_tag :rtl, media:  'all' 
 end 
 old_browser_js_support 
 javascript_include_tag :ie 
 jquery_include_tag 
 unless @landing_page 
 javascript_include_tag :main, :templates 
 load_javascript_locales 
 end 
 translation_missing_warnings 
 current_user_atom_tag 
 yield(:head) 
 csrf_meta_tag 
 include_gon(camel_case:  true) 
 yield :before_content 
 
 content_for :page_title do 
 pod_name 
 end 
 render partial: "home/show" 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

      else
        redirect_to user_session_path
      end
    elsif partial_dir.join("_show.html.haml").exist? ||
          partial_dir.join("_show.html.erb").exist? ||
          partial_dir.join("_show.haml").exist?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 og_prefix 
 page_title yield(:page_title) 
  if @post.present? 
 og_page_post_tags(@post) 
 else 
 og_general_tags 
 end 
 
 chartbeat_head_block 
 include_mixpanel 
 include_color_theme 
 if rtl? 
 stylesheet_link_tag :rtl, media:  'all' 
 end 
 old_browser_js_support 
 javascript_include_tag :ie 
 jquery_include_tag 
 unless @landing_page 
 javascript_include_tag :main, :templates 
 load_javascript_locales 
 end 
 translation_missing_warnings 
 current_user_atom_tag 
 yield(:head) 
 csrf_meta_tag 
 include_gon(camel_case:  true) 
 yield :before_content 
 
 content_for :page_title do 
 pod_name 
 end 
 render partial: "home/show" 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for(:head) do 
 stylesheet_link_tag :home, media: "all" 
 end 
 image_tag "branding/logos/logo.png" 
 image_tag "landing/cog.png" 
 image_tag "landing/smiley_laughing.png" 
 link_to "creating an account", new_user_registration_path 
 image_tag "landing/pen_write.png" 
 link_to "Github", "http://github.com/diaspora/diaspora" 
 link_to "Codebase", "http://github.com/diaspora/diaspora", title: "Git repository" 
 link_to "Documentation", "http://wiki.diasporafoundation.org", title: "Project wiki" 
 link_to "IRC - General", "http://webchat.freenode.net/?channels=diaspora", title: "#diaspora" 
 link_to "IRC - Development", "http://webchat.freenode.net/?channels=diaspora-dev", title: "#diaspora-dev" 
 link_to "Discussion - General", "http://groups.google.com/group/diaspora-discuss", title: "General discussion mailing list" 
 link_to "Discussion - Development", "http://groups.google.com/group/diaspora-dev", title: "Dev mailing list" 
 link_to "Find & Report bugs", "https://github.com/diaspora/diaspora/issues", title: "Bug tracker" 
 link_to "Learn more about Ruby On Rails!", "http://guides.rubyonrails.org/" 

end

    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 og_prefix 
 page_title yield(:page_title) 
  if @post.present? 
 og_page_post_tags(@post) 
 else 
 og_general_tags 
 end 
 
 chartbeat_head_block 
 include_mixpanel 
 include_color_theme 
 if rtl? 
 stylesheet_link_tag :rtl, media:  'all' 
 end 
 old_browser_js_support 
 javascript_include_tag :ie 
 jquery_include_tag 
 unless @landing_page 
 javascript_include_tag :main, :templates 
 load_javascript_locales 
 end 
 translation_missing_warnings 
 current_user_atom_tag 
 yield(:head) 
 csrf_meta_tag 
 include_gon(camel_case:  true) 
 yield :before_content 
 
 content_for :page_title do 
 pod_name 
 end 
 render partial: "home/show" 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def toggle_mobile
    session[:mobile_view] = session[:mobile_view].nil? ? true : !session[:mobile_view]

    redirect_to :back
  end

  def force_mobile
    session[:mobile_view] = true

    redirect_to stream_path
  end
end
