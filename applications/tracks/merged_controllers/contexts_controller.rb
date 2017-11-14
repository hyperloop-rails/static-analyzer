class ContextsController < ApplicationController

  helper :todos

  before_filter :init, :except => [:index, :create, :destroy, :order]
  before_filter :set_context_from_params, :only => [:update, :destroy]
  skip_before_filter :login_required, :only => [:index]
  prepend_before_filter :login_or_feed_token_required, :only => [:index]

  def index
    @all_contexts    = current_user.contexts
    @active_contexts = current_user.contexts.active
    @hidden_contexts = current_user.contexts.hidden
    @closed_contexts = current_user.contexts.closed
    init_not_done_counts(['context']) unless request.format == :autocomplete

    respond_to do |format|
      format.html &render_contexts_html
      format.m    &render_contexts_mobile
      format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  t('contexts.visible_contexts') 
  context = context_listing 
 link_to context.name, context_path(context, :format => 'm') 
 " (#{count_undone_todos_phrase(context)})".html_safe 
 
 t('contexts.hidden_contexts') 
  context = context_listing 
 link_to context.name, context_path(context, :format => 'm') 
 " (#{count_undone_todos_phrase(context)})".html_safe 
 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end
 }
      format.any(:rss, :atom) do
        @feed_title = 'Tracks Contexts'
        @feed_description = "Lists all the contexts for #{current_user.display_name}"
      end
      format.text do
        # somehow passing Mime::TEXT using content_type to render does not work
        headers['Content-Type']=Mime::TEXT.to_s
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t('contexts.visible_contexts') 
  context = context_listing 
 link_to context.name, context_path(context, :format => 'm') 
 " (#{count_undone_todos_phrase(context)})".html_safe 
 
 t('contexts.hidden_contexts') 
  context = context_listing 
 link_to context.name, context_path(context, :format => 'm') 
 " (#{count_undone_todos_phrase(context)})".html_safe 
 

end

      end
      format.autocomplete &render_autocomplete
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
  t('contexts.visible_contexts') 
  context = context_listing 
 link_to context.name, context_path(context, :format => 'm') 
 " (#{count_undone_todos_phrase(context)})".html_safe 
 
 t('contexts.hidden_contexts') 
  context = context_listing 
 link_to context.name, context_path(context, :format => 'm') 
 " (#{count_undone_todos_phrase(context)})".html_safe 
 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def show
    set_context_from_params

    unless @context.nil?
      @max_completed = current_user.prefs.show_number_completed
      @done = @context.todos.completed.limit(@max_completed).reorder("todos.completed_at DESC, todos.created_at DESC").includes(Todo::DEFAULT_INCLUDES)
      @not_done_todos = @context.todos.active.reorder("todos.due IS NULL, todos.due ASC, todos.created_at ASC").includes(Todo::DEFAULT_INCLUDES)
      @todos_without_project = @not_done_todos.select{|t| t.project.nil?}

      @deferred_todos = @context.todos.deferred.includes(Todo::DEFAULT_INCLUDES)
      @pending_todos = @context.todos.pending.includes(Todo::DEFAULT_INCLUDES)

      @projects = current_user.projects
      @contexts = current_user.contexts

      @projects_to_show = @projects.active
      @contexts_to_show = [@context]

      @count = @not_done_todos.count + @deferred_todos.count + @pending_todos.count
      @page_title = "TRACKS::Context: #{@context.name}"
      respond_to do |format|
        format.html
        format.m    &render_context_mobile
        format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 
  suffix_completed = t('contexts.last_completed_in_context', :number=>prefs.show_number_completed)
  deferred_pending_options = {:append_descriptor => nil, :parent_container_type => 'context'}
  done_todo_options = {:append_descriptor => suffix_completed, :suppress_context => true, :parent_container_type => 'context'}
  show_empty_containers = (@group_view_by == 'context')

 empty_message_holder("not_done_context", @not_done_todos.empty?) 
 show_grouped_todos({:collapsible => false, :show_empty_containers => false, :parent_container_type => 'context'}) 
 if @group_view_by == 'project' 
 show_todos_without_project(@todos_without_project, {:collapsible => false, :parent_container_type => 'context', :title_param => @context.name}) 
 end 
 show_deferred_pending_todos(@deferred_todos, @pending_todos, deferred_pending_options) 
 show_done_todos(@done, done_todo_options) unless @done.nil? 
 
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
    else
      respond_to do |format|
        format.html { render :text => 'Context not found', :status => 404 }
        format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 
  suffix_completed = t('contexts.last_completed_in_context', :number=>prefs.show_number_completed)
  deferred_pending_options = {:append_descriptor => nil, :parent_container_type => 'context'}
  done_todo_options = {:append_descriptor => suffix_completed, :suppress_context => true, :parent_container_type => 'context'}
  show_empty_containers = (@group_view_by == 'context')

 empty_message_holder("not_done_context", @not_done_todos.empty?) 
 show_grouped_todos({:collapsible => false, :show_empty_containers => false, :parent_container_type => 'context'}) 
 if @group_view_by == 'project' 
 show_todos_without_project(@todos_without_project, {:collapsible => false, :parent_container_type => 'context', :title_param => @context.name}) 
 end 
 show_deferred_pending_todos(@deferred_todos, @pending_todos, deferred_pending_options) 
 show_done_todos(@done, done_todo_options) unless @done.nil? 
 
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
 
  suffix_completed = t('contexts.last_completed_in_context', :number=>prefs.show_number_completed)
  deferred_pending_options = {:append_descriptor => nil, :parent_container_type => 'context'}
  done_todo_options = {:append_descriptor => suffix_completed, :suppress_context => true, :parent_container_type => 'context'}
  show_empty_containers = (@group_view_by == 'context')

 empty_message_holder("not_done_context", @not_done_todos.empty?) 
 show_grouped_todos({:collapsible => false, :show_empty_containers => false, :parent_container_type => 'context'}) 
 if @group_view_by == 'project' 
 show_todos_without_project(@todos_without_project, {:collapsible => false, :parent_container_type => 'context', :title_param => @context.name}) 
 end 
 show_deferred_pending_todos(@deferred_todos, @pending_todos, deferred_pending_options) 
 show_done_todos(@done, done_todo_options) unless @done.nil? 
 
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

  def create
    if params[:format] == 'application/xml' && params['exception']
      render_failure "Expected post format is valid xml like so: <context><name>context name</name></context>.", 400
      return
    end
    @context = current_user.contexts.build(context_params)
    @context.hide! if params['context_state'] && params['context_state']['hide'] == '1'
    @saved = @context.save
    @context_not_done_counts = { @context.id => 0 }
    respond_to do |format|
      format.js do
        @down_count = current_user.contexts.size
        init_not_done_counts
      end
      format.xml do
        if @context.new_record?
          render_failure @context.errors.to_xml.html_safe, 409
        else
          head :created, :location => context_url(@context)
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
  if @saved 
 @down_count 
@context.state
 else 
 end 
@context.state
 @saved ? js_render('context_listing', {}, @context) : "" 
 js_error_messages_for(@context) 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  # Edit the details of the context
  #
  def update
    process_params_for_update

    @context.attributes = context_params
    @saved = @context.save
    @state_saved = set_state_for_update(@new_state)
    @saved = @saved && @state_saved

    if @saved
      @state_changed = (@original_context_state != @context.state)
      @new_state = @context.state if @state_changed
      @active_contexts = current_user.contexts.active
      @hidden_contexts = current_user.contexts.hidden
      @closed_contexts = current_user.contexts.closed
    end

    respond_to do |format|
      format.js
      format.xml {
          if @saved
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
 
  object_name = unique_object_name_for("update_context_#{@context.id}")

object_name
 unless @saved 
object_name
 js_error_messages_for(@context) 
 else 
 t('contexts.save_status_message') 
 if @state_changed 
object_name
object_name
 else 
object_name
 end 
 escape_javascript(@context.name)
dom_id(@context, 'container')
dom_id(@context, 'container')
@new_state
object_name
dom_id(@context, 'container')

        # first add the updated context after the old one, then remove old one
        # using html() does not work, because it will replace the _content_ of
        # the container instead of the container itself, i.e. you will get
        # a container within a container which will break drag-and-drop sorting
      
dom_id(@context, 'container')
object_name
dom_id(@context, 'container')
dom_id(@context, 'container')
@active_contexts.count
@hidden_contexts.count
@closed_contexts.count
 js_render('context_listing', {}, @context)
 end 
object_name
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

          else
            render :text => "Error on update: #{@context.errors.full_messages.inject("") {|v, e| v + e + " " }}", :status => 409
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
 
  object_name = unique_object_name_for("update_context_#{@context.id}")

object_name
 unless @saved 
object_name
 js_error_messages_for(@context) 
 else 
 t('contexts.save_status_message') 
 if @state_changed 
object_name
object_name
 else 
object_name
 end 
 escape_javascript(@context.name)
dom_id(@context, 'container')
dom_id(@context, 'container')
@new_state
object_name
dom_id(@context, 'container')

        # first add the updated context after the old one, then remove old one
        # using html() does not work, because it will replace the _content_ of
        # the container instead of the container itself, i.e. you will get
        # a container within a container which will break drag-and-drop sorting
      
dom_id(@context, 'container')
object_name
dom_id(@context, 'container')
dom_id(@context, 'container')
@active_contexts.count
@hidden_contexts.count
@closed_contexts.count
 js_render('context_listing', {}, @context)
 end 
object_name
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def edit
    @context = Context.find(params[:id])
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
  object_name = unique_object_name_for("edit_context_#{@context.id}") 
object_name
object_name
dom_id(@context)
object_name
object_name
dom_id(@context, 'edit')
object_name
dom_id(@context, 'edit')
 js_render('context_form', {}, @context) 
 object_name 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  # Fairly self-explanatory; deletes the context If the context contains
  # actions, you'll get a warning dialogue. If you choose to go ahead, any
  # actions in the context will also be deleted.
  def destroy
    # make sure the deleted recurrence patterns are removed from associated todos
    @context.recurring_todos.each(&:clear_todos_association) unless @context.recurring_todos.nil?

    @context.destroy
    respond_to do |format|
      format.js do
        @down_count = current_user.contexts.size
        update_state_counts
      end
      format.xml { render :text => "Deleted context #{@context.name}" }
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
 @active_contexts_count
@hidden_contexts_count
@closed_contexts_count
@down_count
  t('contexts.context_deleted', :name=>@context.name)
dom_id(@context, "container")
dom_id(@context, "container")
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  # Methods for changing the sort order of the contexts in the list
  #
  def order
    context_ids = params["container_context"]
    @projects = current_user.contexts.update_positions( context_ids )
    render :nothing => true
  rescue
    notify :error, $!
    redirect_to :action => 'index'
  end

  def done_todos
    done_todos_for current_user.contexts.find(params[:id])
  end

  def all_done_todos
    all_done_todos_for current_user.contexts.find(params[:id])
  end

  private

  def context_params
    params.require(:context).permit(:name, :position, :state)
  end

  protected

  def update_state_counts
    @active_contexts_count = current_user.contexts.active.count
    @hidden_contexts_count = current_user.contexts.hidden.count
    @closed_contexts_count = current_user.contexts.closed.count
    @show_active_contexts = @active_contexts_count > 0
    @show_hidden_contexts = @hidden_contexts_count > 0
    @show_closed_contexts = @closed_contexts_count > 0
  end

  def render_contexts_html
    lambda do
      @page_title = "TRACKS::List Contexts"
      @no_active_contexts = @active_contexts.empty?
      @no_hidden_contexts = @hidden_contexts.empty?
      @no_closed_contexts = @closed_contexts.empty?
      @active_count = @active_contexts.size
      @hidden_count = @hidden_contexts.size
      @closed_count = @closed_contexts.size
      @count = @active_count + @hidden_count + @closed_count
      @new_context = current_user.contexts.build

      render
    end
  end

  def render_contexts_mobile
    lambda do
      @page_title = "TRACKS::List Contexts"
      @active_contexts = current_user.contexts.active
      @hidden_contexts = current_user.contexts.hidden
      @down_count = @active_contexts.size + @hidden_contexts.size
      cookies[:mobile_url]= {:value => request.fullpath, :secure => SITE_CONFIG['secure_cookies']}
      render
    end
  end

  def render_context_mobile
    lambda do
      @page_title = "TRACKS::List actions in "+@context.name
      @not_done = @not_done_todos.select {|t| t.context_id == @context.id }
      @down_count = @not_done.size
      cookies[:mobile_url]= {:value => request.fullpath, :secure => SITE_CONFIG['secure_cookies']}
      @mobile_from_context = @context.id
      render
    end
  end

  def render_autocomplete
    lambda do
      render :text => for_autocomplete(current_user.contexts, params[:term])
    end
  end

  def feed_options
    Context.feed_options(current_user)
  end

  def set_context_from_params
    @context = current_user.contexts.find(params[:id])
  rescue
    @context = nil
  end

  def init
    @source_view = params['_source_view'] || 'context'
    init_data_for_sidebar
  end

  def process_params_for_update
    params['context'] ||= {}
    @success_text = if params['field'] == 'name' && params['value']
      params['context']['id'] = params['id']
      params['context']['name'] = params['value']
    end

    @original_context_state = @context.state
    @new_state = params['context']['state']
    params['context'].delete('state')
  end

  def set_state_for_update(new_state)
    begin
      unless @original_context_state == new_state
        if new_state == 'active'
          @context.activate!
        elsif new_state == 'hidden'
          @context.hide!
        elsif new_state == 'closed'
          @context.close!
        end
      end
      return true
    rescue AASM::InvalidTransition
      @context.errors.add(:state, "cannot be changed. The context cannot be closed if you have uncompleted actions in this context")
      return false
    end
  end

end
