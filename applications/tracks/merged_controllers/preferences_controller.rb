class PreferencesController < ApplicationController

  def index
    @page_title = t('preferences.page_title')
    @prefs = current_user.prefs
    @user = current_user
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag "application", :media => "all" 
 stylesheet_link_tag "print", :media => "print" 
 javascript_include_tag "application" 
 csrf_meta_tags 
@source_view
 raw(protect_against_forgery? ? form_authenticity_token.inspect : "") 
 @tag_name ? @tag_name : "" 
 @group_view_by ? @group_view_by : "" 
 default_contexts_for_autocomplete.html_safe rescue '{}' 
 default_tags_for_autocomplete.html_safe rescue '{}' 
 date_format_for_date_picker 
 current_user.prefs.week_starts 
 root_url 
 if current_user.prefs.refresh != 0 
 current_user.prefs["refresh"].to_i*60000 
 end 
 unless controller.controller_name == 'feed' or session['noexpiry'] == "on" 
url_for(:controller => "login", :action => "check_expiry")
 end 
check_deferred_todos_path(:format => 'js')
 generate_i18n_strings 
 favicon_link_tag 'favicon.ico' 
 favicon_link_tag 'apple-touch-icon.png', :rel => 'apple-touch-icon', :type => 'image/png' 
 auto_discovery_link_tag(:rss, {:controller => "todos", :action => "index", :format => 'rss', :token => "#{current_user.token}"}, {:title => t('layouts.next_actions_rss_feed')}) 
 search_plugin_path(:format => :xml) 
 @page_title 
  if @count 
 @count 
 end 
 l(Time.zone.today, :format => current_user.prefs.title_date_format) 
 navigation_link(t('layouts.navigation.home'), root_path, {:accesskey => "t", :title => t('layouts.navigation.home_title')} ) 
 navigation_link(t('layouts.navigation.starred'), tag_path("starred"), :title => t('layouts.navigation.starred_title')) 
 navigation_link(t('common.projects'), projects_path, {:accesskey=>"p", :title=>t('layouts.navigation.projects_title')} ) 
 navigation_link(t('layouts.navigation.tickler'), tickler_path, {:accesskey =>"k", :title => t('layouts.navigation.tickler_title')} ) 
 t('layouts.navigation.organize') 
 navigation_link( t('common.contexts'), contexts_path, {:accesskey=>"c", :title=>t('layouts.navigation.contexts_title')} ) 
 navigation_link( t('common.notes'), notes_path, {:accesskey => "o", :title => t('layouts.navigation.notes_title')} ) 
 navigation_link( t('common.review'), review_path, {:accesskey => "r", :title => t('layouts.navigation.review_title')} ) 
 navigation_link( t('layouts.navigation.recurring_todos'), {:controller => "recurring_todos", :action => "index"}, :title => t('layouts.navigation.recurring_todos_title')) 
 t('layouts.navigation.view') 
 navigation_link( t('layouts.navigation.calendar'), calendar_path, :title => t('layouts.navigation.calendar_title')) 
 navigation_link( t('layouts.navigation.completed_tasks'), done_overview_path, {:accesskey=>"d", :title=>t('layouts.navigation.completed_tasks_title')} ) 
 navigation_link( t('layouts.navigation.feeds'), feeds_path, :title => t('layouts.navigation.feeds_title')) 
 navigation_link( t('layouts.navigation.stats'), stats_path, :title => t('layouts.navigation.stats_title')) 
 link_to(t('layouts.toggle_contexts'), "#", {:title => t('layouts.toggle_contexts_title'), :id => "toggle-contexts-nav"}) 
 link_to(t('layouts.toggle_notes'), "#", {:accesskey => "S", :title => t('layouts.toggle_notes_title'), :id => "toggle-notes-nav"}) 
 group_view_by_menu_entry 
 t('layouts.navigation.admin') 
 navigation_link( t('layouts.navigation.preferences'), preferences_path, {:accesskey => "u", :title => t('layouts.navigation.preferences_title')} ) 
 navigation_link( t('layouts.navigation.export'), data_path, {:accesskey => "e", :title => t('layouts.navigation.export_title')} ) 
 navigation_link( t('layouts.navigation.import'), import_data_path, {:accesskey => "i", :title => t('layouts.navigation.import_title')} ) 
 if current_user.is_admin? 
 navigation_link(t('layouts.navigation.manage_users'), users_path, {:accesskey => "a", :title => t('layouts.navigation.manage_users_title')} ) 
 end 
 t('layouts.navigation.help') 
 link_to t('layouts.navigation.integrations_'), integrations_path 
 link_to t('layouts.navigation.api_docs'), rest_api_docs_path 
 navigation_link(image_tag("system-search.png", :size => "16X16", :border => 0), search_path, :title => t('layouts.navigation.search')) 
 link_to("#{t('common.logout')} (#{current_user.display_name}) &raquo;".html_safe, logout_path) 
 
 controller.controller_name 
 render_flash 
 controller.controller_name 
  get_list_of_error_messages_for(@user)
 get_list_of_error_messages_for(@prefs)
 form_for(@prefs) do 
 t('preferences.tabs.profile')
 t('preferences.tabs.authentication')
 t('preferences.tabs.date_and_time')
 t('preferences.tabs.tracks_behavior')
  pref_with_text_field 'user', 'first_name' 
 pref_with_text_field 'user', 'last_name' 
 pref_with_select_field('prefs', 'locale', I18n.available_locales.map {|l| l.to_s}) 

  t('preferences.token_header') 
 t('preferences.token_description') 
 current_user.token 
 # TODO: make remote AJAX call for new token 
 link_to(
  t('preferences.generate_new_token'),
  refresh_token_user_path( current_user ),
  :method => :post,
  :data => {:confirm => t('preferences.generate_new_token_confirm')},
  :id=>'prefs_new_token') 
 if Tracks::Config.auth_schemes.length > 1 
 t('users.label_auth_type') 
 Tracks::Config.auth_schemes.each do |scheme| 
 radio_button_tag('user[auth_type]', scheme, current_user.auth_type == scheme) 
scheme
 end 
 end 
 current_user.auth_type == 'open_id' ? 'block' : 'none' 
 t('users.identity_url') 
 current_user.open_id_url 
 current_user.auth_type == 'database' ? 'block' : 'none' 
  t('users.new_password_label') 
 password_field "user", "password", :size => 40, :autocomplete => "off" 
 t('users.password_confirmation_label') 
 password_field "user", "password_confirmation", :size => 40, :autocomplete => "off" 
 

  pref_with_text_field('prefs', 'date_format') 
 l(Time.zone.today, :format => current_user.prefs.date_format) 
 %w{default short long longer}.each do |format| 
 radio_button_tag("date_picker1", t("date.formats.#{format}")) 
 l(Time.zone.today, :format => format.to_sym) 
 end 
 pref_with_text_field('prefs', 'title_date_format') 
 l(Time.zone.today, :format => current_user.prefs.title_date_format) 
 %w{default short long longer}.each do |format| 
 radio_button_tag("date_picker2", t("date.formats.#{format}")) 
 l(Time.zone.today, :format => format.to_sym) 
 end 
 pref('prefs', 'time_zone') { time_zone_select('prefs','time_zone') } 
 pref_with_select_field('prefs', "week_starts", (0..6).to_a.map {|num| [t('date.day_names')[num], num] }) 

  pref_with_select_field('prefs', "due_style", [[t('models.preference.due_styles')[0],Preference.due_styles[:due_in_n_days]],[t('models.preference.due_styles')[1],Preference.due_styles[:due_on]]]) 
 pref_with_select_field('prefs', "show_completed_projects_in_sidebar") 
 pref_with_select_field('prefs', "show_hidden_projects_in_sidebar") 
 pref_with_select_field('prefs', "show_hidden_contexts_in_sidebar") 
 pref_with_select_field('prefs', "show_project_on_todo_done") 
 pref_with_text_field('prefs', 'staleness_starts') 
 pref_with_text_field('prefs', 'review_period') 
 pref_with_text_field('prefs', 'show_number_completed') 
 pref_with_text_field('prefs', 'refresh') 
 pref_with_select_field('prefs', "verbose_action_descriptors") 
 pref_with_text_field('prefs', "mobile_todos_per_page") 
 pref_with_text_field('prefs', "sms_email") 
 pref('prefs', "sms_context") { select('prefs', 'sms_context_id', current_user.contexts.map{|c| [c.name, c.id]}) } 

 t('common.update') 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def update
    @prefs = current_user.prefs
    @user = current_user
    user_updated = current_user.update_attributes(user_params)
    prefs_updated = current_user.preference.update_attributes(prefs_params)
    if (user_updated && prefs_updated)
      if params['user']['password'].present? # password updated?
        logout_user t('preferences.password_changed')
      else
        preference_updated
      end
    else
      msg = "Preferences could not be updated: "
      msg += "User model errors; " unless user_updated
      msg += "Prefs model errors; " unless prefs_updated
      notify :warning, msg
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag "application", :media => "all" 
 stylesheet_link_tag "print", :media => "print" 
 javascript_include_tag "application" 
 csrf_meta_tags 
@source_view
 raw(protect_against_forgery? ? form_authenticity_token.inspect : "") 
 @tag_name ? @tag_name : "" 
 @group_view_by ? @group_view_by : "" 
 default_contexts_for_autocomplete.html_safe rescue '{}' 
 default_tags_for_autocomplete.html_safe rescue '{}' 
 date_format_for_date_picker 
 current_user.prefs.week_starts 
 root_url 
 if current_user.prefs.refresh != 0 
 current_user.prefs["refresh"].to_i*60000 
 end 
 unless controller.controller_name == 'feed' or session['noexpiry'] == "on" 
url_for(:controller => "login", :action => "check_expiry")
 end 
check_deferred_todos_path(:format => 'js')
 generate_i18n_strings 
 favicon_link_tag 'favicon.ico' 
 favicon_link_tag 'apple-touch-icon.png', :rel => 'apple-touch-icon', :type => 'image/png' 
 auto_discovery_link_tag(:rss, {:controller => "todos", :action => "index", :format => 'rss', :token => "#{current_user.token}"}, {:title => t('layouts.next_actions_rss_feed')}) 
 search_plugin_path(:format => :xml) 
 @page_title 
  if @count 
 @count 
 end 
 l(Time.zone.today, :format => current_user.prefs.title_date_format) 
 navigation_link(t('layouts.navigation.home'), root_path, {:accesskey => "t", :title => t('layouts.navigation.home_title')} ) 
 navigation_link(t('layouts.navigation.starred'), tag_path("starred"), :title => t('layouts.navigation.starred_title')) 
 navigation_link(t('common.projects'), projects_path, {:accesskey=>"p", :title=>t('layouts.navigation.projects_title')} ) 
 navigation_link(t('layouts.navigation.tickler'), tickler_path, {:accesskey =>"k", :title => t('layouts.navigation.tickler_title')} ) 
 t('layouts.navigation.organize') 
 navigation_link( t('common.contexts'), contexts_path, {:accesskey=>"c", :title=>t('layouts.navigation.contexts_title')} ) 
 navigation_link( t('common.notes'), notes_path, {:accesskey => "o", :title => t('layouts.navigation.notes_title')} ) 
 navigation_link( t('common.review'), review_path, {:accesskey => "r", :title => t('layouts.navigation.review_title')} ) 
 navigation_link( t('layouts.navigation.recurring_todos'), {:controller => "recurring_todos", :action => "index"}, :title => t('layouts.navigation.recurring_todos_title')) 
 t('layouts.navigation.view') 
 navigation_link( t('layouts.navigation.calendar'), calendar_path, :title => t('layouts.navigation.calendar_title')) 
 navigation_link( t('layouts.navigation.completed_tasks'), done_overview_path, {:accesskey=>"d", :title=>t('layouts.navigation.completed_tasks_title')} ) 
 navigation_link( t('layouts.navigation.feeds'), feeds_path, :title => t('layouts.navigation.feeds_title')) 
 navigation_link( t('layouts.navigation.stats'), stats_path, :title => t('layouts.navigation.stats_title')) 
 link_to(t('layouts.toggle_contexts'), "#", {:title => t('layouts.toggle_contexts_title'), :id => "toggle-contexts-nav"}) 
 link_to(t('layouts.toggle_notes'), "#", {:accesskey => "S", :title => t('layouts.toggle_notes_title'), :id => "toggle-notes-nav"}) 
 group_view_by_menu_entry 
 t('layouts.navigation.admin') 
 navigation_link( t('layouts.navigation.preferences'), preferences_path, {:accesskey => "u", :title => t('layouts.navigation.preferences_title')} ) 
 navigation_link( t('layouts.navigation.export'), data_path, {:accesskey => "e", :title => t('layouts.navigation.export_title')} ) 
 navigation_link( t('layouts.navigation.import'), import_data_path, {:accesskey => "i", :title => t('layouts.navigation.import_title')} ) 
 if current_user.is_admin? 
 navigation_link(t('layouts.navigation.manage_users'), users_path, {:accesskey => "a", :title => t('layouts.navigation.manage_users_title')} ) 
 end 
 t('layouts.navigation.help') 
 link_to t('layouts.navigation.integrations_'), integrations_path 
 link_to t('layouts.navigation.api_docs'), rest_api_docs_path 
 navigation_link(image_tag("system-search.png", :size => "16X16", :border => 0), search_path, :title => t('layouts.navigation.search')) 
 link_to("#{t('common.logout')} (#{current_user.display_name}) &raquo;".html_safe, logout_path) 
 
 controller.controller_name 
 render_flash 
 controller.controller_name 
  get_list_of_error_messages_for(@user)
 get_list_of_error_messages_for(@prefs)
 form_for(@prefs) do 
 t('preferences.tabs.profile')
 t('preferences.tabs.authentication')
 t('preferences.tabs.date_and_time')
 t('preferences.tabs.tracks_behavior')
  pref_with_text_field 'user', 'first_name' 
 pref_with_text_field 'user', 'last_name' 
 pref_with_select_field('prefs', 'locale', I18n.available_locales.map {|l| l.to_s}) 

  t('preferences.token_header') 
 t('preferences.token_description') 
 current_user.token 
 # TODO: make remote AJAX call for new token 
 link_to(
  t('preferences.generate_new_token'),
  refresh_token_user_path( current_user ),
  :method => :post,
  :data => {:confirm => t('preferences.generate_new_token_confirm')},
  :id=>'prefs_new_token') 
 if Tracks::Config.auth_schemes.length > 1 
 t('users.label_auth_type') 
 Tracks::Config.auth_schemes.each do |scheme| 
 radio_button_tag('user[auth_type]', scheme, current_user.auth_type == scheme) 
scheme
 end 
 end 
 current_user.auth_type == 'open_id' ? 'block' : 'none' 
 t('users.identity_url') 
 current_user.open_id_url 
 current_user.auth_type == 'database' ? 'block' : 'none' 
  t('users.new_password_label') 
 password_field "user", "password", :size => 40, :autocomplete => "off" 
 t('users.password_confirmation_label') 
 password_field "user", "password_confirmation", :size => 40, :autocomplete => "off" 
 

  pref_with_text_field('prefs', 'date_format') 
 l(Time.zone.today, :format => current_user.prefs.date_format) 
 %w{default short long longer}.each do |format| 
 radio_button_tag("date_picker1", t("date.formats.#{format}")) 
 l(Time.zone.today, :format => format.to_sym) 
 end 
 pref_with_text_field('prefs', 'title_date_format') 
 l(Time.zone.today, :format => current_user.prefs.title_date_format) 
 %w{default short long longer}.each do |format| 
 radio_button_tag("date_picker2", t("date.formats.#{format}")) 
 l(Time.zone.today, :format => format.to_sym) 
 end 
 pref('prefs', 'time_zone') { time_zone_select('prefs','time_zone') } 
 pref_with_select_field('prefs', "week_starts", (0..6).to_a.map {|num| [t('date.day_names')[num], num] }) 

  pref_with_select_field('prefs', "due_style", [[t('models.preference.due_styles')[0],Preference.due_styles[:due_in_n_days]],[t('models.preference.due_styles')[1],Preference.due_styles[:due_on]]]) 
 pref_with_select_field('prefs', "show_completed_projects_in_sidebar") 
 pref_with_select_field('prefs', "show_hidden_projects_in_sidebar") 
 pref_with_select_field('prefs', "show_hidden_contexts_in_sidebar") 
 pref_with_select_field('prefs', "show_project_on_todo_done") 
 pref_with_text_field('prefs', 'staleness_starts') 
 pref_with_text_field('prefs', 'review_period') 
 pref_with_text_field('prefs', 'show_number_completed') 
 pref_with_text_field('prefs', 'refresh') 
 pref_with_select_field('prefs', "verbose_action_descriptors") 
 pref_with_text_field('prefs', "mobile_todos_per_page") 
 pref_with_text_field('prefs', "sms_email") 
 pref('prefs', "sms_context") { select('prefs', 'sms_context_id', current_user.contexts.map{|c| [c.name, c.id]}) } 

 t('common.update') 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

    end
  end

  def render_date_format
    format = params[:date_format]
    render :text => l(Date.current, :format => format)
  end

private

  def prefs_params
    params.require(:prefs).permit(
      :date_format, :week_starts, :show_number_completed,
      :show_completed_projects_in_sidebar, :show_hidden_contexts_in_sidebar,
      :staleness_starts, :due_style, :locale, :title_date_format, :time_zone,
      :show_hidden_projects_in_sidebar, :show_project_on_todo_done,
      :review_period, :refresh, :verbose_action_descriptors,
      :mobile_todos_per_page, :sms_email, :sms_context_id)
  end

  def user_params
    params.require(:user).permit(:login, :first_name, :last_name, :password_confirmation, :password, :auth_type, :open_id_url)
  end

  # Display notification if preferences are successful updated
  def preference_updated
    notify :notice, t('preferences.updated')
    redirect_to :action => 'index'
  end

end
