class TodosController < ApplicationController

  skip_before_filter :login_required, :only => [:index, :tag]
  prepend_before_filter :login_or_feed_token_required, :only => [:index, :tag]
  append_before_filter :find_and_activate_ready, :only => [:index, :list_deferred]

  protect_from_forgery :except => :check_deferred

  def index
    @source_view = params['_source_view'] || 'todo'

    init_data_for_sidebar unless mobile?

    @todos = current_user.todos.includes(Todo::DEFAULT_INCLUDES)
    @todos = @todos.limit(sanitize(params[:limit])) if params[:limit]

    @not_done_todos = get_not_done_todos

    @projects = current_user.projects.includes(:default_context)
    @contexts = current_user.contexts
    @contexts_to_show = current_user.contexts.active
    @projects_to_show = current_user.projects.active

    # If you've set no_completed to zero, the completed items box isn't shown
    # on the home page
    max_completed = current_user.prefs.show_number_completed
    @done = current_user.todos.completed.limit(max_completed).includes(Todo::DEFAULT_INCLUDES) unless max_completed == 0

    respond_to do |format|
      format.html  do
        @page_title = t('todos.task_list_title')
        # Set count badge to number of not-done, not hidden context items
        @count = current_user.todos.active.not_hidden.count(:all)
        @todos_without_project = @not_done_todos.select{|t|t.project.nil?}
      end
      format.m do
        @page_title = t('todos.mobile_todos_page_title')
        @home = true

        cookies[:mobile_url]= { :value => request.fullpath, :secure => SITE_CONFIG['secure_cookies']}
        determine_down_count

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
  TRACKS_VERSION 
 ENV['TZ'] || 'GMT' 
 Time.now.strftime("%Y%m%dT%H%M%SZ") 
 ENV['TZ'] 
 for @todo in @todos 
 @todo.created_at.strftime("%Y%m%dT%H%M%SZ") 
 @todo.created_at.strftime("%Y%m%d") 
 @todo.description 
 todo_url(@todo) 
 if @todo.notes? 
 format_ical_notes(@todo.notes) 
 end 
 if @todo.due 
 @todo.due.strftime("%Y%m%d") 
 end 
 if @todo.project_id 
 project_url(@todo.project) 
 else 
 context_url(@todo.context) 
 end 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

      end
      format.text  do
        # somehow passing Mime::TEXT using content_type to render does not work
        headers['Content-Type'.freeze]=Mime::TEXT.to_s
        render :content_type => Mime::TEXT
      end
      format.xml do
        @xml_todos = params[:limit_to_active_todos] ? @not_done_todos : @todos
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
  TRACKS_VERSION 
 ENV['TZ'] || 'GMT' 
 Time.now.strftime("%Y%m%dT%H%M%SZ") 
 ENV['TZ'] 
 for @todo in @todos 
 @todo.created_at.strftime("%Y%m%dT%H%M%SZ") 
 @todo.created_at.strftime("%Y%m%d") 
 @todo.description 
 todo_url(@todo) 
 if @todo.notes? 
 format_ical_notes(@todo.notes) 
 end 
 if @todo.due 
 @todo.due.strftime("%Y%m%d") 
 end 
 if @todo.project_id 
 project_url(@todo.project) 
 else 
 context_url(@todo.context) 
 end 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

      end
      format.any(:rss, :atom) do
        @feed_title = 'Tracks Actions'.freeze
        @feed_description = "Actions for #{current_user.display_name}"
      end
      format.ics
    end
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
  TRACKS_VERSION 
 ENV['TZ'] || 'GMT' 
 Time.now.strftime("%Y%m%dT%H%M%SZ") 
 ENV['TZ'] 
 for @todo in @todos 
 @todo.created_at.strftime("%Y%m%dT%H%M%SZ") 
 @todo.created_at.strftime("%Y%m%d") 
 @todo.description 
 todo_url(@todo) 
 if @todo.notes? 
 format_ical_notes(@todo.notes) 
 end 
 if @todo.due 
 @todo.due.strftime("%Y%m%d") 
 end 
 if @todo.project_id 
 project_url(@todo.project) 
 else 
 context_url(@todo.context) 
 end 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def new
    @projects = current_user.projects.active
    @contexts = current_user.contexts
    respond_to do |format|
      format.m {
        @new_mobile = true
        @return_path=cookies[:mobile_url] ? cookies[:mobile_url] : mobile_path
        @mobile_from_context = current_user.contexts.find(params[:from_context]) if params[:from_context]
        @mobile_from_project = current_user.projects.find(params[:from_project]) if params[:from_project]
        if params[:from_project] && !params[:from_context]
          # we have a project but not a context -> use the default context
          @mobile_from_context = @mobile_from_project.default_context
        end
      }
    end
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
  form_tag todos_path(:format => 'm'), :method => :post do 
  todo = edit_form 
 form_for(todo, :html=> { :name=>'todo', :id => dom_id(@todo, 'form'), :class => 'inline-form edit_todo_form' }) do |t|
 if todo.errors.any? 
 todo.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 t.hidden_field( "id" ) 
 source_view_tag( @source_view ) 
 content_tag(:input, "", :type=>"hidden", :name=>"_tag_name", :value=>"#{@tag_name}") if @tag_name 
 dom_id(@todo, 'description') 
 t('common.description') 
 t.text_field( "description", "size" => 30, "maxlength" => 100) 
 dom_id(@todo, 'notes') 
 t('common.notes') 
 t.text_area( "notes", "cols" => 29, "rows" => 4) 
 dom_id(@todo, 'project_name') 
 t('common.project') 
 dom_id(@todo, 'project_name') 
 @todo.project.nil? ? '' : h(@todo.project.name) 
 dom_id(@todo, 'context_name') 
 t('common.context')  
 dom_id(@todo, 'context_name') 
 h @todo.context.name 
 dom_id(@todo, 'tag_list') 
 t('todos.tags') 
 text_field_tag 'tag_list', tag_list_text, :id => dom_id(@todo, 'tag_list'), :size => 30 
 dom_id(@todo, 'due_label') 
 Todo.human_attribute_name('due') 
 date_field_tag("todo[due]", dom_id(@todo, 'due'), format_date(@todo.due)) 
 dom_id(@todo, 'due_x') 
 t('todos.clear_due_date') 
 image_tag("blank.png", :alt => t('todos.clear_due_date'), :class => "delete_item") 
 dom_id(@todo, 'show_from') 
 t('todos.show_from') 
 date_field_tag("todo[show_from]", dom_id(@todo, 'show_from'), format_date(@todo.show_from)) 
 dom_id(@todo, 'show_from_x') 
 t('todos.clear_show_from_date') 
 image_tag("blank.png", :alt => t('todos.clear_show_from_date'), :class => "delete_item") 
 Todo.human_attribute_name('predecessors')
 @todo.predecessors.empty? ? "none" : "block"
 t('todos.add_another_dependency')
 text_field_tag "predecessor_input", nil, :size => 30 
 hidden_field_tag "predecessor_list", @todo.predecessors.map{|t| t.id.to_s}.join(', ') 
 dom_id(@todo, 'submit') 
image_tag("accept.png", :alt => "") 
 t('common.update') 
image_tag("cancel.png", :alt => "") 
 t('common.cancel') 
 end 
 
 end 
 link_to t('common.back'), @return_path 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def create
    @source_view = params['_source_view'] || 'todo'
    @default_context = current_user.contexts.where(:name => params['default_context_name']).first
    @default_project = current_user.projects.where(:name => params['default_project_name']).first if params['default_project_name'].present?

    @tag_name = params['_tag_name']

    is_multiple = params[:todo] && params[:todo][:multiple_todos] && !params[:todo][:multiple_todos].nil?
    if is_multiple
      create_multiple
    else
      p = Todos::TodoCreateParamsHelper.new(params, current_user)
      p.parse_dates unless mobile?
      tag_list = p.tag_list

      @todo = current_user.todos.build
      @todo.assign_attributes(p.attributes)
      p.add_errors(@todo)

      if @todo.errors.empty?
        @todo.add_predecessor_list(p.predecessor_list)
        @saved = @todo.save
        @todo.tag_with(tag_list) if @saved && tag_list.present?
        @todo.update_state_from_project if @saved
        @todo.block! if @todo.should_be_blocked?
      else
        @saved = false
      end

      @todo_was_created_deferred = @todo.deferred?
      @todo_was_created_blocked = @todo.pending?
      @not_done_todos = [@todo] if p.new_project_created || p.new_context_created
      @new_project_created = p.new_project_created
      @new_context_created = p.new_context_created

      respond_to do |format|
        format.html do
          redirect_to :action => "index"
        end
        format.m do
          @return_path=cookies[:mobile_url] ? cookies[:mobile_url] : mobile_path
          if @saved
            onsite_redirect_to @return_path
          else
            @projects = current_user.projects
            @contexts = current_user.contexts
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
  form_tag todos_path(:format => 'm'), :method => :post do 
  todo = edit_form 
 form_for(todo, :html=> { :name=>'todo', :id => dom_id(@todo, 'form'), :class => 'inline-form edit_todo_form' }) do |t|
 if todo.errors.any? 
 todo.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 t.hidden_field( "id" ) 
 source_view_tag( @source_view ) 
 content_tag(:input, "", :type=>"hidden", :name=>"_tag_name", :value=>"#{@tag_name}") if @tag_name 
 dom_id(@todo, 'description') 
 t('common.description') 
 t.text_field( "description", "size" => 30, "maxlength" => 100) 
 dom_id(@todo, 'notes') 
 t('common.notes') 
 t.text_area( "notes", "cols" => 29, "rows" => 4) 
 dom_id(@todo, 'project_name') 
 t('common.project') 
 dom_id(@todo, 'project_name') 
 @todo.project.nil? ? '' : h(@todo.project.name) 
 dom_id(@todo, 'context_name') 
 t('common.context')  
 dom_id(@todo, 'context_name') 
 h @todo.context.name 
 dom_id(@todo, 'tag_list') 
 t('todos.tags') 
 text_field_tag 'tag_list', tag_list_text, :id => dom_id(@todo, 'tag_list'), :size => 30 
 dom_id(@todo, 'due_label') 
 Todo.human_attribute_name('due') 
 date_field_tag("todo[due]", dom_id(@todo, 'due'), format_date(@todo.due)) 
 dom_id(@todo, 'due_x') 
 t('todos.clear_due_date') 
 image_tag("blank.png", :alt => t('todos.clear_due_date'), :class => "delete_item") 
 dom_id(@todo, 'show_from') 
 t('todos.show_from') 
 date_field_tag("todo[show_from]", dom_id(@todo, 'show_from'), format_date(@todo.show_from)) 
 dom_id(@todo, 'show_from_x') 
 t('todos.clear_show_from_date') 
 image_tag("blank.png", :alt => t('todos.clear_show_from_date'), :class => "delete_item") 
 Todo.human_attribute_name('predecessors')
 @todo.predecessors.empty? ? "none" : "block"
 t('todos.add_another_dependency')
 text_field_tag "predecessor_input", nil, :size => 30 
 hidden_field_tag "predecessor_list", @todo.predecessors.map{|t| t.id.to_s}.join(', ') 
 dom_id(@todo, 'submit') 
image_tag("accept.png", :alt => "") 
 t('common.update') 
image_tag("cancel.png", :alt => "") 
 t('common.cancel') 
 end 
 
 end 
 link_to t('common.back'), @return_path 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

          end
        end
        format.js do
          if @saved
            determine_down_count
            @contexts = current_user.contexts
            @projects = current_user.projects
            @context = @todo.context
            @project = @todo.project
            @initial_context_name = params['default_context_name']
            @initial_project_name = params['default_project_name']
            @initial_tags = params['initial_tag_list']
            @status_message = t('todos.added_new_next_action')
            @status_message += ' ' + t('todos.to_tickler') if @todo.deferred?
            @status_message += ' ' + t('todos.in_pending_state') if @todo.pending?
            @status_message += ' ' + t('todos.in_hidden_state') if @todo.hidden?
            @status_message = t('todos.added_new_project') + ' / ' + @status_message if @new_project_created
            @status_message = t('todos.added_new_context') + ' / ' + @status_message if @new_context_created
          end
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
  unless @saved 
 js_error_messages_for(@todo) 
 else

  animation = []
  if should_show_new_item
    if should_add_new_container
      animation << "insert_new_container_with_new_todo";
    else
      animation << "add_todo_to_existing_container";
    end
  end
  animation << "remove_empty_message_container";
  animation << "update_predecessors";
  animation << "clear_form";

 render_animation(animation) 
escape_javascript @status_message
 @down_count 
escape_javascript @initial_context_name
escape_javascript @initial_project_name
escape_javascript @initial_tags

      empty_id = '#no_todos_in_view'
      empty_id = '#deferred_pending_container-empty-d' if source_view_is :tickler
    
empty_id
 empty_container_msg_div_id 
 item_container_id(@todo) 
 item_container_id(@todo) 
 dom_id(@todo) 
  @todo.uncompleted_predecessors.each do |p| 
item_container_id(p)
dom_id(p)
 js_render(p, { :parent_container_type => parent_container_type, :source_view => @source_view })
 end 

      want_render = @group_view_by == 'project' ? @new_project_created : @new_context_created
      container   = @group_view_by == 'project' ? @todo.project        : @todo.context
    
 want_render ? js_render(container, { :settings => {:collapsible => true} }) : "" 
 @saved ? js_render(@todo, { :parent_container_type => parent_container_type, :source_view => @source_view }) : "" 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

        end
        format.xml do
          if @saved
            head :created, :location => todo_url(@todo)
          else
            render_failure @todo.errors.to_xml.html_safe, 409
          end
        end
      end
    end
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
  unless @saved 
 js_error_messages_for(@todo) 
 else

  animation = []
  if should_show_new_item
    if should_add_new_container
      animation << "insert_new_container_with_new_todo";
    else
      animation << "add_todo_to_existing_container";
    end
  end
  animation << "remove_empty_message_container";
  animation << "update_predecessors";
  animation << "clear_form";

 render_animation(animation) 
escape_javascript @status_message
 @down_count 
escape_javascript @initial_context_name
escape_javascript @initial_project_name
escape_javascript @initial_tags

      empty_id = '#no_todos_in_view'
      empty_id = '#deferred_pending_container-empty-d' if source_view_is :tickler
    
empty_id
 empty_container_msg_div_id 
 item_container_id(@todo) 
 item_container_id(@todo) 
 dom_id(@todo) 
  @todo.uncompleted_predecessors.each do |p| 
item_container_id(p)
dom_id(p)
 js_render(p, { :parent_container_type => parent_container_type, :source_view => @source_view })
 end 

      want_render = @group_view_by == 'project' ? @new_project_created : @new_context_created
      container   = @group_view_by == 'project' ? @todo.project        : @todo.context
    
 want_render ? js_render(container, { :settings => {:collapsible => true} }) : "" 
 @saved ? js_render(@todo, { :parent_container_type => parent_container_type, :source_view => @source_view }) : "" 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def create_multiple
    p = Todos::TodoCreateParamsHelper.new(params, current_user)
    tag_list = p.tag_list

    @not_done_todos = []
    @build_todos = []
    @todos = []
    errors = []
    @predecessor = nil
    validates = true

    # first build all todos and check if they would validate on save
    params[:todo][:multiple_todos].split("\n").map do |line|
      if line.present? #ignore blank lines
        @todo = current_user.todos.build({:description => line, :context_id => p.context_id, :project_id => p.project_id})
        validates &&= @todo.valid?

        @build_todos << @todo
      end
    end

    # if all todos validate, then save them and add predecessors and tags
    if validates
      @build_todos.each do |todo|
        @saved = todo.save
        validates &&= @saved

        if @predecessor && @saved && p.sequential?
          todo.add_predecessor(@predecessor)
          todo.block!
        end

        todo.tag_with(tag_list) if @saved && tag_list.present?

        @todos << todo
        @not_done_todos << todo if p.new_context_created || p.new_project_created
        @predecessor = todo
      end
    else
      @todos = @build_todos
      @saved = false
    end

    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.js do
        determine_down_count if @saved
        @contexts = current_user.contexts if p.new_context_created
        @projects = current_user.projects if p.new_project_created
        @new_project_created = p.new_project_created
        @new_context_created = p.new_context_created
        @initial_context_name = params['default_context_name']
        @initial_project_name = params['default_project_name']
        @initial_tags = params['initial_tag_list']
        if @saved && @todos.size > 0
          @default_tags = @todos[0].project.default_tags unless @todos[0].project.nil?
        else
          @multiple_error = @todos.size > 0 ? "" : t('todos.next_action_needed')
          @saved = false
          @default_tags = current_user.projects.where(:name => @initial_project_name).default_tags if @initial_project_name.present?
        end

        @status_message = @todos.size > 1 ? t('todos.added_new_next_action_plural') : t('todos.added_new_next_action_singular')
        @status_message = t('todos.added_new_project') + ' / ' + @status_message if p.new_project_created
        @status_message = t('todos.added_new_context') + ' / ' + @status_message if p.new_context_created

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
  unless @saved 

      # add error about missing todo description that is not available in @todos
      @multiple_error = content_tag(:div, content_tag(:p, @multiple_error), {:class => 'errorExplanation', :id => 'errorExplanation'}) if @multiple_error.present?
      error_messages = @multiple_error || ""
      # add errors of individual @todos
      @todos.each do |todo|
        error_messages += get_list_of_error_messages_for(todo)
      end
    
 escape_javascript(error_messages.html_safe)
 else 
@status_message
 @down_count 
 if should_show_new_item 
 if @new_context_created 
 else 
 end 
 end 
escape_javascript @initial_context_name
escape_javascript @initial_project_name
escape_javascript @initial_tags
 if (source_view_is :project and @todo.pending?) or (source_view_is :deferred) 
 else 
 end 

    @todos.each do |todo|
      if should_show_new_item(todo)
        html = js_render(todo, { :parent_container_type => parent_container_type, :source_view => @source_view })
        
 empty_container_msg_div_id(todo) 
 item_container_id(todo) 
 html 
 item_container_id(todo) 
 dom_id(todo) 
 end 
 end 
 @new_context_created ? js_render(@todo.context, { :settings => {:collapsible => true} }) : "" 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

      end
      format.xml do
        if @saved
          head :created, :location => context_url(@todos[0].context)
        else
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
  unless @saved 

      # add error about missing todo description that is not available in @todos
      @multiple_error = content_tag(:div, content_tag(:p, @multiple_error), {:class => 'errorExplanation', :id => 'errorExplanation'}) if @multiple_error.present?
      error_messages = @multiple_error || ""
      # add errors of individual @todos
      @todos.each do |todo|
        error_messages += get_list_of_error_messages_for(todo)
      end
    
 escape_javascript(error_messages.html_safe)
 else 
@status_message
 @down_count 
 if should_show_new_item 
 if @new_context_created 
 else 
 end 
 end 
escape_javascript @initial_context_name
escape_javascript @initial_project_name
escape_javascript @initial_tags
 if (source_view_is :project and @todo.pending?) or (source_view_is :deferred) 
 else 
 end 

    @todos.each do |todo|
      if should_show_new_item(todo)
        html = js_render(todo, { :parent_container_type => parent_container_type, :source_view => @source_view })
        
 empty_container_msg_div_id(todo) 
 item_container_id(todo) 
 html 
 item_container_id(todo) 
 dom_id(todo) 
 end 
 end 
 @new_context_created ? js_render(@todo.context, { :settings => {:collapsible => true} }) : "" 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

        end
      end
    end
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
  unless @saved 

      # add error about missing todo description that is not available in @todos
      @multiple_error = content_tag(:div, content_tag(:p, @multiple_error), {:class => 'errorExplanation', :id => 'errorExplanation'}) if @multiple_error.present?
      error_messages = @multiple_error || ""
      # add errors of individual @todos
      @todos.each do |todo|
        error_messages += get_list_of_error_messages_for(todo)
      end
    
 escape_javascript(error_messages.html_safe)
 else 
@status_message
 @down_count 
 if should_show_new_item 
 if @new_context_created 
 else 
 end 
 end 
escape_javascript @initial_context_name
escape_javascript @initial_project_name
escape_javascript @initial_tags
 if (source_view_is :project and @todo.pending?) or (source_view_is :deferred) 
 else 
 end 

    @todos.each do |todo|
      if should_show_new_item(todo)
        html = js_render(todo, { :parent_container_type => parent_container_type, :source_view => @source_view })
        
 empty_container_msg_div_id(todo) 
 item_container_id(todo) 
 html 
 item_container_id(todo) 
 dom_id(todo) 
 end 
 end 
 @new_context_created ? js_render(@todo.context, { :settings => {:collapsible => true} }) : "" 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def edit
    @todo = current_user.todos.find(params['id'])
    @source_view = params['_source_view'] || 'todo'
    @tag_name = params['_tag_name']
    respond_to do |format|
      format.js
      format.m {
        @projects = current_user.projects.active
        @contexts = current_user.contexts
        @edit_mobile = true
        @return_path=cookies[:mobile_url] ? cookies[:mobile_url] : mobile_path
      }
    end
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
  form_tag todo_path(@todo, :format => 'm'), :name => 'mobileEdit', :method => :put do 
  todo = edit_form 
 form_for(todo, :html=> { :name=>'todo', :id => dom_id(@todo, 'form'), :class => 'inline-form edit_todo_form' }) do |t|
 if todo.errors.any? 
 todo.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 t.hidden_field( "id" ) 
 source_view_tag( @source_view ) 
 content_tag(:input, "", :type=>"hidden", :name=>"_tag_name", :value=>"#{@tag_name}") if @tag_name 
 dom_id(@todo, 'description') 
 t('common.description') 
 t.text_field( "description", "size" => 30, "maxlength" => 100) 
 dom_id(@todo, 'notes') 
 t('common.notes') 
 t.text_area( "notes", "cols" => 29, "rows" => 4) 
 dom_id(@todo, 'project_name') 
 t('common.project') 
 dom_id(@todo, 'project_name') 
 @todo.project.nil? ? '' : h(@todo.project.name) 
 dom_id(@todo, 'context_name') 
 t('common.context')  
 dom_id(@todo, 'context_name') 
 h @todo.context.name 
 dom_id(@todo, 'tag_list') 
 t('todos.tags') 
 text_field_tag 'tag_list', tag_list_text, :id => dom_id(@todo, 'tag_list'), :size => 30 
 dom_id(@todo, 'due_label') 
 Todo.human_attribute_name('due') 
 date_field_tag("todo[due]", dom_id(@todo, 'due'), format_date(@todo.due)) 
 dom_id(@todo, 'due_x') 
 t('todos.clear_due_date') 
 image_tag("blank.png", :alt => t('todos.clear_due_date'), :class => "delete_item") 
 dom_id(@todo, 'show_from') 
 t('todos.show_from') 
 date_field_tag("todo[show_from]", dom_id(@todo, 'show_from'), format_date(@todo.show_from)) 
 dom_id(@todo, 'show_from_x') 
 t('todos.clear_show_from_date') 
 image_tag("blank.png", :alt => t('todos.clear_show_from_date'), :class => "delete_item") 
 Todo.human_attribute_name('predecessors')
 @todo.predecessors.empty? ? "none" : "block"
 t('todos.add_another_dependency')
 text_field_tag "predecessor_input", nil, :size => 30 
 hidden_field_tag "predecessor_list", @todo.predecessors.map{|t| t.id.to_s}.join(', ') 
 dom_id(@todo, 'submit') 
image_tag("accept.png", :alt => "") 
 t('common.update') 
image_tag("cancel.png", :alt => "") 
 t('common.cancel') 
 end 
 
 end 
 link_to t('common.cancel'), @return_path 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def show
    @todo = current_user.todos.find(params['id'])
    respond_to do |format|
      format.m { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  t('common.description') 
 @todo.description 
 t('common.actions') 
 edit_todo_path(@todo, :format => :m)
t('todos.edit_action')
toggle_star_todo_path(@todo, :format=>:m)
t('todos.star_action')
 token_tag 
toggle_check_todo_path(@todo, :format=>:m)
 t('todos.mark_complete')
 token_tag 
defer_todo_path(@todo, :format=>:m, :days => 1)
t('todos.defer_x_days', :count => 1)
 token_tag 
defer_todo_path(@todo, :format=>:m, :days => 2)
t('todos.defer_x_days', :count => 2)
 token_tag 
defer_todo_path(@todo, :format=>:m, :days => 3)
t('todos.defer_x_days', :count => 3)
 token_tag 
defer_todo_path(@todo, :format=>:m, :days => 7)
t('todos.defer_x_days', :count => 7)
 token_tag 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end
 }
      format.xml { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  t('common.description') 
 @todo.description 
 t('common.actions') 
 edit_todo_path(@todo, :format => :m)
t('todos.edit_action')
toggle_star_todo_path(@todo, :format=>:m)
t('todos.star_action')
 token_tag 
toggle_check_todo_path(@todo, :format=>:m)
 t('todos.mark_complete')
 token_tag 
defer_todo_path(@todo, :format=>:m, :days => 1)
t('todos.defer_x_days', :count => 1)
 token_tag 
defer_todo_path(@todo, :format=>:m, :days => 2)
t('todos.defer_x_days', :count => 2)
 token_tag 
defer_todo_path(@todo, :format=>:m, :days => 3)
t('todos.defer_x_days', :count => 3)
 token_tag 
defer_todo_path(@todo, :format=>:m, :days => 7)
t('todos.defer_x_days', :count => 7)
 token_tag 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end
 }
    end
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
  t('common.description') 
 @todo.description 
 t('common.actions') 
 edit_todo_path(@todo, :format => :m)
t('todos.edit_action')
toggle_star_todo_path(@todo, :format=>:m)
t('todos.star_action')
 token_tag 
toggle_check_todo_path(@todo, :format=>:m)
 t('todos.mark_complete')
 token_tag 
defer_todo_path(@todo, :format=>:m, :days => 1)
t('todos.defer_x_days', :count => 1)
 token_tag 
defer_todo_path(@todo, :format=>:m, :days => 2)
t('todos.defer_x_days', :count => 2)
 token_tag 
defer_todo_path(@todo, :format=>:m, :days => 3)
t('todos.defer_x_days', :count => 3)
 token_tag 
defer_todo_path(@todo, :format=>:m, :days => 7)
t('todos.defer_x_days', :count => 7)
 token_tag 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def add_predecessor
    @source_view = params['_source_view'] || 'todo'
    @predecessor = current_user.todos.find(params['predecessor'])
    @predecessors = @predecessor.predecessors
    @todo = current_user.todos.includes(Todo::DEFAULT_INCLUDES).find(params['successor'])
    @original_state = @todo.state
    unless @predecessor.completed?
      begin
        @todo.add_predecessor(@predecessor)
        @todo.block! unless @todo.pending?
        @saved = @todo.save
      rescue ActiveRecord::RecordInvalid
        @saved = false
      end

      @status_message = t('todos.added_dependency', :dependency => @predecessor.description)
      @status_message += t('todos.set_to_pending', :task => @todo.description) unless @original_state == 'pending'
    else
      @saved = false
    end
    respond_to do |format|
      format.js
    end
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
  if !@saved
    if @predecessor.completed? 
 t('todos.cannot_add_dependency_to_completed_todo') 
dom_id(@todo)
  else 
 t('todos.unable_to_add_dependency') 
  end
   else 
 "show_in_tickler_box();".html_safe if source_view_is_one_of :project, :tag, :context 
 @status_message 
 # TODO: last todo in context --> remove context?? 
dom_id(@todo)
 dom_id(@predecessor) 

  parents = @predecessors.to_a
  until parents.empty?
    parent = parents.pop
    parents += parent.predecessors 
 dom_id(parent) 
 js_render(parent, { :parent_container_type => parent_container_type }) 
end
 js_render(@predecessor, { :parent_container_type => parent_container_type }) 
 end # if !@saved

# following js is needed in case of an error with dragging onto a completed action althoug

 js_render(@todo, { :parent_container_type => parent_container_type }) 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def remove_predecessor
    @source_view = params['_source_view'] || 'todo'
    @todo = current_user.todos.includes(Todo::DEFAULT_INCLUDES).find(params['id'])
    @predecessor = current_user.todos.find(params['predecessor'])
    @predecessors = @predecessor.predecessors
    @successor = @todo
    @removed = @successor.remove_predecessor(@predecessor)
    determine_remaining_in_container_count(@todo)
    respond_to do |format|
      format.js
    end
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
  # TODO: lots of overlap with add_predecessor --> helpers?
  if @removed 
 t('todos.removed_predecessor', :successor => @successor.description, :predecessor => @predecessor.description) 
 else 
t('todos.error_removing_dependency')
 end 
 dom_id(@predecessor) 

  parents = @predecessors.to_a
  until parents.empty?
    parent = parents.pop
    parents += parent.predecessors 
 dom_id(parent) 
 js_render(parent, { :parent_container_type => parent_container_type }) 
end 

  if @successor.active? 
 "remove_successor();" unless source_view_is(:todo) 
 "hide_empty_message();" unless empty_container_msg_div_id.nil? 
 "show_empty_deferred_message(); " if @remaining_deferred_or_pending_count == 0 
 if source_view_is_one_of(:todo, :deferred, :tag) 
 @successor.context_id 
 end 
item_container_id(@successor)
 dom_id(@successor, 'line')

  elsif @successor.deferred? 
 dom_id(@successor)

  end
  
empty_container_msg_div_id
 # TODO: last todo in context --> remove context?? 
dom_id(@successor)
 @removed ? js_render(@predecessor, { :parent_container_type => parent_container_type }) : "" 
 @removed ? js_render(@successor, { :parent_container_type => parent_container_type }) : "" 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  # Toggles the 'done' status of the action
  #
  def toggle_check
    @todo = current_user.todos.find(params['id'])

    @source_view = params['_source_view'] || 'todo'

    @original_item = current_user.todos.build(@todo.attributes)  # create a (unsaved) copy of the original todo
    @original_item_due = @todo.due
    @original_item_was_deferred = @todo.deferred?
    @original_item_was_pending = @todo.pending?
    @original_item_was_hidden = @todo.hidden?
    @original_item_context_id = @todo.context_id
    @original_item_project_id = @todo.project_id
    @original_completed_period = DoneTodos.completed_period(@todo.completed_at)
    @todo_was_completed_from_deferred_or_blocked_state = @original_item_was_deferred || @original_item_was_pending

    @saved = @todo.toggle_completion!

    @todo_was_blocked_from_completed_state = @todo.pending? # since we toggled_completion the previous state was completed

    # check if this todo has a related recurring_todo. If so, create next todo
    @new_recurring_todo = check_for_next_todo(@todo) if @saved

    @predecessors = @todo.uncompleted_predecessors
    if @saved
      if @todo.completed?
        @pending_to_activate = @todo.activate_pending_todos
      else
        @active_to_block = @todo.block_successors
      end
    end

    respond_to do |format|
      format.js do
        if @saved
          determine_remaining_in_container_count(@todo)
          determine_down_count
          determine_completed_count
          determine_deferred_tag_count(params['_tag_name']) if source_view_is(:tag)
          @wants_redirect_after_complete = @todo.completed?  && !@todo.project_id.nil? && current_user.prefs.show_project_on_todo_done && !source_view_is(:project)
          if source_view_is :calendar
            @original_item_due_id = get_due_id_for_calendar(@original_item_due)
            @old_due_empty = is_old_due_empty(@original_item_due_id)
          end
        end
        render
      end
      format.xml { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  unless @saved 
 t('todos.error_toggle_complete') 
 else
  # create a unique object name to prevent concurrent toggles to overwrite each other functions
  object_name = unique_object_name_for("toggle_check")

 object_name 
 if @wants_redirect_after_complete && @todo.completed? 
object_name
 else
      animation = []
      unless source_view_is(:search)
        animation << "remove_todo"
        if @todo.completed?
          animation << "add_to_completed_container" unless source_view_is_one_of(:calendar, :deferred)
          animation << "add_new_recurring_todo"
          animation << "activate_pending_todos"
        else
          animation << "add_todo_to_container" unless source_view_is(:done)
          animation << "block_predecessors"
        end
        animation << "update_empty_container" if source_view_is_one_of(:tag, :todo, :deferred, :project, :context)
        animation << "regenerate_predecessor_family"
      else
        animation << "replace_todo"
      end 
 render_animation(animation, object_name) 
 @down_count 
 end 
 @todo.project_id.nil? ? root_path : project_path(@todo.project) 
 if update_needs_to_hide_container
      # remove context with deleted todo
    
 item_container_id(@original_item)
dom_id(@todo)
 show_empty_message_in_source_container 
 else
      # remove only the todo
    
 show_empty_message_in_source_container 
dom_id(@todo)
dom_id(@todo)
 end 
 unless current_user.prefs.hide_completed_actions? 
 item_container_id(@todo) 
object_name
object_name
 end 
 dom_id(@todo) 
object_name
 item_container_id(@todo) 
object_name
 if should_make_context_visible 
 item_container_id(@todo) 
 empty_container_msg_div_id 
object_name
 else 
 empty_container_msg_div_id(@todo) 
object_name
 end 
 if @completed_count == 0 
 end 
  # show new todo if the completed todo was recurring
      if @todo.from_recurring_todo?
        unless @new_recurring_todo.nil? || (@new_recurring_todo.deferred? && !source_view_is(:deferred)) 
 item_container_id(@new_recurring_todo) 
object_name
 @new_recurring_todo.context_id 
object_name
 else
          if @todo.recurring_todo.todos.active.count(:all) == 0 && @new_recurring_todo.nil? 
t('todos.recurrence_completed')
   end 
 end
      else 
 end 
 if @down_count==0 
 else 
 end 
 if @new_recurring_todo # hide js if @new_recurring_todo is not there
 dom_id(@new_recurring_todo)
 end 
 dom_id(@todo)
 # Activate pending todos that are successors of the completed
      if @pending_to_activate
        # do not render the js in case of an error or if no todos to activate
        @pending_to_activate.each do |t|
          html = escape_javascript(render(:partial => t, :locals => { :parent_container_type => parent_container_type }))
          # only project and tag view have a deferred/blocked container
          if source_view_is_one_of(:project,:tag) 
 dom_id(t) 
 dom_id(t) 
 item_container_id(t) 
 html  
 "$('#deferred_pending_container-empty-d').show();".html_safe if @remaining_deferred_or_pending_count==0 
     else 
 item_container_id(t) 
 html
     end 
 dom_id(t)
   end 
 end 
 # Block active todos that are successors of the uncompleted
      if @saved && @active_to_block
        # do not render the js in case of an error or if no todos to block
        @active_to_block.each do |t| 
 dom_id(t) 
 dom_id(t) 
       if source_view_is(:project) or source_view_is(:tag) # Insert it in deferred/pending block if existing 
 item_container_id(t) 
 js_render(t, { :parent_container_type => parent_container_type }) 
       end 
   end 
 end 

    if @predecessors
      parents = @predecessors.to_a
      until parents.empty?
        parent = parents.pop
        parents += parent.predecessors 
 dom_id(parent) 
 js_render(parent, { :parent_container_type => parent_container_type }) 
end
    end
    

      js = @new_recurring_todo ? js_render(@new_recurring_todo, { :parent_container_type => parent_container_type }) : ""
    
 js 

      locals = {
        :parent_container_type => parent_container_type,
        :suppress_project => source_view_is(:project),
        :suppress_context => source_view_is(:context)
      }
      js = source_view_is(:done) ? "" : js_render(@todo, locals)
    
 js 
object_name
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end
 }
      format.html do
        if @saved
          # TODO: I think this will work, but can't figure out how to test it
          notify(:notice, t("todos.action_marked_complete", :description => @todo.description, :completed => @todo.completed? ? 'complete' : 'incomplete'))
          redirect_to :action => "index"
        else
          notify(:notice, t("todos.action_marked_complete_error", :description => @todo.description, :completed => @todo.completed? ? 'complete' : 'incomplete'), "index")
          redirect_to :action =>  "index"
        end
      end
      format.m {
        if @saved
          if cookies[:mobile_url]
            old_path = cookies[:mobile_url]
            cookies[:mobile_url] = {:value => nil, :secure => SITE_CONFIG['secure_cookies']}
            notify(:notice, t("todos.action_marked_complete", :description => @todo.description, :completed => @todo.completed? ? 'complete' : 'incomplete'))
            onsite_redirect_to old_path
          else
            notify(:notice, t("todos.action_marked_complete", :description => @todo.description, :completed => @todo.completed? ? 'complete' : 'incomplete'))
            onsite_redirect_to todos_path(:format => 'm')
          end
        else
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
  form_tag todo_path(@todo, :format => 'm'), :name => 'mobileEdit', :method => :put do 
  todo = edit_form 
 form_for(todo, :html=> { :name=>'todo', :id => dom_id(@todo, 'form'), :class => 'inline-form edit_todo_form' }) do |t|
 if todo.errors.any? 
 todo.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 t.hidden_field( "id" ) 
 source_view_tag( @source_view ) 
 content_tag(:input, "", :type=>"hidden", :name=>"_tag_name", :value=>"#{@tag_name}") if @tag_name 
 dom_id(@todo, 'description') 
 t('common.description') 
 t.text_field( "description", "size" => 30, "maxlength" => 100) 
 dom_id(@todo, 'notes') 
 t('common.notes') 
 t.text_area( "notes", "cols" => 29, "rows" => 4) 
 dom_id(@todo, 'project_name') 
 t('common.project') 
 dom_id(@todo, 'project_name') 
 @todo.project.nil? ? '' : h(@todo.project.name) 
 dom_id(@todo, 'context_name') 
 t('common.context')  
 dom_id(@todo, 'context_name') 
 h @todo.context.name 
 dom_id(@todo, 'tag_list') 
 t('todos.tags') 
 text_field_tag 'tag_list', tag_list_text, :id => dom_id(@todo, 'tag_list'), :size => 30 
 dom_id(@todo, 'due_label') 
 Todo.human_attribute_name('due') 
 date_field_tag("todo[due]", dom_id(@todo, 'due'), format_date(@todo.due)) 
 dom_id(@todo, 'due_x') 
 t('todos.clear_due_date') 
 image_tag("blank.png", :alt => t('todos.clear_due_date'), :class => "delete_item") 
 dom_id(@todo, 'show_from') 
 t('todos.show_from') 
 date_field_tag("todo[show_from]", dom_id(@todo, 'show_from'), format_date(@todo.show_from)) 
 dom_id(@todo, 'show_from_x') 
 t('todos.clear_show_from_date') 
 image_tag("blank.png", :alt => t('todos.clear_show_from_date'), :class => "delete_item") 
 Todo.human_attribute_name('predecessors')
 @todo.predecessors.empty? ? "none" : "block"
 t('todos.add_another_dependency')
 text_field_tag "predecessor_input", nil, :size => 30 
 hidden_field_tag "predecessor_list", @todo.predecessors.map{|t| t.id.to_s}.join(', ') 
 dom_id(@todo, 'submit') 
image_tag("accept.png", :alt => "") 
 t('common.update') 
image_tag("cancel.png", :alt => "") 
 t('common.cancel') 
 end 
 
 end 
 link_to t('common.cancel'), @return_path 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

        end
      }
    end
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
  unless @saved 
 t('todos.error_toggle_complete') 
 else
  # create a unique object name to prevent concurrent toggles to overwrite each other functions
  object_name = unique_object_name_for("toggle_check")

 object_name 
 if @wants_redirect_after_complete && @todo.completed? 
object_name
 else
      animation = []
      unless source_view_is(:search)
        animation << "remove_todo"
        if @todo.completed?
          animation << "add_to_completed_container" unless source_view_is_one_of(:calendar, :deferred)
          animation << "add_new_recurring_todo"
          animation << "activate_pending_todos"
        else
          animation << "add_todo_to_container" unless source_view_is(:done)
          animation << "block_predecessors"
        end
        animation << "update_empty_container" if source_view_is_one_of(:tag, :todo, :deferred, :project, :context)
        animation << "regenerate_predecessor_family"
      else
        animation << "replace_todo"
      end 
 render_animation(animation, object_name) 
 @down_count 
 end 
 @todo.project_id.nil? ? root_path : project_path(@todo.project) 
 if update_needs_to_hide_container
      # remove context with deleted todo
    
 item_container_id(@original_item)
dom_id(@todo)
 show_empty_message_in_source_container 
 else
      # remove only the todo
    
 show_empty_message_in_source_container 
dom_id(@todo)
dom_id(@todo)
 end 
 unless current_user.prefs.hide_completed_actions? 
 item_container_id(@todo) 
object_name
object_name
 end 
 dom_id(@todo) 
object_name
 item_container_id(@todo) 
object_name
 if should_make_context_visible 
 item_container_id(@todo) 
 empty_container_msg_div_id 
object_name
 else 
 empty_container_msg_div_id(@todo) 
object_name
 end 
 if @completed_count == 0 
 end 
  # show new todo if the completed todo was recurring
      if @todo.from_recurring_todo?
        unless @new_recurring_todo.nil? || (@new_recurring_todo.deferred? && !source_view_is(:deferred)) 
 item_container_id(@new_recurring_todo) 
object_name
 @new_recurring_todo.context_id 
object_name
 else
          if @todo.recurring_todo.todos.active.count(:all) == 0 && @new_recurring_todo.nil? 
t('todos.recurrence_completed')
   end 
 end
      else 
 end 
 if @down_count==0 
 else 
 end 
 if @new_recurring_todo # hide js if @new_recurring_todo is not there
 dom_id(@new_recurring_todo)
 end 
 dom_id(@todo)
 # Activate pending todos that are successors of the completed
      if @pending_to_activate
        # do not render the js in case of an error or if no todos to activate
        @pending_to_activate.each do |t|
          html = escape_javascript(render(:partial => t, :locals => { :parent_container_type => parent_container_type }))
          # only project and tag view have a deferred/blocked container
          if source_view_is_one_of(:project,:tag) 
 dom_id(t) 
 dom_id(t) 
 item_container_id(t) 
 html  
 "$('#deferred_pending_container-empty-d').show();".html_safe if @remaining_deferred_or_pending_count==0 
     else 
 item_container_id(t) 
 html
     end 
 dom_id(t)
   end 
 end 
 # Block active todos that are successors of the uncompleted
      if @saved && @active_to_block
        # do not render the js in case of an error or if no todos to block
        @active_to_block.each do |t| 
 dom_id(t) 
 dom_id(t) 
       if source_view_is(:project) or source_view_is(:tag) # Insert it in deferred/pending block if existing 
 item_container_id(t) 
 js_render(t, { :parent_container_type => parent_container_type }) 
       end 
   end 
 end 

    if @predecessors
      parents = @predecessors.to_a
      until parents.empty?
        parent = parents.pop
        parents += parent.predecessors 
 dom_id(parent) 
 js_render(parent, { :parent_container_type => parent_container_type }) 
end
    end
    

      js = @new_recurring_todo ? js_render(@new_recurring_todo, { :parent_container_type => parent_container_type }) : ""
    
 js 

      locals = {
        :parent_container_type => parent_container_type,
        :suppress_project => source_view_is(:project),
        :suppress_context => source_view_is(:context)
      }
      js = source_view_is(:done) ? "" : js_render(@todo, locals)
    
 js 
object_name
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def toggle_star
    @todo = current_user.todos.find(params['id'])
    @todo.toggle_star!
    @saved = true # cannot determine error
    respond_to do |format|
      format.js
      format.xml { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  if @saved 
 @todo.id 
 else 
 t('todos.error_starring', :description => @todo.description) 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end
 }
      format.html { redirect_to request.referrer}
      format.m {
        if cookies[:mobile_url]
          old_path = cookies[:mobile_url]
          cookies[:mobile_url] = {:value => nil, :secure => SITE_CONFIG['secure_cookies']}
          notify(:notice, "Star toggled")
          onsite_redirect_to old_path
        else
          notify(:notice, "Star toggled")
          onsite_redirect_to todos_path(:format => 'm')
        end
      }
    end
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
  if @saved 
 @todo.id 
 else 
 t('todos.error_starring', :description => @todo.description) 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def change_context
    # change context if you drag a todo to another context
    @todo = current_user.todos.find(params[:id])
    @original_item_context_id = @todo.context_id
    @original_item = current_user.todos.build(@todo.attributes)  # create a (unsaved) copy of the original todo
    @context = current_user.contexts.find(params[:todo][:context_id])
    @todo.context = @context
    @saved = @todo.save

    @context_changed = true
    @status_message = t('todos.context_changed', :name => @context.name)
    determine_down_count
    determine_remaining_in_container_count(@original_item)

    respond_to do |format|
      format.js  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  object_name = unique_object_name_for("update_todo_#{@todo.id}") 
object_name
 render :partial => (@saved ? "update_successful" : "update_has_errors"), locals: {object_name: object_name} 
object_name
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end
 }
      format.xml { render :xml => @todo.to_xml( *todo_xml_params ) }
    end
  end

  def update
    @source_view = params['_source_view'] || 'todo'

    @todo = current_user.todos.find(params['id'])
    @original_item = current_user.todos.build(@todo.attributes)  # create a (unsaved) copy of the original todo

    cache_attributes_from_before_update # TODO: remove in favor of @original_item

    update_tags
    update_project
    update_context
    update_due_and_show_from_dates
    update_completed_state
    update_dependencies
    update_attributes_of_todo

    begin
      @saved = @todo.save!
    rescue ActiveRecord::RecordInvalid => exception
      record = exception.record
      if record.is_a?(Dependency)
        record.errors.each { |key,value| @todo.errors[key] << value }
      end
      @saved = false
    end


    provide_project_or_context_for_view

    # this is set after save and cleared after reload, so save it here
    @removed_predecessors = @todo.removed_predecessors

    @todo.reload # refresh context and project object too (not only their id's)

    update_dependency_state
    update_todo_state_if_project_changed

    determine_changes_by_this_update
    determine_remaining_in_container_count( (@context_changed || @project_changed) ? @original_item : @todo)
    determine_down_count
    determine_deferred_tag_count(sanitize(params['_tag_name'])) if source_view_is(:tag)

    @todo.touch_predecessors if @original_item_description != @todo.description

    respond_to do |format|
      format.js {
        @status_message = @todo.deferred? ? t('todos.action_saved_to_tickler') : t('todos.action_saved')
        @status_message = t('todos.added_new_project') + ' / ' + @status_message if @new_project_created
        @status_message = t('todos.added_new_context') + ' / ' + @status_message if @new_context_created
      }
      format.xml { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  object_name = unique_object_name_for("update_todo_#{@todo.id}") 
object_name
 render :partial => (@saved ? "update_successful" : "update_has_errors"), locals: {object_name: object_name} 
object_name
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end
 }
      format.m do
        if @saved
          do_mobile_todo_redirection
        else
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
  form_tag todo_path(@todo, :format => 'm'), :name => 'mobileEdit', :method => :put do 
  todo = edit_form 
 form_for(todo, :html=> { :name=>'todo', :id => dom_id(@todo, 'form'), :class => 'inline-form edit_todo_form' }) do |t|
 if todo.errors.any? 
 todo.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 t.hidden_field( "id" ) 
 source_view_tag( @source_view ) 
 content_tag(:input, "", :type=>"hidden", :name=>"_tag_name", :value=>"#{@tag_name}") if @tag_name 
 dom_id(@todo, 'description') 
 t('common.description') 
 t.text_field( "description", "size" => 30, "maxlength" => 100) 
 dom_id(@todo, 'notes') 
 t('common.notes') 
 t.text_area( "notes", "cols" => 29, "rows" => 4) 
 dom_id(@todo, 'project_name') 
 t('common.project') 
 dom_id(@todo, 'project_name') 
 @todo.project.nil? ? '' : h(@todo.project.name) 
 dom_id(@todo, 'context_name') 
 t('common.context')  
 dom_id(@todo, 'context_name') 
 h @todo.context.name 
 dom_id(@todo, 'tag_list') 
 t('todos.tags') 
 text_field_tag 'tag_list', tag_list_text, :id => dom_id(@todo, 'tag_list'), :size => 30 
 dom_id(@todo, 'due_label') 
 Todo.human_attribute_name('due') 
 date_field_tag("todo[due]", dom_id(@todo, 'due'), format_date(@todo.due)) 
 dom_id(@todo, 'due_x') 
 t('todos.clear_due_date') 
 image_tag("blank.png", :alt => t('todos.clear_due_date'), :class => "delete_item") 
 dom_id(@todo, 'show_from') 
 t('todos.show_from') 
 date_field_tag("todo[show_from]", dom_id(@todo, 'show_from'), format_date(@todo.show_from)) 
 dom_id(@todo, 'show_from_x') 
 t('todos.clear_show_from_date') 
 image_tag("blank.png", :alt => t('todos.clear_show_from_date'), :class => "delete_item") 
 Todo.human_attribute_name('predecessors')
 @todo.predecessors.empty? ? "none" : "block"
 t('todos.add_another_dependency')
 text_field_tag "predecessor_input", nil, :size => 30 
 hidden_field_tag "predecessor_list", @todo.predecessors.map{|t| t.id.to_s}.join(', ') 
 dom_id(@todo, 'submit') 
image_tag("accept.png", :alt => "") 
 t('common.update') 
image_tag("cancel.png", :alt => "") 
 t('common.cancel') 
 end 
 
 end 
 link_to t('common.cancel'), @return_path 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

        end
      end
    end
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
  object_name = unique_object_name_for("update_todo_#{@todo.id}") 
object_name
 render :partial => (@saved ? "update_successful" : "update_has_errors"), locals: {object_name: object_name} 
object_name
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def provide_project_or_context_for_view
    # see application_helper:source_view_key, used in shown partials
    if source_view_is :project
      @project = @todo.project
    elsif source_view_is :context
      @context = @todo.context
    end
  end

  def destroy
    @source_view = params['_source_view'] || 'todo'
    @todo = current_user.todos.find(params['id'])
    @original_item = current_user.todos.build(@todo.attributes)  # create a (unsaved) copy of the original todo
    @original_item_due = @todo.due
    @context_id = @todo.context_id
    @project_id = @todo.project_id
    @todo_was_destroyed = true
    @todo_was_destroyed_from_deferred_state = @todo.deferred?
    @todo_was_destroyed_from_pending_state = @todo.pending?
    @todo_was_destroyed_from_deferred_or_pending_state = @todo_was_destroyed_from_deferred_state || @todo_was_destroyed_from_pending_state

    @uncompleted_predecessors = []
    @todo.uncompleted_predecessors.each do |predecessor|
      @uncompleted_predecessors << predecessor
    end

    activated_successor_count = 0
    @pending_to_activate = []
    @todo.pending_successors.each do |successor|
      if successor.uncompleted_predecessors.size == 1
        @pending_to_activate << successor
        activated_successor_count += 1
      end
    end

    @saved = @todo.destroy

    # check if this todo has a related recurring_todo. If so, create next todo
    @new_recurring_todo = check_for_next_todo(@todo) if @saved

    respond_to do |format|

      format.html do
        if @saved
          message = t('todos.action_deleted_success')
          if activated_successor_count > 0
            message += " activated #{pluralize(activated_successor_count, 'pending action')}"
          end
          notify :notice, message, 2.0
          redirect_to :action => 'index'
        else
          notify :error, t('todos.action_deleted_error'), 2.0
          redirect_to :action => 'index'
        end
      end

      format.js do
        if @saved
          determine_down_count
          if source_view_is_one_of(:todo, :deferred, :project, :context, :tag)
            determine_remaining_in_container_count(@todo)
          elsif source_view_is :calendar
            @original_item_due_id = get_due_id_for_calendar(@original_item_due)
            @old_due_empty = is_old_due_empty(@original_item_due_id)
          end
        end
        render
      end

      format.xml { render :text => '200 OK. Action deleted.', :status => 200 }

    end
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
  unless @saved 
 t('todos.error_deleting_item', :description => @todo.description) 
 else 
  escape_javascript(t('todos.deleted_success')) 
@down_count
 end 
 if @old_due_empty 
@original_item_due_id
 end 
 if todo_container_is_empty 
empty_container_msg_div_id
 if @down_count == 0 
 end 
 end 
 if source_view_is(:deferred) && @down_count==0 
 end 
 if update_needs_to_hide_container
       # remove context with deleted todo
  
item_container_id(@todo)
dom_id(@todo)
 show_empty_message_in_source_container 
 else
       # remove only the todo
  
 show_empty_message_in_source_container 
dom_id(@todo)
dom_id(@todo)
 if source_view_is :calendar
              # in calendar view it is possible to have a todo twice on the page
         
dom_id(@todo)
 end 
 end 
 if @todo.from_recurring_todo? 
  unless @new_recurring_todo.nil? || @new_recurring_todo.deferred? 
item_container_id(@new_recurring_todo)
item_container_id(@new_recurring_todo)
 dom_id(@new_recurring_todo, 'line')
t('todos.recurring_action_deleted')
 else 
 if @todo.recurring_todo.todos.active.count(:all) == 0 && @new_recurring_todo.nil? 
t('todos.completed_recurrence_completed')
 end 
 end 
 end 
 # Activate pending todos that are successors of the deleted
    if @saved && @pending_to_activate
      # do not render the js in case of an error or if no todos to activate
      @pending_to_activate.each do |t|
        html = js_render(t, { :parent_container_type => parent_container_type })
        # only project and tag view have a deferred/blocked container
        if source_view_is_one_of(:project,:tag) 
 dom_id(t) 
 dom_id(t) 
 item_container_id(t) 
 html 
 "$('#deferred_pending_container-empty-d').show();".html_safe if @remaining_deferred_or_pending_count==0 
     else 
 item_container_id(t) 
 html
     end 
 dom_id(t, 'line')
   end 
 end 

  if @todo_was_destroyed_from_pending_state
    @uncompleted_predecessors.each do |p| 
item_container_id(p)
dom_id(p)
js_render(p, { :parent_container_type => parent_container_type })
  end
  end

 @saved && @new_recurring_todo ? js_render(@new_recurring_todo, { :parent_container_type => parent_container_type }) : "" 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def done
    @source_view = 'done'
    @page_title = t('todos.completed_tasks_title')

    @done_today, @done_rest_of_week, @done_rest_of_month = DoneTodos.done_todos_for_container(current_user.todos)
    @count = @done_today.size + @done_rest_of_week.size + @done_rest_of_month.size

    respond_to do |format|
      format.html
      format.xml do
        completed_todos = current_user.todos.completed
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
  show_completed_todos_for("today", @done_today) 
 show_completed_todos_for("rest_of_week", @done_rest_of_week) 
 show_completed_todos_for("rest_of_month", @done_rest_of_month) 
 raw t('todos.see_all_completed',
      :link => link_to(t("todos.all_completed_here"), determine_all_done_path))
    
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

      end
    end
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
  show_completed_todos_for("today", @done_today) 
 show_completed_todos_for("rest_of_week", @done_rest_of_week) 
 show_completed_todos_for("rest_of_month", @done_rest_of_month) 
 raw t('todos.see_all_completed',
      :link => link_to(t("todos.all_completed_here"), determine_all_done_path))
    
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def all_done
    @source_view = 'done'
    @page_title = t('todos.completed_tasks_title')

    @done = current_user.todos.completed.includes(Todo::DEFAULT_INCLUDES).reorder('completed_at DESC').paginate :page => params[:page], :per_page => 20
    @count = @done.size
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
 
  paginate_options = {
    :class => 'link_in_container_header',
    :previous_label => '&laquo; '+ t('common.previous'),
    :next_label     => t('common.next')+' &raquo;',
    :inner_window   => 2
  }

 will_paginate @done, paginate_options 
 t('todos.all_completed') 
 @done.empty? ? 'display:block' : 'display:none'
 t('todos.no_completed_actions') 
 if !@done.empty? 
 
require 'htmlentities'
htmlentities = HTMLEntities.new

if (todo.starred?)
  result_string = "  * "
else
  result_string = "  - "
end

if (todo.completed?) && todo.completed_at
  result_string << "["+ htmlentities.decode(t('todos.completed')) +": " + format_date(todo.completed_at) + "] "
end

if todo.due
  result_string << "[" + htmlentities.decode(t('todos.due')) + ": " + format_date(todo.due) + "] "
  result_string << todo.description + " "
else
  result_string << todo.description + " "
end

unless todo.project.nil?
  result_string << "(" + todo.project.name + ")"
end

 result_string 
 
 end 
 will_paginate @done, paginate_options 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def list_deferred
    @source_view = 'deferred'
    @page_title = t('todos.deferred_tasks_title')

    @contexts_to_show = @contexts = current_user.contexts
    @projects_to_show = @projects = current_user.projects

    includes = params[:format]=='xml' ? [:context, :project] : Todo::DEFAULT_INCLUDES

    @not_done_todos = current_user.todos.deferred.includes(includes).reorder('show_from') + current_user.todos.pending.includes(includes)
    @todos_without_project = @not_done_todos.select{|t|t.project.nil?}
    @down_count = @count = @not_done_todos.size

    respond_to do |format|
      format.html do
        init_not_done_counts
        init_project_hidden_todo_counts
        init_data_for_sidebar unless mobile?
      end
      format.m
      format.xml { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  empty_message_holder("deferred_pending", @not_done_todos.empty?) 
 show_grouped_todos 
 if @group_view_by == 'project' 
 show_todos_without_project(@todos_without_project) 
 end 
 
@initial_context_name = @context.name if @context
@initial_context_name ||= @project.default_context.name unless @project.nil? || @project.default_context.nil?
@initial_context_name ||= @contexts.active.first.name unless @contexts.active.first.nil?
@initial_context_name ||= @contexts.first.name unless @contexts.first.nil?
@initial_project_name = @project.name unless @project.nil?
@initial_tags ||= @default_tags
@initial_tags ||= @project.default_tags unless @project.nil?

 t('shared.hide_action_form_title') 
 t('shared.hide_form') 
 t('shared.toggle_multi_title') 
 t('shared.toggle_multi') 
  todo = new_todo_form 
 form_for(todo, :html=> { :id=>'todo-form-new-action', :name=>'todo', :class => 'inline-form new_todo_form' }) do |t|
 h(@initial_project_name)
 h(@initial_context_name)
 get_list_of_error_messages_for(todo) 
 Todo.human_attribute_name('description') 
 image_tag("blank.png", :title =>t('todos.star_action'), :class => "todo_star", :style=> "float: right")
 t.text_field("description", "size" => 30, "maxlength" => 100, "autocomplete" => "off", :autofocus => 1) 
 Todo.human_attribute_name('notes') 
 t.text_area("notes", "cols" => 29, "rows" => 6) 
 Todo.human_attribute_name('project') 
 h(@initial_project_name) 
 Todo.human_attribute_name('context') 
 h(@initial_context_name) 
 Todo.human_attribute_name('tags') + ' (' + t('shared.separate_tags_with_commas') + ')' 
 hidden_field_tag "initial_tag_list", @initial_tags
 text_field_tag "tag_list", @initial_tags, :size => 30 
 content_tag("div", "", :id => "tag_list_auto_complete", :class => "auto_complete") 
 Todo.human_attribute_name('due') 
 t.text_field("due", "size" => 12, "class" => "Date", "autocomplete" => "off") 
 Todo.human_attribute_name('show_from') 
 t.text_field("show_from", "size" => 12, "class" => "Date", "autocomplete" => "off") 
 Todo.human_attribute_name('predecessors')
 t('todos.add_another_dependency')
 text_field_tag "predecessor_input", nil, :size => 30 
 hidden_field_tag "predecessor_list", ""
 source_view_tag( @source_view ) 
 hidden_field_tag :_tag_name, @tag_name.underscore.gsub(/\s+/,'_') if source_view_is :tag 
  image_tag("accept.png", :alt => "") + t('shared.add_action') 
 end # form_for 
 
  todo = new_multi_todo_form 
 form_for(todo, :html=> { :id=>'todo-form-multi-new-action', :name=>'todo', :class => 'inline-form' }) do |t| 
h @initial_project_name
h @initial_context_name
 if todo.errors.any? 
 todo.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 t('shared.multiple_next_actions') 
 text_area_tag( "todo[multiple_todos]", "", :cols => 29, :rows => 6 ) 
 t('shared.project_for_all_actions') 
h @initial_project_name 
 t('shared.context_for_all_actions') 
h @initial_context_name 
 t('shared.tags_for_all_actions') 
 hidden_field_tag "initial_tag_list", @initial_tags
 text_field_tag "multi_tag_list", @initial_tags, :name=>:tag_list, :size => 30 
 content_tag("div", "", :id => "tag_list_auto_complete", :class => "auto_complete") 
 check_box_tag('todos_sequential', 'true', false) 
 t('shared.make_actions_dependent') 
  image_tag("accept.png", :alt => "") 
 t('shared.add_actions') 
 end 
 
 
  sidebar_html_for_titled_list(@sidebar.active_projects, t('sidebar.list_name_active_projects'))
 sidebar_html_for_titled_list(@sidebar.active_contexts, t('sidebar.list_name_active_contexts'))
 sidebar_html_for_titled_list(@sidebar.hidden_projects, t('sidebar.list_name_hidden_projects')) if prefs.show_hidden_projects_in_sidebar 
 sidebar_html_for_titled_list(@sidebar.completed_projects, t('sidebar.list_name_completed_projects')) if prefs.show_completed_projects_in_sidebar 
 sidebar_html_for_titled_list(@sidebar.hidden_contexts, t('sidebar.list_name_hidden_contexts')) if prefs.show_hidden_contexts_in_sidebar 
 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end
 }
    end
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
  empty_message_holder("deferred_pending", @not_done_todos.empty?) 
 show_grouped_todos 
 if @group_view_by == 'project' 
 show_todos_without_project(@todos_without_project) 
 end 
 
@initial_context_name = @context.name if @context
@initial_context_name ||= @project.default_context.name unless @project.nil? || @project.default_context.nil?
@initial_context_name ||= @contexts.active.first.name unless @contexts.active.first.nil?
@initial_context_name ||= @contexts.first.name unless @contexts.first.nil?
@initial_project_name = @project.name unless @project.nil?
@initial_tags ||= @default_tags
@initial_tags ||= @project.default_tags unless @project.nil?

 t('shared.hide_action_form_title') 
 t('shared.hide_form') 
 t('shared.toggle_multi_title') 
 t('shared.toggle_multi') 
  todo = new_todo_form 
 form_for(todo, :html=> { :id=>'todo-form-new-action', :name=>'todo', :class => 'inline-form new_todo_form' }) do |t|
 h(@initial_project_name)
 h(@initial_context_name)
 get_list_of_error_messages_for(todo) 
 Todo.human_attribute_name('description') 
 image_tag("blank.png", :title =>t('todos.star_action'), :class => "todo_star", :style=> "float: right")
 t.text_field("description", "size" => 30, "maxlength" => 100, "autocomplete" => "off", :autofocus => 1) 
 Todo.human_attribute_name('notes') 
 t.text_area("notes", "cols" => 29, "rows" => 6) 
 Todo.human_attribute_name('project') 
 h(@initial_project_name) 
 Todo.human_attribute_name('context') 
 h(@initial_context_name) 
 Todo.human_attribute_name('tags') + ' (' + t('shared.separate_tags_with_commas') + ')' 
 hidden_field_tag "initial_tag_list", @initial_tags
 text_field_tag "tag_list", @initial_tags, :size => 30 
 content_tag("div", "", :id => "tag_list_auto_complete", :class => "auto_complete") 
 Todo.human_attribute_name('due') 
 t.text_field("due", "size" => 12, "class" => "Date", "autocomplete" => "off") 
 Todo.human_attribute_name('show_from') 
 t.text_field("show_from", "size" => 12, "class" => "Date", "autocomplete" => "off") 
 Todo.human_attribute_name('predecessors')
 t('todos.add_another_dependency')
 text_field_tag "predecessor_input", nil, :size => 30 
 hidden_field_tag "predecessor_list", ""
 source_view_tag( @source_view ) 
 hidden_field_tag :_tag_name, @tag_name.underscore.gsub(/\s+/,'_') if source_view_is :tag 
  image_tag("accept.png", :alt => "") + t('shared.add_action') 
 end # form_for 
 
  todo = new_multi_todo_form 
 form_for(todo, :html=> { :id=>'todo-form-multi-new-action', :name=>'todo', :class => 'inline-form' }) do |t| 
h @initial_project_name
h @initial_context_name
 if todo.errors.any? 
 todo.errors.full_messages.each do |msg| 
 msg 
 end 
 end 
 t('shared.multiple_next_actions') 
 text_area_tag( "todo[multiple_todos]", "", :cols => 29, :rows => 6 ) 
 t('shared.project_for_all_actions') 
h @initial_project_name 
 t('shared.context_for_all_actions') 
h @initial_context_name 
 t('shared.tags_for_all_actions') 
 hidden_field_tag "initial_tag_list", @initial_tags
 text_field_tag "multi_tag_list", @initial_tags, :name=>:tag_list, :size => 30 
 content_tag("div", "", :id => "tag_list_auto_complete", :class => "auto_complete") 
 check_box_tag('todos_sequential', 'true', false) 
 t('shared.make_actions_dependent') 
  image_tag("accept.png", :alt => "") 
 t('shared.add_actions') 
 end 
 
 
  sidebar_html_for_titled_list(@sidebar.active_projects, t('sidebar.list_name_active_projects'))
 sidebar_html_for_titled_list(@sidebar.active_contexts, t('sidebar.list_name_active_contexts'))
 sidebar_html_for_titled_list(@sidebar.hidden_projects, t('sidebar.list_name_hidden_projects')) if prefs.show_hidden_projects_in_sidebar 
 sidebar_html_for_titled_list(@sidebar.completed_projects, t('sidebar.list_name_completed_projects')) if prefs.show_completed_projects_in_sidebar 
 sidebar_html_for_titled_list(@sidebar.hidden_contexts, t('sidebar.list_name_hidden_contexts')) if prefs.show_hidden_contexts_in_sidebar 
 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  # Check for any due tickler items, activate them
  # Called by periodically_call_remote
  def check_deferred
    @due_tickles = current_user.deferred_todos.find_and_activate_ready
    respond_to do |format|
      format.html { redirect_to home_path }
      format.js
    end
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
  unless @due_tickles.empty? 
t('todos.tickler_items_due', :count => @due_tickles.length)
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def filter_to_context
    context = current_user.contexts.find(params['context']['id'])
    redirect_to context_todos_path(context, :format => 'm')
  end

  def filter_to_project
    project = current_user.projects.find(params['project']['id'])
    redirect_to project_todos_path(project, :format => 'm')
  end

  # /todos/tag/[tag_name] shows all the actions tagged with tag_name
  def tag
    get_params_for_tag_view
    @page_title = t('todos.tagged_page_title', :tag_name => @tag_title)
    @source_view = params['_source_view'] || 'tag'

    init_data_for_sidebar unless mobile?

    todos_with_tag_ids = find_todos_with_tag_expr(@tag_expr)

    @not_done_todos = todos_with_tag_ids.
      active.not_hidden.
      reorder('todos.due IS NULL, todos.due ASC, todos.created_at ASC').
      includes(Todo::DEFAULT_INCLUDES)
    @hidden_todos = todos_with_tag_ids.
      hidden.
      reorder('todos.completed_at DESC, todos.created_at DESC').
      includes(Todo::DEFAULT_INCLUDES)
    @deferred_todos = todos_with_tag_ids.
      deferred.
      reorder('todos.show_from ASC, todos.created_at DESC').
      includes(Todo::DEFAULT_INCLUDES)
    @pending_todos = todos_with_tag_ids.
      blocked.
      reorder('todos.show_from ASC, todos.created_at DESC').
      includes(Todo::DEFAULT_INCLUDES)
    @todos_without_project = @not_done_todos.select{|t| t.project.nil?}

    # If you've set no_completed to zero, the completed items box isn't shown on
    # the tag page
    @done = todos_with_tag_ids.completed.
      limit(current_user.prefs.show_number_completed).
      reorder('todos.completed_at DESC').
      includes(Todo::DEFAULT_INCLUDES)

    @projects = current_user.projects
    @contexts = current_user.contexts
    @contexts_to_show = @contexts.active
    @projects_to_show = @projects.active

    # Set defaults for new_action
    @initial_tags = @tag_name

    # Set count badge to number of items with this tag
    @not_done_todos.empty? ? @count = 0 : @count = @not_done_todos.size
    @down_count = @count

    respond_to do |format|
      format.html
      format.m {
        cookies[:mobile_url]= {:value => request.fullpath, :secure => SITE_CONFIG['secure_cookies']}
      }
      format.text {
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 TRACKS_VERSION 
 ENV['TZ'] || 'GMT' 
 Time.now.strftime("%Y%m%dT%H%M%SZ") 
 ENV['TZ'] 
 for @todo in @todos 
 @todo.created_at.strftime("%Y%m%dT%H%M%SZ") 
 @todo.created_at.strftime("%Y%m%d") 
 @todo.description 
 todo_url(@todo) 
 if @todo.notes? 
 format_ical_notes(@todo.notes) 
 end 
 if @todo.due 
 @todo.due.strftime("%Y%m%d") 
 end 
 if @todo.project_id 
 project_url(@todo.project) 
 else 
 context_url(@todo.context) 
 end 
 end 

end

      }
    end
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
  if @not_done_todos.empty? 
 t('todos.no_actions_found_title') 
 t('todos.no_actions_with', :tag_name => @tag_title) 
 end 
 render :partial => @contexts_to_show 
 t('todos.deferred_actions_with', :tag_name=> @tag_title) 
 unless (@deferred.nil? or @deferred.size == 0)  
 render :partial => @deferred, :locals => { :parent_container_type => "tag" } 
 else 
 t('todos.no_deferred_actions_with', :tag_name => @tag_title) 
 end 
 t('todos.completed_actions_with', :tag_name => @tag_title) 
 unless (@done.nil? or @done.size == 0) 
 render :partial => @done, :locals => { :parent_container_type => "tag" } 
 else 
 t('todos.no_completed_actions_with', :tag_name => @tag_title) 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def done_tag
    done_by_tag_setup

    completed_todos = current_user.todos.completed.with_tag(@tag.id)

    @done_today = get_done_today(completed_todos)
    @done_rest_of_week = get_done_rest_of_week(completed_todos)
    @done_rest_of_month = get_done_rest_of_month(completed_todos)
    @count = @done_today.size + @done_rest_of_week.size + @done_rest_of_month.size

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
  show_completed_todos_for("today", @done_today) 
 show_completed_todos_for("rest_of_week", @done_rest_of_week) 
 show_completed_todos_for("rest_of_month", @done_rest_of_month) 
 raw t('todos.see_all_completed',
      :link => link_to(t("todos.all_completed_here"), determine_all_done_path))
    
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def all_done_tag
    done_by_tag_setup
    @done = current_user.todos.completed.with_tag(@tag.id).reorder('completed_at DESC').includes(Todo::DEFAULT_INCLUDES).paginate :page => params[:page], :per_page => 20
    @count = @done.size
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
 
  paginate_options = {
    :class => 'link_in_container_header',
    :previous_label => '&laquo; '+ t('common.previous'),
    :next_label     => t('common.next')+' &raquo;',
    :inner_window   => 2
  }

 will_paginate @done, paginate_options 
 t('todos.all_completed') 
 @done.empty? ? 'display:block' : 'display:none'
 t('todos.no_completed_actions') 
 if !@done.empty? 
 
require 'htmlentities'
htmlentities = HTMLEntities.new

if (todo.starred?)
  result_string = "  * "
else
  result_string = "  - "
end

if (todo.completed?) && todo.completed_at
  result_string << "["+ htmlentities.decode(t('todos.completed')) +": " + format_date(todo.completed_at) + "] "
end

if todo.due
  result_string << "[" + htmlentities.decode(t('todos.due')) + ": " + format_date(todo.due) + "] "
  result_string << todo.description + " "
else
  result_string << todo.description + " "
end

unless todo.project.nil?
  result_string << "(" + todo.project.name + ")"
end

 result_string 
 
 end 
 will_paginate @done, paginate_options 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def done_by_tag_setup
    @source_view = params['_source_view'] || 'done'
    @tag_name = sanitize(params[:name]) # sanitize to prevent XSS vunerability!
    @page_title = t('todos.all_completed_tagged_page_title', :tag_name => @tag_name)
    @tag = Tag.where(:name => @tag_name).first_or_create
  end


  def tags
    # TODO: limit to current_user
    tags_beginning = Tag.where('name like ?', params[:term]+'%')
    tags_all = Tag.where('name like ?', '%'+params[:term]+'%')
    tags_all= tags_all - tags_beginning

    respond_to do |format|
      format.autocomplete { render :text => for_autocomplete(tags_beginning+tags_all, params[:term]) }
    end
  end

  def defer
    @source_view = params['_source_view'] || 'todo'
    numdays = params['days'].to_i

    @todo = current_user.todos.find(params[:id])
    @original_item = current_user.todos.build(@todo.attributes)  # create a (unsaved) copy of the original todo

    @original_item_context_id = @todo.context_id
    @todo_deferred_state_changed = true
    @new_context_created = false
    @due_date_changed = false
    @tag_was_removed = false
    @todo_hidden_state_changed = false
    @todo_was_deferred_from_active_state = @todo.show_from.nil?

    @todo.show_from = (@todo.show_from || @todo.user.date) + numdays.days
    @saved = @todo.save
    @status_message = t('todos.action_saved_to_tickler')

    determine_down_count
    determine_remaining_in_container_count(@todo)
    source_view do |page|
      page.project {
        @remaining_undone_in_project = current_user.projects.find(@todo.project_id).todos.not_completed.count
        @original_item_project_id = @todo.project_id
      }
      page.tag {
        determine_deferred_tag_count(params['_tag_name'])
      }
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js {ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  object_name = unique_object_name_for("update_todo_#{@todo.id}") 
object_name
 render :partial => (@saved ? "update_successful" : "update_has_errors"), locals: {object_name: object_name} 
object_name
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end
}
      format.m {
        notify(:notice, t("todos.action_deferred", :description => @todo.description))
        do_mobile_todo_redirection
      }
    end
  end

  def list_hidden
    @hidden = current_user.todos.hidden
    respond_to do |format|
      format.xml {
        render :xml => @hidden.to_xml( *todo_xml_params )
      }
    end
  end

  def get_not_completed_for_predecessor(relation, todo_id=nil)
    items = relation.todos.not_completed.
      where('(LOWER(todos.description) LIKE ?)', "%#{params[:term].downcase}%")
    items = items.where("AND NOT(todos.id=?)", todo_id) unless todo_id.nil?

    items.
      includes(:context, :project).
      reorder('description ASC').
      limit(10)
  end

  def auto_complete_for_predecessor
    unless params['id'].nil?
      get_todo_from_params
      # Begin matching todos in current project, excluding @todo itself
      @items = get_not_completed_for_predecessor(@todo.project, @todo.id) unless @todo.project.nil?
      # Then look in the current context, excluding @todo itself
      @items = get_not_completed_for_predecessor(@todo.context, @todo.id) unless !@items.empty? || @todo.context.nil?
      # Match todos in other projects, excluding @todo itself
      @items = get_not_completed_for_predecessor(current_user, @todo.id) unless !@items.empty?
    else
      # New todo - TODO: Filter on current project in project view
      @items = get_not_completed_for_predecessor(current_user)
    end
    render :inline => format_dependencies_as_json_for_auto_complete(@items)
  end

  def convert_to_project
    todo = current_user.todos.find(params[:id])
    @project = ProjectFromTodo.new(todo).create

    if @project.valid?
      redirect_to project_url(@project)
    else
      flash[:error] = "Could not create project from todo: #{@project.errors.full_messages[0]}"
      onsite_redirect_to request.env["HTTP_REFERER"] || root_url
    end
  end

  def show_notes
    @todo = current_user.todos.find(params['id'])
    @return_path=cookies[:mobile_url] ? cookies[:mobile_url] : mobile_path
    respond_to do |format|
      format.html {
        redirect_to home_path, "Viewing note of todo is not implemented"
      }
      format.m   {
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
  raw "#{t('todos.next_action_description')} (#{link_to(t('common.go_back'), @return_path)}" 
 link_to @todo.description, todo_path(@todo, :format => 'm') 
 t('todos.notes') 
 Tracks::Utils.render_text(@todo.notes)  
 link_to t('common.back'), @return_path 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

      }
    end
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
  raw "#{t('todos.next_action_description')} (#{link_to(t('common.go_back'), @return_path)}" 
 link_to @todo.description, todo_path(@todo, :format => 'm') 
 t('todos.notes') 
 Tracks::Utils.render_text(@todo.notes)  
 link_to t('common.back'), @return_path 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def attachment
    id = params[:id]
    filename = params[:filename]
    attachment = current_user.attachments.find(id)

    if attachment
      send_file(attachment.file.path,
        disposition: 'attachment',
        type: 'message/rfc822')
    else
      head :not_found
    end
  end

  private

  def set_group_view_by
    @group_view_by = params['_group_view_by'] || cookies['group_view_by'] || 'context'
  end

  def do_mobile_todo_redirection
    if cookies[:mobile_url]
      old_path = cookies[:mobile_url]
      cookies[:mobile_url] = {:value => nil, :secure => SITE_CONFIG['secure_cookies']}
      onsite_redirect_to old_path
    else
      onsite_redirect_to todos_path(:format => 'm')
    end
  end

  def get_todo_from_params
    # TODO: this was a :append_before but was removed to tune performance per
    # method. Reconsider re-enabling it
    @todo = current_user.todos.find(params['id'])
  end

  def find_and_activate_ready
    current_user.deferred_todos.find_and_activate_ready
  end

  def tag_title(tag_expr)
    and_list = tag_expr.inject([]) { |s,tag_list| s << tag_list.join(',') }
    return and_list.join(' AND ')
  end

  def get_params_for_tag_view
    filter_format_for_tag_view

    # use sanitize to prevent XSS attacks
    @tag_expr = []
    @tag_expr << sanitize(params[:name]).split(',')
    @tag_expr << sanitize(params[:and]).split(',') if params[:and]

    i = 1
    while params['and'+i.to_s]
      @tag_expr << sanitize(params['and'+i.to_s]).split(',')
      i=i+1
    end

    @single_tag = @tag_expr.size == 1 && @tag_expr[0].size == 1
    @tag_name = @tag_expr[0][0]
    @tag_title = @single_tag ? @tag_name : tag_title(@tag_expr)
  end

  def filter_format_for_tag_view
    # routes for tag view do not set :format
    if params[:name] =~ /.*\.m$/
      set_format_for_tag_view(:m)
    elsif params[:name] =~ /.*\.txt$/
      set_format_for_tag_view(:txt)
      # set content-type to text/plain or it remains text/html
      response.headers["Content-Type"] = 'text/plain'
    elsif params[:format].nil?
      # if no format is given, default to html
      # note that if url has ?format=m, we should not overwrite it here
      request.format = :html
      params[:format] = :html
    end
  end

  def set_format_for_tag_view(format)
    # tag name ends with .m, set format to :m en remove .m from name
    request.format = format
    params[:format] = format
    params[:name] = params[:name].chomp(".#{format.to_s}")
end

  def get_ids_from_tag_expr(tag_expr)
    ids = []
    tag_expr.each do |tag_list|
      id_list = []
      tag_list.each do |tag|
        tag = Tag.where(:name => tag).first
        id_list << tag.id if tag
      end
      ids << id_list
    end
    return ids
  end

  def find_todos_with_tag_expr(tag_expr)
    # optimize for the common case: selecting only one tag
    if @single_tag
      tag = Tag.where(:name => @tag_name).first
      tag_id = tag.nil? ? -1 : tag.id
      return current_user.todos.with_tag(tag_id)
    end

    tag_ids = get_ids_from_tag_expr(tag_expr)
    todos = current_user.todos
    tag_ids.each do |ids|
      todos = todos.with_tags(ids) unless ids.nil? || ids.empty?
    end
    return todos
  end

  def determine_down_count
    source_view do |from|
      from.todo do
        @down_count = current_user.todos.active.not_hidden.count
      end
      from.context do
        context_id = @original_item_context_id || @todo.context_id
        todos = current_user.contexts.find(context_id).todos.not_completed

        if @todo.context.hidden?
          # include hidden todos
          @down_count = todos.count
        else
          # exclude hidden_todos
          @down_count = todos.not_hidden.count
        end
      end
      from.project do
        unless @todo.project_id == nil
          @down_count = current_user.projects.find(@todo.project_id).todos.active_or_hidden.count
        end
      end
      from.deferred do
        @down_count = current_user.todos.deferred_or_blocked.count
      end
      from.tag do
        @tag_name = params['_tag_name']
        @tag = Tag.where(:name => @tag_name).first
        if @tag.nil?
          @tag = Tag.new(:name => @tag_name)
        end
        @down_count = current_user.todos.with_tag(@tag.id).active.not_hidden.count
      end
    end
  end

  def find_todos_in_project_container(todo)
    if todo.project.nil?
      # container with todos without project
      todos_in_container = current_user.todos.where(:project_id => nil)
    else
      todos_in_container = current_user.projects.find(todo.project_id).todos
    end
  end

  def find_todos_in_container_and_target_container(todo, target_todo)
    if @group_view_by == 'context'
      todos_in_container = current_user.contexts.find(todo.context_id).todos
      todos_in_target_container = current_user.contexts.find(@todo.context_id).todos
    else
      todos_in_container = find_todos_in_project_container(todo)
      todos_in_target_container = find_todos_in_project_container(@todo)
    end
    return todos_in_container, todos_in_target_container
  end

  def determine_remaining_in_container_count(todo = @todo)
    source_view do |from|
      from.deferred {
        todos_in_container, todos_in_target_container = find_todos_in_container_and_target_container(todo, @todo)
        @remaining_in_context = todos_in_container.deferred_or_blocked.count
        @target_context_count = todos_in_target_container.deferred_or_blocked.count
      }
      from.todo {
        todos_in_container, todos_in_target_container = find_todos_in_container_and_target_container(todo, @todo)
        @remaining_in_context = todos_in_container.active.not_hidden.count
        @target_context_count = todos_in_target_container.active.not_hidden.count
      }
      from.tag {
        tag = Tag.where(:name => params['_tag_name']).first
        tag = Tag.new(:name => params['tag']) if tag.nil?

        todos_in_container, todos_in_target_container = find_todos_in_container_and_target_container(todo, @todo)

        @remaining_in_context = todos_in_container.active.not_hidden.with_tag(tag.id).count
        @target_context_count = todos_in_target_container.active.not_hidden.with_tag(tag.id).count
        @remaining_hidden_count = current_user.todos.hidden.with_tag(tag.id).count
        @remaining_deferred_or_pending_count = current_user.todos.with_tag(tag.id).deferred_or_blocked.count
      }
      from.project {
        project_id = @project_changed ? @original_item_project_id : @todo.project_id
        @remaining_deferred_or_pending_count = current_user.projects.find(project_id).todos.deferred_or_blocked.count

        if @todo_was_completed_from_deferred_or_blocked_state
          @remaining_in_context = @remaining_deferred_or_pending_count
        else
          @remaining_in_context = current_user.projects.find(project_id).todos.active_or_hidden.count
        end

        @target_context_count = current_user.projects.find(project_id).todos.active.count
      }
      from.calendar {
        @target_context_count = @new_due_id.blank? ? 0 : count_old_due_empty(@new_due_id)
      }
      from.context {
        context = current_user.contexts.find(todo.context_id)
        @remaining_deferred_or_pending_count = context.todos.deferred_or_blocked.count

        remaining_actions_in_context = context.todos(true).active
        remaining_actions_in_context = remaining_actions_in_context.not_hidden if !context.hidden?
        @remaining_in_context = remaining_actions_in_context.count

        if @todo_was_deferred_or_blocked
          actions_in_target = current_user.contexts.find(@todo.context_id).todos(true).active
          actions_in_target = actions_in_target.not_hidden if !context.hidden?
        else
          actions_in_target = @todo.context.todos.deferred_or_blocked
        end
        @target_context_count = actions_in_target.count
      }
      from.done {
        @remaining_in_context = DoneTodos.remaining_in_container(current_user.todos, @original_completed_period)
      }
      from.all_done {
        @remaining_in_context = current_user.todos.completed.count
      }
    end
  end

  def find_completed(relation, id, include_hidden)
    todos = relation.find(id).todos.completed
    todos = todos.not_hidden if !include_hidden
    return todos
  end

  def determine_completed_count
    todos=nil

    source_view do |from|
      from.todo    { todos = current_user.todos.not_hidden.completed }
      from.context { todos = find_completed(current_user.contexts, @todo.context_id, @todo.context.hidden?) }
      from.project { todos = find_completed(current_user.projects, @todo.project_id, @todo.project.hidden?) unless @todo.project_id.nil? }
      from.tag     { todos = current_user.todos.with_tag(@tag.id).completed }
    end

    @completed_count = todos.nil? ? 0 : todos.count
  end

  def determine_deferred_tag_count(tag_name)
    tag = Tag.where(:name => tag_name).first
    # tag.nil? should normally not happen, but is a workaround for #929
    @remaining_deferred_or_pending_count = tag.nil? ? 0 : current_user.todos.deferred.with_tag(tag.id).count
  end

  def check_for_next_todo(todo)
    # check if this todo has a related recurring_todo. If so, create next todo
    new_recurring_todo = nil
    recurring_todo = nil
    if todo.from_recurring_todo?
      recurring_todo = todo.recurring_todo

      # check if there are active todos belonging to this recurring todo. only
      # add new one if all active todos are completed
      if recurring_todo.todos.active.count == 0

        # check for next todo either from the due date or the show_from date
        date_to_check = todo.due || todo.show_from

        # if both due and show_from are nil, check for a next todo from now
        date_to_check ||= Time.zone.now

        if recurring_todo.active? && recurring_todo.continues_recurring?(date_to_check)

          # shift the reference date to yesterday if date_to_check is furher in
          # the past. This is to make sure we do not get older todos for overdue
          # todos. I.e. checking a daily todo that is overdue with 5 days will
          # create a new todo which is overdue by 4 days if we don't shift the
          # date. Discard the time part in the compare. We pick yesterday so
          # that new todos due for today will be created instead of new todos
          # for tomorrow.
          date = date_to_check.at_midnight >= Time.zone.now.at_midnight ? date_to_check : Time.zone.now-1.day

          new_recurring_todo = TodoFromRecurringTodo.new(current_user, recurring_todo).create(date)
        end
      end
    end
    return new_recurring_todo
  end

  def get_due_id_for_calendar(due)
    return "" if due.nil?
    due_today_date = Time.zone.now
    due_this_week_date = Time.zone.now.end_of_week
    due_next_week_date = due_this_week_date + 7.days
    due_this_month_date = Time.zone.now.end_of_month
    if due <= due_today_date
      new_due_id = "due_today"
    elsif due <= due_this_week_date
      new_due_id = "due_this_week"
    elsif due <= due_next_week_date
      new_due_id = "due_next_week"
    elsif due <= due_this_month_date
      new_due_id = "due_this_month"
    else
      new_due_id = "due_after_this_month"
    end
    return new_due_id
  end

  def is_old_due_empty(id)
    return 0 == count_old_due_empty(id)
  end

  def count_old_due_empty(id)
    due_today_date = Time.zone.now
    due_this_week_date = Time.zone.now.end_of_week
    due_next_week_date = due_this_week_date + 7.days
    due_this_month_date = Time.zone.now.end_of_month
    case id
    when "due_today"
      return current_user.todos.not_completed.where('todos.due <= ?', due_today_date).count
    when "due_this_week"
      return current_user.todos.not_completed.where('todos.due > ? AND todos.due <= ?', due_today_date, due_this_week_date).count
    when "due_next_week"
      return current_user.todos.not_completed.where('todos.due > ? AND todos.due <= ?', due_this_week_date, due_next_week_date).count
    when "due_this_month"
      return current_user.todos.not_completed.where('todos.due > ? AND todos.due <= ?', due_next_week_date, due_this_month_date).count
    when "due_after_this_month"
      return current_user.todos.not_completed.where('todos.due > ?', due_this_month_date).count
    else
      raise Exception.new, "unknown due id for calendar: '#{id}'"
    end
  end

  def cache_attributes_from_before_update
    @original_item_context_id = @todo.context_id
    @original_item_project_id = @todo.project_id
    @original_item_was_deferred = @todo.deferred?
    @original_item_was_hidden = @todo.hidden?
    @original_item_was_pending = @todo.pending?
    @original_item_due = @todo.due
    @original_item_due_id = get_due_id_for_calendar(@todo.due)
    @original_item_predecessor_list = @todo.predecessors.map{|t| t.specification}.join(', ')
    @original_item_description = @todo.description
    @todo_was_deferred_or_blocked = @todo.deferred? || @todo.pending?
  end

  def update_project
    @project_changed = false
    if params['todo']['project_id'].blank? && !params['project_name'].nil?
      if params['project_name'].blank?
        project = Project.null_object
      else
        project = current_user.projects.where(:name => params['project_name'].strip).first
        unless project
          project = current_user.projects.build
          project.name = params['project_name'].strip
          project.save
          @new_project_created = true
          @new_container = project
          @not_done_todos = [@todo]
        end
      end
      params["todo"]["project_id"] = project.id
      @project_changed = @original_item_project_id != params["todo"]["project_id"] = project.id
    end
  end

  def update_todo_state_if_project_changed
    if @project_changed
      @todo.update_state_from_project
      @remaining_undone_in_project = current_user.projects.find(@original_item_project_id).todos.active.count if source_view_is :project
    end
  end

  def update_context
    @context_changed = false
    if params['todo']['context_id'].blank? && params['context_name'].present?
      @context = current_user.contexts.where(:name => params['context_name'].strip).first
      if @context.nil?
        @new_context = current_user.contexts.build
        @new_context.name = params['context_name'].strip
        @new_context.save
        @new_context_created = true
        @new_container = @new_context
        @not_done_todos = [@todo]
        @context = @new_context
      end
      params["todo"]["context_id"] = @context.id
      @context_changed = @original_item_context_id != params["todo"]["context_id"] = @context.id
    end
  end

  def update_tags
    if params[:tag_list]
      @todo.tag_with(params[:tag_list])
      @todo.tags(true) #force a reload for proper rendering
    end
  end

  def parse_date_for_update(date, error_msg)
    begin
      parse_date_per_user_prefs(date)
    rescue
      @todo.errors[:base] << error_msg
    end
  end

  def update_date_for_update(key)
    params['todo'][key] = params["todo"].has_key?(key) ? parse_date_for_update(params["todo"][key], t("todos.error.invalid_#{key}_date")) : ""
  end

  def update_due_and_show_from_dates
    %w{ due show_from }.each {|date| update_date_for_update(date) }
  end

  def update_completed_state
    if params['done'] == '1' && !@todo.completed?
      @todo.complete!
      @todo.activate_pending_todos
    end
    # strange. if checkbox is not checked, there is no 'done' in params.
    # Therefore I've used the negation
    if !(params['done'] == '1') && @todo.completed?
      @todo.activate!
      @todo.block_successors
    end
  end

  def update_dependencies
    @todo.add_predecessor_list(params[:predecessor_list])
  end

  def update_dependency_state
    # assumes @todo.save was called so that the predecessor_list is persistent
    if @original_item_predecessor_list != params[:predecessor_list]
      # Possible state change with new dependencies
      if @todo.uncompleted_predecessors.empty?
        @todo.activate! if @todo.state == 'pending' # Activate pending if no uncompleted predecessors
      else
        @todo.block! if @todo.state == 'active' # Block active if we got uncompleted predecessors
      end
    end
  end

  def update_attributes_of_todo
    # TODO: duplication with todo_create_params_helper
    @todo.attributes = params.require(:todo).permit(
        :context_id, :project_id, :description, :notes,
        :due, :show_from, :state)
  end

  def determine_changes_by_this_update
    @todo_was_activated_from_deferred_state = @todo.active? && @original_item_was_deferred
    @todo_was_activated_from_pending_state = @todo.active? && @original_item_was_pending
    @todo_was_deferred_from_active_state = @todo.deferred? && !@original_item_was_deferred
    @todo_was_blocked_from_active_state = @todo.pending? && !@original_item_was_pending

    @todo_deferred_state_changed = @original_item_was_deferred != @todo.deferred?
    @todo_pending_state_changed = @original_item_was_pending != @todo.pending?
    @todo_hidden_state_changed = @original_item_was_hidden != @todo.hidden?

    @due_date_changed = @original_item_due != @todo.due

    source_view do |page|
      page.calendar do
        @old_due_empty = is_old_due_empty(@original_item_due_id)
        @new_due_id = get_due_id_for_calendar(@todo.due)
      end
      page.tag do
        @tag_name = params['_tag_name']
        @tag_was_removed = !@todo.has_tag?(@tag_name)
      end
      page.context do
        @todo_should_be_hidden = @todo_hidden_state_changed && @todo.hidden?
      end
    end
  end

  # all completed todos [today@00:00, today@now]
  def get_done_today(completed_todos, includes = {:include => Todo::DEFAULT_INCLUDES})
    start_of_this_day = Time.zone.now.beginning_of_day
    completed_todos.completed_after(start_of_this_day).includes(includes[:include])
  end

  def get_done_in_period(completed_todos, before, after, includes = {:include => Todo::DEFAULT_INCLUDES})
    completed_todos.completed_before(before).completed_after(after).includes(includes[:include])
  end

  # all completed todos [begin_of_week, start_of_today]
  def get_done_rest_of_week(completed_todos, includes = {:include => Todo::DEFAULT_INCLUDES})
    get_done_in_period(completed_todos, Time.zone.now.beginning_of_day, Time.zone.now.beginning_of_week)
  end

  # all completed todos [begin_of_month, begin_of_week]
  def get_done_rest_of_month(completed_todos, includes = {:include => Todo::DEFAULT_INCLUDES})
    get_done_in_period(completed_todos, Time.zone.now.beginning_of_week, Time.zone.now.beginning_of_month)
  end

  def get_not_done_todos
      # TODO: refactor text feed for done todos to todos/done.text, not /todos.text?done=true
    if params[:done]
      not_done_todos = current_user.todos.completed.completed_after(Time.zone.now - params[:done].to_i.days)
    else
      not_done_todos = current_user.todos.active.not_hidden
    end

    not_done_todos = not_done_todos.
      reorder("todos.due IS NULL, todos.due ASC, todos.created_at ASC").
      includes(Todo::DEFAULT_INCLUDES)

    not_done_todos = not_done_todos.limit(sanitize(params[:limit])) if params[:limit]

    if params[:due]
      due_within_when = Time.zone.now + params['due'].to_i.days
      not_done_todos = not_done_todos.where('todos.due <= ?', due_within_when)
    end

    if params[:tag]
      tag = Tag.where(:name => params['tag']).first
      not_done_todos = not_done_todos.where('taggings.tag_id = ?', tag.id)
    end

    if params[:context_id]
      context = current_user.contexts.find(params[:context_id])
      not_done_todos = not_done_todos.where('context_id' => context.id)
    end

    if params[:project_id]
      project = current_user.projects.find(params[:project_id])
      not_done_todos = not_done_todos.where('project_id' => project)
    end

    return not_done_todos
  end

  def onsite_redirect_to(destination)
    uri = URI.parse(destination)

    if uri.query.present?
      redirect_to("#{uri.path}?#{uri.query}")
    else
      redirect_to(uri.path)
    end
  end

end
