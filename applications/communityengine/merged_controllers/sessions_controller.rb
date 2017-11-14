# This controller handles the login/logout function of the site.
class SessionsController < BaseController

  skip_before_action :store_location, :only => [:new, :create]

  def index
    redirect_to :action => "new"
  end

  def new
    redirect_to user_path(current_user) and return if current_user
    @user_session = UserSession.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 home_url 
 csrf_meta_tag 
 page_title 
 if @meta 
 @meta.each do |key| 
 key[1] 
 key[0] 
 end 
 end 
 if @rss_title && @rss_url 
 auto_discovery_link_tag(:rss, @rss_url, {:title => @rss_title}) 
 end 
  stylesheet_link_tag 'community_engine' 
 if forum_page? 
 unless @feed_icons.blank? 
 @feed_icons.each do |feed| 
 auto_discovery_link_tag :rss, feed[:url], :title => "Subscribe to '#{feed[:title]}'" 
 end 
 end 
 end 
 yield :head_css 
 
 unless configatron.auth_providers.facebook.key.blank? 
  
 end 
  link_to configatron.community_name, home_path, :class => 'navbar-brand' 
  
  if current_page?(site_clippings_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :clippings.l, site_clippings_path 
 
  if params[:controller] == 'events' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :events.l, events_path 
 
  if params[:controller] == 'forums' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :forums.l, forums_path 
 
  if current_page?(popular_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :popular.l, popular_path 
 
  if current_page?(users_path) || (params[:controller] == 'users' && !@user.nil? && @user != current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :people.l, users_path 
 
 if @header_tabs.any? 
 for tab in @header_tabs 
 link_to tab.name, tab.url 
 end 
 end 
  if logged_in? 
 if current_user.unread_messages? 
 if params[:controller] == 'messages' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 user_messages_path(current_user) 
 current_user.unread_message_count 
 fa_icon "envelope inverse" 
 end 
 end 
 
  
 
 render_jumbotron 
 container_title 
  
  @page_title=:log_in_to_site.l(:site => configatron.community_name) 
  widget do 
 :help.l 
 :dont_have_an_account.l 
 link_to :click_here_to_sign_up.l, signup_path 
 :forgot_your_password.l 
 link_to :click_here_to_retrieve_it.l, forgot_password_url 
 :forgot_your_username.l 
 link_to :click_here_to_retrieve_it.l, forgot_username_url 
 end 
 
 if configatron.auth_providers.to_hash.keys.any? 
 widget do 
 t 'sessions.new.omniauth.header' 
 configatron.auth_providers.to_hash.keys.each do |provider| 
 alt = t('sessions.new.omniauth.button_alt', :provider => provider) 
 link_to(image_tag("auth/#{provider.to_s}_64.png", :alt => alt), "/auth/#{provider.to_s}", :title => alt) 
 end 
 end 
 end 
 bootstrap_form_tag :url => sessions_path, :layout => :horizontal do |f| 
 f.email_field :email, value: params[:email] 
 f.password_field :password 
 f.form_group :remember_group do 
 f.check_box :check_box do 
 :remember_me.l 
 end 
 end 
 f.form_group :submit_group do 
 f.primary :log_in.l 
 end 
 end 
  render_widgets 
 
 if show_footer_content? 
 image_tag 'spinner.gif', :plugin => 'community_engine' 
 :loading_recent_content.l 
 end 
  
 :community_tagline.l 
  javascript_include_tag 'community_engine' 
 tiny_mce_init_if_needed 
 if show_footer_content? 
 end 
 
 yield :end_javascript 

end

  end

  def create
    @user_session = UserSession.new(:login => params[:email], :password => params[:password], :remember_me => params[:remember_me])

    if @user_session.save
      self.current_user = @user_session.record #if current_user has been called before this, it will ne nil, so we have to make to reset it

      flash[:notice] = :thanks_youre_now_logged_in.l
      redirect_back_or_default(dashboard_user_path(current_user))
    else
      flash[:notice] = :uh_oh_we_couldnt_log_you_in_with_the_username_and_password_you_entered_try_again.l
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 home_url 
 csrf_meta_tag 
 page_title 
 if @meta 
 @meta.each do |key| 
 key[1] 
 key[0] 
 end 
 end 
 if @rss_title && @rss_url 
 auto_discovery_link_tag(:rss, @rss_url, {:title => @rss_title}) 
 end 
  stylesheet_link_tag 'community_engine' 
 if forum_page? 
 unless @feed_icons.blank? 
 @feed_icons.each do |feed| 
 auto_discovery_link_tag :rss, feed[:url], :title => "Subscribe to '#{feed[:title]}'" 
 end 
 end 
 end 
 yield :head_css 
 
 unless configatron.auth_providers.facebook.key.blank? 
  
 end 
  link_to configatron.community_name, home_path, :class => 'navbar-brand' 
  
  if current_page?(site_clippings_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :clippings.l, site_clippings_path 
 
  if params[:controller] == 'events' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :events.l, events_path 
 
  if params[:controller] == 'forums' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :forums.l, forums_path 
 
  if current_page?(popular_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :popular.l, popular_path 
 
  if current_page?(users_path) || (params[:controller] == 'users' && !@user.nil? && @user != current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :people.l, users_path 
 
 if @header_tabs.any? 
 for tab in @header_tabs 
 link_to tab.name, tab.url 
 end 
 end 
  if logged_in? 
 if current_user.unread_messages? 
 if params[:controller] == 'messages' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 user_messages_path(current_user) 
 current_user.unread_message_count 
 fa_icon "envelope inverse" 
 end 
 end 
 
  
 
 render_jumbotron 
 container_title 
  
  @page_title=:log_in_to_site.l(:site => configatron.community_name) 
  widget do 
 :help.l 
 :dont_have_an_account.l 
 link_to :click_here_to_sign_up.l, signup_path 
 :forgot_your_password.l 
 link_to :click_here_to_retrieve_it.l, forgot_password_url 
 :forgot_your_username.l 
 link_to :click_here_to_retrieve_it.l, forgot_username_url 
 end 
 
 if configatron.auth_providers.to_hash.keys.any? 
 widget do 
 t 'sessions.new.omniauth.header' 
 configatron.auth_providers.to_hash.keys.each do |provider| 
 alt = t('sessions.new.omniauth.button_alt', :provider => provider) 
 link_to(image_tag("auth/#{provider.to_s}_64.png", :alt => alt), "/auth/#{provider.to_s}", :title => alt) 
 end 
 end 
 end 
 bootstrap_form_tag :url => sessions_path, :layout => :horizontal do |f| 
 f.email_field :email, value: params[:email] 
 f.password_field :password 
 f.form_group :remember_group do 
 f.check_box :check_box do 
 :remember_me.l 
 end 
 end 
 f.form_group :submit_group do 
 f.primary :log_in.l 
 end 
 end 
  render_widgets 
 
 if show_footer_content? 
 image_tag 'spinner.gif', :plugin => 'community_engine' 
 :loading_recent_content.l 
 end 
  
 :community_tagline.l 
  javascript_include_tag 'community_engine' 
 tiny_mce_init_if_needed 
 if show_footer_content? 
 end 
 
 yield :end_javascript 

end

    end
  end

  def destroy
    redirect_to new_session_path and return if current_user_session.nil?
    current_user_session.destroy
    reset_session
    flash[:notice] = :youve_been_logged_out_hope_you_come_back_soon.l
    redirect_to new_session_path
  end

end
