# encoding: utf-8

class HelpController < ApplicationController
  def index
    redirect_to help_page_path("keyboard")
  end

  def show
    case params[:page]
    when "keyboard"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 [@page_title, Sugar.config.forum_name].compact.join(' - ') 
 stylesheet_link_tag "application" 
 if current_user? && current_user.stylesheet_url? 
 stylesheet_link_tag current_user.stylesheet_url 
 else 
 stylesheet_link_tag @theme.stylesheet_path 
 end 
 icon_tags 
 csrf_meta_tag 
 javascript_include_tag "swfobject" 
 body_classes 
 if Sugar.config.custom_header 
 raw Sugar.config.custom_header 
 end 
 Sugar.config.forum_title.html_safe 
 if current_user? || Sugar.public_browsing? 
 form_tag((@search_path || search_path), method: 'get') do 
 text_field_tag 'q', @search_query, class: :query 
 select_tag 'search_mode', options_for_select(
            search_mode_options,
            @search_path || search_path
          ) 
 submit_tag "Search", name: nil 
 end 
 end 
 if current_user? 
 profile_link(current_user) 
 link_to "Sign out", logout_users_path, data: { confirm: "Do you really want to sign out?"} 
 else 
 if Sugar.config.signups_allowed 
 link_to("Sign up", new_user_path) 
 end 
 link_to "Log in", login_users_path 
 end 
 if current_user? || Sugar.public_browsing? 
 header_tab 'Discussions', discussions_path 
 if current_user? 
 header_tab 'Following', following_discussions_path 
 header_tab 'Favorites', favorites_discussions_path 
 if current_user.unread_conversations? 
 header_tab(
                "Conversations (#{current_user.unread_conversations_count})",
                conversations_path,
                section: :conversations,
                class:   'new'
              )
            
 else 
 header_tab 'Conversations', conversations_path 
 end 
 end 
 header_tab 'Users', online_users_path 
 if current_user? && (current_user.invites? || current_user.available_invites?) 
 if !current_user.user_admin? && current_user.available_invites? 
 header_tab(
                "Invites (#{current_user.available_invites})",
                invites_path,
                section: :invites
              )
            
 else 
 header_tab 'Invites', invites_path 
 end 
 end 
 end 
 if flash[:notice] 
 raw flash[:notice] 
 end 
 if content_for?(:sidebar) 
 yield :sidebar 
 end 

  @page_title = 'Keyboard shortcuts'

 link_to 'Help', help_path 
 link_to @page_title, help_page_path(@page) 
 if mobile_user_agent? 
 link_to "mobile version", mobile_format: 'mobile' 
 end 
 if Sugar.config.custom_footer 
 raw Sugar.config.custom_footer 
 end 
 javascript_include_tag "application" 
 frontend_configuration.to_json.html_safe 
 unless Sugar.config.custom_javascript.blank? 
 raw Sugar.config.custom_javascript 
 end 
 if @posts && @posts.any? 
 end 
 if @google_maps_api 
 end 
 if Sugar.config.google_analytics 
 Sugar.config.google_analytics 
 end 

end

    end
  end
end
