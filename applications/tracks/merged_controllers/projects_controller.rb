class ProjectsController < ApplicationController

  helper :application, :todos, :notes
  before_filter :set_source_view
  before_filter :set_project_from_params, :only => [:update, :destroy, :show, :edit, :set_reviewed]
  before_filter :default_context_filter, :only => [:create, :update]
  skip_before_filter :login_required, :only => [:index]
  prepend_before_filter :login_or_feed_token_required, :only => [:index]

  def index
    @source_view = params['_source_view'] || 'project_list'
    if params[:projects_and_actions]
      projects_and_actions
    else
      @contexts = current_user.contexts
      init_not_done_counts(['project'])
      init_project_hidden_todo_counts(['project'])
      if params[:only_active_with_no_next_actions]
        @projects = current_user.projects.active.select { |p| count_undone_todos(p) == 0  }
      else
        @projects = current_user.projects
      end
      @active_projects = current_user.projects.active
      @hidden_projects = current_user.projects.hidden
      respond_to do |format|
        format.html  do
          @page_title = t('projects.list_projects')
          @count = current_user.projects.count
          @completed_projects = current_user.projects.completed.limit(10)
          @completed_count = current_user.projects.completed.count
          @no_projects = current_user.projects.empty?
          current_user.projects.cache_note_counts
          @new_project = current_user.projects.build
        end
        format.m     do
          @completed_projects = current_user.projects.completed
          @down_count = @active_projects.size + @hidden_projects.size + @completed_projects.size
          cookies[:mobile_url]= {:value => request.fullpath, :secure => SITE_CONFIG['secure_cookies']}
        end
        format.xml   { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  t('projects.active_projects') 

   project = project_listing 

  link_to(project.name, project_path(project, :format => 'm')) +
    " (" + count_undone_todos_and_notes_phrase(project) + ")" 

 t('projects.hidden_projects') 

   project = project_listing 

  link_to(project.name, project_path(project, :format => 'm')) +
    " (" + count_undone_todos_and_notes_phrase(project) + ")" 
 
 t('projects.completed_projects') 

   project = project_listing 

  link_to(project.name, project_path(project, :format => 'm')) +
    " (" + count_undone_todos_and_notes_phrase(project) + ")" 
 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end
  }
        format.any(:rss, :atom) do
          @feed_title = I18n.t('models.project.feed_title')
          @feed_description = I18n.t('models.project.feed_description', :username => current_user.display_name)
        end
        format.text do
          # somehow passing Mime::TEXT using content_type to render does not work
          headers['Content-Type']=Mime::TEXT.to_s
        end
        format.autocomplete do
          projects = current_user.projects.active + current_user.projects.hidden
          render :text => for_autocomplete(projects, params[:term])
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
  t('projects.active_projects') 

   project = project_listing 

  link_to(project.name, project_path(project, :format => 'm')) +
    " (" + count_undone_todos_and_notes_phrase(project) + ")" 

 t('projects.hidden_projects') 

   project = project_listing 

  link_to(project.name, project_path(project, :format => 'm')) +
    " (" + count_undone_todos_and_notes_phrase(project) + ")" 
 
 t('projects.completed_projects') 

   project = project_listing 

  link_to(project.name, project_path(project, :format => 'm')) +
    " (" + count_undone_todos_and_notes_phrase(project) + ")" 
 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def review
    @source_view = params['_source_view'] || 'review'
    @page_title = t('projects.list_reviews')
    @projects = current_user.projects.load
    @contexts = current_user.contexts.load
    @projects_to_review = current_user.projects.select  {|p| p.needs_review?(current_user)}
    @stalled_projects = current_user.projects.select  {|p| p.stalled?}
    @blocked_projects = current_user.projects.select  {|p| p.blocked?}
    @current_projects = current_user.projects.uncompleted.select  {|p| not(p.needs_review?(current_user))}

    init_not_done_counts(['project'])
    init_project_hidden_todo_counts(['project'])
    current_user.projects.cache_note_counts

    @page_title = t('projects.list_reviews')
    @count = @projects_to_review.count + @blocked_projects.count + @stalled_projects.count + @current_projects.count

    @no_projects = current_user.projects.empty?
    @new_project = current_user.projects.build
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
  @no_projects ? 'display:block' : 'display:none'
 t('projects.no_projects') 
 
  total_count ||= -1
  total_count_string = total_count!=-1 ? " / #{total_count}" : ""
  suppress_sort_menu ||= false
  suppress_drag_handle ||= false

 state 
 " style=\"display:none\"" if project_state_group.empty? 
 state 
 project_state_group.length
 total_count_string
 t('common.last' ) if state == 'completed' 
 t('states.projects.'+state) 
 total_count==-1 ? "" : " (#{link_to(t('common.show_all'), done_projects_path)})".html_safe
 unless suppress_sort_menu 
 t('common.sort.sort') 
 link_to(t("common.sort.alphabetically"), alphabetize_projects_path(:state => state),
        :id => "#{state}_alphabetize_link", :class => "alphabetize_link", :title => t('common.sort.alphabetically_title'), :x_confirm_message => t('common.sort.alphabetically_confirm')) 
 link_to(t("common.sort.by_task_count"), actionize_projects_path(:state => state),
        :id => "#{state}_actionize_link", :class => "actionize_link", :title => t('common.sort.by_task_count_title'), :x_confirm_message => t('common.sort.by_task_count_title_confirm')) 
 end 
 state 
  project = project_listing 

  link_to(project.name, project_path(project, :format => 'm')) +
    " (" + count_undone_todos_and_notes_phrase(project) + ")" 
 
 
 
  total_count ||= -1
  total_count_string = total_count!=-1 ? " / #{total_count}" : ""
  suppress_sort_menu ||= false
  suppress_drag_handle ||= false

 state 
 " style=\"display:none\"" if project_state_group.empty? 
 state 
 project_state_group.length
 total_count_string
 t('common.last' ) if state == 'completed' 
 t('states.projects.'+state) 
 total_count==-1 ? "" : " (#{link_to(t('common.show_all'), done_projects_path)})".html_safe
 unless suppress_sort_menu 
 t('common.sort.sort') 
 link_to(t("common.sort.alphabetically"), alphabetize_projects_path(:state => state),
        :id => "#{state}_alphabetize_link", :class => "alphabetize_link", :title => t('common.sort.alphabetically_title'), :x_confirm_message => t('common.sort.alphabetically_confirm')) 
 link_to(t("common.sort.by_task_count"), actionize_projects_path(:state => state),
        :id => "#{state}_actionize_link", :class => "actionize_link", :title => t('common.sort.by_task_count_title'), :x_confirm_message => t('common.sort.by_task_count_title_confirm')) 
 end 
 state 
  project = project_listing 

  link_to(project.name, project_path(project, :format => 'm')) +
    " (" + count_undone_todos_and_notes_phrase(project) + ")" 
 
 
 
  total_count ||= -1
  total_count_string = total_count!=-1 ? " / #{total_count}" : ""
  suppress_sort_menu ||= false
  suppress_drag_handle ||= false

 state 
 " style=\"display:none\"" if project_state_group.empty? 
 state 
 project_state_group.length
 total_count_string
 t('common.last' ) if state == 'completed' 
 t('states.projects.'+state) 
 total_count==-1 ? "" : " (#{link_to(t('common.show_all'), done_projects_path)})".html_safe
 unless suppress_sort_menu 
 t('common.sort.sort') 
 link_to(t("common.sort.alphabetically"), alphabetize_projects_path(:state => state),
        :id => "#{state}_alphabetize_link", :class => "alphabetize_link", :title => t('common.sort.alphabetically_title'), :x_confirm_message => t('common.sort.alphabetically_confirm')) 
 link_to(t("common.sort.by_task_count"), actionize_projects_path(:state => state),
        :id => "#{state}_actionize_link", :class => "actionize_link", :title => t('common.sort.by_task_count_title'), :x_confirm_message => t('common.sort.by_task_count_title_confirm')) 
 end 
 state 
  project = project_listing 

  link_to(project.name, project_path(project, :format => 'm')) +
    " (" + count_undone_todos_and_notes_phrase(project) + ")" 
 
 
 
  total_count ||= -1
  total_count_string = total_count!=-1 ? " / #{total_count}" : ""
  suppress_sort_menu ||= false
  suppress_drag_handle ||= false

 state 
 " style=\"display:none\"" if project_state_group.empty? 
 state 
 project_state_group.length
 total_count_string
 t('common.last' ) if state == 'completed' 
 t('states.projects.'+state) 
 total_count==-1 ? "" : " (#{link_to(t('common.show_all'), done_projects_path)})".html_safe
 unless suppress_sort_menu 
 t('common.sort.sort') 
 link_to(t("common.sort.alphabetically"), alphabetize_projects_path(:state => state),
        :id => "#{state}_alphabetize_link", :class => "alphabetize_link", :title => t('common.sort.alphabetically_title'), :x_confirm_message => t('common.sort.alphabetically_confirm')) 
 link_to(t("common.sort.by_task_count"), actionize_projects_path(:state => state),
        :id => "#{state}_actionize_link", :class => "actionize_link", :title => t('common.sort.by_task_count_title'), :x_confirm_message => t('common.sort.by_task_count_title_confirm')) 
 end 
 state 
  project = project_listing 

  link_to(project.name, project_path(project, :format => 'm')) +
    " (" + count_undone_todos_and_notes_phrase(project) + ")" 
 
 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def done
    @source_view = params['_source_view'] || 'project_list'
    @page_title = t('projects.list_completed_projects')

    items_per_page = 20
    page = params[:page] || 1
    @projects = current_user.projects.completed.paginate :page => page, :per_page => items_per_page
    @count = @projects.count
    @total = current_user.projects.completed.count
    @no_projects = @projects.empty?

    @range_low = (page.to_i-1) * items_per_page + 1
    @range_high = @range_low + @projects.size - 1

    @range_low = 0 if @total == 0
    @range_high = @total if @range_high > @total

    init_not_done_counts(['project'])
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
    :class => :link_in_container_header,
    :previous_label => '&laquo; '+ t('common.previous'),
    :next_label     => t('common.next')+' &raquo;',
    :inner_window   => 2
  }

 @no_projects ? 'display:block' : 'display:none'
 t('projects.no_projects') 
 " style=\"display:none\"" if @no_projects 
 will_paginate @projects, paginate_options 
 "#{@total} (#{@range_low}-#{@range_high})" 
 t('states.completed_plural' )
 t('common.projects') 
  project = project_listing 

  link_to(project.name, project_path(project, :format => 'm')) +
    " (" + count_undone_todos_and_notes_phrase(project) + ")" 
 
 will_paginate @projects, paginate_options 
 t('common.sort.sort') 
 t('states.completed_plural' )
 t('common.projects') 
 link_to(t("common.sort.alphabetically"), alphabetize_projects_path(:state => :completed),
        :id => "completed_alphabetize_link", :class => "alphabetize_link", :title => t('common.sort.alphabetically_title'), :x_confirm_message => t('common.sort.alphabetically_confirm')) 
 link_to(t("common.sort.by_task_count"), actionize_projects_path(:state => :completed),
        :id => "completed_actionize_link", :class => "actionize_link", :title => t('common.sort.by_task_count_title'), :x_confirm_message => t('common.sort.by_task_count_title_confirm')) 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def set_reviewed
    @project.last_reviewed = Time.zone.now
    @project.save

    case @source_view
    when "project"
      redirect_to :action => 'show'
    when "project_list"
      redirect_to :action => 'index'
    when "review"
      redirect_to :action => 'review'
    else
      redirect_to :action => 'index'
    end
  end

  def projects_and_actions
    @projects = current_user.projects.active
    respond_to do |format|
      format.text  {
        # somehow passing Mime::TEXT using content_type to render does not work
        headers['Content-Type']=Mime::TEXT.to_s
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @projects.each do |p| 
 p.name.upcase 
 actions = p.todos.select { |t| t.active? } 
 render :partial => actions 
 end 

end

      }
    end
  end

  def show
    @max_completed = current_user.prefs.show_number_completed
    init_data_for_sidebar unless mobile?
    @page_title = t('projects.page_title', :project => @project.name)

    @not_done_todos = @project.todos.active_or_hidden.includes(Todo::DEFAULT_INCLUDES)
    @deferred_todos = @project.todos.deferred.includes(Todo::DEFAULT_INCLUDES)
    @pending_todos = @project.todos.pending.includes(Todo::DEFAULT_INCLUDES)
    @contexts_to_show = current_user.contexts.active
    @projects_to_show = [@project]

    @done = {}
    @done = @project.todos.completed.
      reorder("todos.completed_at DESC").
      limit(current_user.prefs.show_number_completed).
      includes(Todo::DEFAULT_INCLUDES) unless @max_completed == 0

    @down_count = @not_done_todos.size + @deferred_todos.size + @pending_todos.size
    @count=@down_count
    @next_project = current_user.projects.next_from(@project)
    @previous_project = current_user.projects.previous_from(@project)
    @default_tags = @project.default_tags
    @new_note = current_user.notes.new
    @new_note.project_id = @project.id
    @contexts = current_user.contexts
    respond_to do |format|
      format.html
      format.m     do
        if @project.default_context.nil?
          @project_default_context = t('projects.no_default_context')
        else
          @project_default_context = t('projects.default_context', :context => @project.default_context.name)
        end
        cookies[:mobile_url]= {:value => request.fullpath, :secure => SITE_CONFIG['secure_cookies']}
        @mobile_from_project = @project.id
      end
      format.xml   do
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
 
  deferred_pending_options = {:append_descriptor => nil, :parent_container_type => 'project'}
  done_todo_options = {
    :append_descriptor => t('projects.last_completed_in_project', :number=>prefs.show_number_completed),
    :suppress_project => true,
    :parent_container_type => 'project'
  }
  if @not_done_todos.count == 0
    # force project view so one empty container will be shown with an empty message
    @group_view_by = 'project'
  end

 project_next_prev 
  show_project_name(project) 
 show_project_settings(project) 
 
 empty_message_holder("not_done_context", @not_done_todos.empty?) 
 show_grouped_todos({:collapsible => false, :show_empty_containers => false, :parent_container_type => 'project' }) 
 show_deferred_pending_todos(@deferred_todos, @pending_todos, deferred_pending_options) 
 show_done_todos(@done, done_todo_options) unless @done.nil? 
 link_to t('projects.add_note'), '#' 
 t('projects.notes') 
 @project.notes.empty? ? 'block' : 'none'
 t('projects.no_notes_attached') 
  note = notes_summary 
 dom_id(note) 
 link_to(
  image_tag("blank.png", :border => 0),
  note,
  :title => t('notes.show_note_title'),
  :class => "link_to_notes icon",
  :id => dom_id(note, "link")) 
 rendered_note(note) 
 note = nil 
 
 
submit_text ||= t('common.update')
note = note_edit_form


form_for(note, :html => {
    :id => dom_id(note, 'edit_form'),
    :class => "inline-form edit-note-form"}) do |f|

 get_list_of_error_messages_for(note) 
 f.hidden_field( "project_id" ) 
 f.text_area( "body", "cols" => 70, "rows" => 15) 
 dom_id(note, 'submit') 
image_tag("accept.png", :alt => "") 
 submit_text 
dom_id(note, 'edit_form')
image_tag("cancel.png", :alt => "") 
 t 'common.cancel' 
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
 
  deferred_pending_options = {:append_descriptor => nil, :parent_container_type => 'project'}
  done_todo_options = {
    :append_descriptor => t('projects.last_completed_in_project', :number=>prefs.show_number_completed),
    :suppress_project => true,
    :parent_container_type => 'project'
  }
  if @not_done_todos.count == 0
    # force project view so one empty container will be shown with an empty message
    @group_view_by = 'project'
  end

 project_next_prev 
  show_project_name(project) 
 show_project_settings(project) 
 
 empty_message_holder("not_done_context", @not_done_todos.empty?) 
 show_grouped_todos({:collapsible => false, :show_empty_containers => false, :parent_container_type => 'project' }) 
 show_deferred_pending_todos(@deferred_todos, @pending_todos, deferred_pending_options) 
 show_done_todos(@done, done_todo_options) unless @done.nil? 
 link_to t('projects.add_note'), '#' 
 t('projects.notes') 
 @project.notes.empty? ? 'block' : 'none'
 t('projects.no_notes_attached') 
  note = notes_summary 
 dom_id(note) 
 link_to(
  image_tag("blank.png", :border => 0),
  note,
  :title => t('notes.show_note_title'),
  :class => "link_to_notes icon",
  :id => dom_id(note, "link")) 
 rendered_note(note) 
 note = nil 
 
 
submit_text ||= t('common.update')
note = note_edit_form


form_for(note, :html => {
    :id => dom_id(note, 'edit_form'),
    :class => "inline-form edit-note-form"}) do |f|

 get_list_of_error_messages_for(note) 
 f.hidden_field( "project_id" ) 
 f.text_area( "body", "cols" => 70, "rows" => 15) 
 dom_id(note, 'submit') 
image_tag("accept.png", :alt => "") 
 submit_text 
dom_id(note, 'edit_form')
image_tag("cancel.png", :alt => "") 
 t 'common.cancel' 
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

  def create
    if params[:format] == 'application/xml' && params['exception']
      render_failure "Expected post format is valid xml like so: <project><name>project name</name></project>.", 400
      return
    end
    @project = current_user.projects.build(project_params)
    @go_to_project = params['go_to_project']
    @saved = @project.save
    @project_not_done_counts = { @project.id => 0 }
    @active_projects_count = current_user.projects.active.count
    @contexts = current_user.contexts

    respond_to do |format|
      format.js do
        @down_count = current_user.projects.size
        init_not_done_counts
      end
      format.xml do
        if @project.new_record?
          render_failure @project.errors.to_xml.html_safe, 409
        else
          head :created, :location => project_url(@project), :text => @project.id
        end
      end
      format.html {redirect_to :action => 'index'}
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
 js_error_messages_for(@project) 
 else 
 if @go_to_project 
 project_path(@project) 
 else 
 @down_count 
 @project.name
 end 
@active_projects_count
 @saved ? js_render('project_listing', {}, @project) : "" 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  # Edit the details of the project
  #
  def update
    template = ""

    params['project'] ||= {}
    if params['project']['state']
      @new_state = params['project']['state']
      @state_changed = @project.state != @new_state
      params['project'].delete('state')
    end
    success_text = if params['field'] == 'name' && params['value']
      params['project']['id'] = params['id']
      params['project']['name'] = params['value']
    end

    @project.attributes = project_params
    @saved = @project.save
    if @saved
      @project.transition_to(@new_state) if @state_changed
      if boolean_param('wants_render')
        @contexts = current_user.contexts
        update_state_counts
        init_data_for_sidebar
        init_project_hidden_todo_counts(['project'])

        template = 'projects/update'

      # TODO: are these params ever set? or is this dead code?
      elsif boolean_param('update_status')
        template = 'projects/update_status'
      elsif boolean_param('update_default_context')
        @initial_context_name = @project.default_context.name
        template = 'projects/update_default_context'
      elsif boolean_param('update_default_tags')
        template = 'projects/update_default_tags'
      elsif boolean_param('update_project_name')
        # clicking on a project name in the project view gives a form triggering this
        @projects = current_user.projects
        template = 'projects/update_project_name'
      else
        render :text => success_text || 'Success'
        return
      end
    else
      init_data_for_sidebar
      template = 'projects/update'
    end

    respond_to do |format|
      format.js { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 
  object_name = unique_object_name_for("update_project_#{@project.id}")

object_name
 unless @saved 
object_name
 js_error_messages_for(@project) 

    else
  
t('projects.project_saved_status')
 if source_view_is_one_of(:project_list, :review) 
object_name
 else # assume source_view :project 
object_name
 end 
 if @state_changed 
object_name
 else 
object_name
 end 
@active_projects_count
@hidden_projects_count
@completed_projects_count
 @show_active_projects 
 @show_hidden_projects 
 @show_completed_projects 
object_name
object_name
 escape_javascript(@project.name)
 escape_javascript(@project.name)
 if @project.default_context 
 escape_javascript(@project.default_context.name)
 end 
 if @project.default_tags 
 escape_javascript(@project.default_tags)
 end 
object_name

          # do not remove() edit form as this will remove the DIV
          # that is needed to replace with the new form, so only empty the DIV
      
dom_id(@project, 'edit')
dom_id(@project, 'edit')
dom_id(@project, 'container')
object_name
dom_id(@project)
dom_id(@project, 'container')

          # first add the updated project after the old one, then remove old one.
          # Using html() does not work, because it will replace the _content_ of
          # the container instead of the container itself, i.e. you will get
          # a container within a container which will break drag-and-drop sorting
        
object_name
dom_id(@project, 'container')
dom_id(@project, 'container')
dom_id(@project, 'container')
@project.state
object_name

    # the following functions return empty string if rendering the partial is not
    # necessary, for example the sidebar is not on the project list page, so do not
    # render it into the function.
    
 source_view_is_one_of(:project_list, :review) ? js_render('project_listing', {:suppress_drag_handle => source_view_is(:review)}, @project) : "" 
 sidebar_html_for_titled_list(@sidebar.active_projects, t('sidebar.list_name_active_projects'))
 sidebar_html_for_titled_list(@sidebar.active_contexts, t('sidebar.list_name_active_contexts'))
 sidebar_html_for_titled_list(@sidebar.hidden_projects, t('sidebar.list_name_hidden_projects')) if prefs.show_hidden_projects_in_sidebar 
 sidebar_html_for_titled_list(@sidebar.completed_projects, t('sidebar.list_name_completed_projects')) if prefs.show_completed_projects_in_sidebar 
 sidebar_html_for_titled_list(@sidebar.hidden_contexts, t('sidebar.list_name_hidden_contexts')) if prefs.show_hidden_contexts_in_sidebar 
 
 source_view_is(:project) ? js_render('project_settings', {}, @project) : "" 
 end # if @saved 
object_name
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end
 }
      format.html { redirect_to :action => 'index'}
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
 
  object_name = unique_object_name_for("update_project_#{@project.id}")

object_name
 unless @saved 
object_name
 js_error_messages_for(@project) 

    else
  
t('projects.project_saved_status')
 if source_view_is_one_of(:project_list, :review) 
object_name
 else # assume source_view :project 
object_name
 end 
 if @state_changed 
object_name
 else 
object_name
 end 
@active_projects_count
@hidden_projects_count
@completed_projects_count
 @show_active_projects 
 @show_hidden_projects 
 @show_completed_projects 
object_name
object_name
 escape_javascript(@project.name)
 escape_javascript(@project.name)
 if @project.default_context 
 escape_javascript(@project.default_context.name)
 end 
 if @project.default_tags 
 escape_javascript(@project.default_tags)
 end 
object_name

          # do not remove() edit form as this will remove the DIV
          # that is needed to replace with the new form, so only empty the DIV
      
dom_id(@project, 'edit')
dom_id(@project, 'edit')
dom_id(@project, 'container')
object_name
dom_id(@project)
dom_id(@project, 'container')

          # first add the updated project after the old one, then remove old one.
          # Using html() does not work, because it will replace the _content_ of
          # the container instead of the container itself, i.e. you will get
          # a container within a container which will break drag-and-drop sorting
        
object_name
dom_id(@project, 'container')
dom_id(@project, 'container')
dom_id(@project, 'container')
@project.state
object_name

    # the following functions return empty string if rendering the partial is not
    # necessary, for example the sidebar is not on the project list page, so do not
    # render it into the function.
    
 source_view_is_one_of(:project_list, :review) ? js_render('project_listing', {:suppress_drag_handle => source_view_is(:review)}, @project) : "" 
 sidebar_html_for_titled_list(@sidebar.active_projects, t('sidebar.list_name_active_projects'))
 sidebar_html_for_titled_list(@sidebar.active_contexts, t('sidebar.list_name_active_contexts'))
 sidebar_html_for_titled_list(@sidebar.hidden_projects, t('sidebar.list_name_hidden_projects')) if prefs.show_hidden_projects_in_sidebar 
 sidebar_html_for_titled_list(@sidebar.completed_projects, t('sidebar.list_name_completed_projects')) if prefs.show_completed_projects_in_sidebar 
 sidebar_html_for_titled_list(@sidebar.hidden_contexts, t('sidebar.list_name_hidden_contexts')) if prefs.show_hidden_contexts_in_sidebar 
 
 source_view_is(:project) ? js_render('project_settings', {}, @project) : "" 
 end # if @saved 
object_name
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

        else
          render :text => "Error on update: #{@project.errors.full_messages.inject("") {|v, e| v + e + " " }}", :status => 409
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
 
  object_name = unique_object_name_for("update_project_#{@project.id}")

object_name
 unless @saved 
object_name
 js_error_messages_for(@project) 

    else
  
t('projects.project_saved_status')
 if source_view_is_one_of(:project_list, :review) 
object_name
 else # assume source_view :project 
object_name
 end 
 if @state_changed 
object_name
 else 
object_name
 end 
@active_projects_count
@hidden_projects_count
@completed_projects_count
 @show_active_projects 
 @show_hidden_projects 
 @show_completed_projects 
object_name
object_name
 escape_javascript(@project.name)
 escape_javascript(@project.name)
 if @project.default_context 
 escape_javascript(@project.default_context.name)
 end 
 if @project.default_tags 
 escape_javascript(@project.default_tags)
 end 
object_name

          # do not remove() edit form as this will remove the DIV
          # that is needed to replace with the new form, so only empty the DIV
      
dom_id(@project, 'edit')
dom_id(@project, 'edit')
dom_id(@project, 'container')
object_name
dom_id(@project)
dom_id(@project, 'container')

          # first add the updated project after the old one, then remove old one.
          # Using html() does not work, because it will replace the _content_ of
          # the container instead of the container itself, i.e. you will get
          # a container within a container which will break drag-and-drop sorting
        
object_name
dom_id(@project, 'container')
dom_id(@project, 'container')
dom_id(@project, 'container')
@project.state
object_name

    # the following functions return empty string if rendering the partial is not
    # necessary, for example the sidebar is not on the project list page, so do not
    # render it into the function.
    
 source_view_is_one_of(:project_list, :review) ? js_render('project_listing', {:suppress_drag_handle => source_view_is(:review)}, @project) : "" 
 sidebar_html_for_titled_list(@sidebar.active_projects, t('sidebar.list_name_active_projects'))
 sidebar_html_for_titled_list(@sidebar.active_contexts, t('sidebar.list_name_active_contexts'))
 sidebar_html_for_titled_list(@sidebar.hidden_projects, t('sidebar.list_name_hidden_projects')) if prefs.show_hidden_projects_in_sidebar 
 sidebar_html_for_titled_list(@sidebar.completed_projects, t('sidebar.list_name_completed_projects')) if prefs.show_completed_projects_in_sidebar 
 sidebar_html_for_titled_list(@sidebar.hidden_contexts, t('sidebar.list_name_hidden_contexts')) if prefs.show_hidden_contexts_in_sidebar 
 
 source_view_is(:project) ? js_render('project_settings', {}, @project) : "" 
 end # if @saved 
object_name
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def edit
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
 
  selector_edit = "div##{dom_id(@project, 'edit')}"
  selector_edit = "div.project-edit-current " + selector_edit unless @source_view=="project"
  selector_project = "div##{dom_id(@project)}"
  selector_project = "div.project-edit-current " + selector_project unless @source_view=="project"
  object_name = unique_object_name_for("edit_project_#{@project.id}")

object_name
object_name
 selector_project 
object_name
object_name
 selector_edit 
object_name
 selector_edit 
 js_render('project_form', {}, @project) 
object_name
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def destroy
    @project.recurring_todos.each(&:remove_from_project!)
    @project.destroy

    respond_to do |format|
      format.js {
        @down_count = current_user.projects.size
        update_state_counts
      }
      format.xml { render :text => "Deleted project #{@project.name}" }
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
 @active_projects_count
@hidden_projects_count
@completed_projects_count
 t('projects.project_destroyed_status', name: @project.name) 
@down_count
dom_id(@project, "container")
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def order
    project_ids = params["container_project"]
    @projects = current_user.projects.update_positions( project_ids )
    render :nothing => true
  rescue
    notify :error, $!
    redirect_to :action => 'index'
  end

  def alphabetize
    @state = params['state']
    @projects = current_user.projects.alphabetize(:state => @state) if @state
    @contexts = current_user.contexts
    init_not_done_counts(['project'])
    init_project_hidden_todo_counts(['project']) if @state == 'hidden'
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
   project = project_listing 

  link_to(project.name, project_path(project, :format => 'm')) +
    " (" + count_undone_todos_and_notes_phrase(project) + ")" 
 
@state
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def actionize
    @state = params['state']
    @projects = current_user.projects.actionize(:state => @state) if @state
    @contexts = current_user.contexts
    init_not_done_counts(['project'])
    init_project_hidden_todo_counts(['project']) if @state == 'hidden'
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
   project = project_listing 

  link_to(project.name, project_path(project, :format => 'm')) +
    " (" + count_undone_todos_and_notes_phrase(project) + ")" 
 
@state
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def done_todos
    done_todos_for current_user.projects.find(params[:id])
  end

  def all_done_todos
    all_done_todos_for current_user.projects.find(params[:id])
  end

  protected

  def update_state_counts
    @active_projects_count = current_user.projects.active.count
    @hidden_projects_count = current_user.projects.hidden.count
    @completed_projects_count = current_user.projects.completed.count
    @show_active_projects = @active_projects_count > 0
    @show_hidden_projects = @hidden_projects_count > 0
    @show_completed_projects = @completed_projects_count > 0
  end

  def set_project_from_params
    @project = current_user.projects.find_by_params(params)
  end

  def set_source_view
    @source_view = params['_source_view'] || 'project'
  end

  def default_context_filter
    p = params['project']
    p = params['request']['project'] if p.nil? && params['request']
    p = {} if p.nil?
    default_context_name = p['default_context_name']
    p.delete('default_context_name')

    if default_context_name.present?
      default_context = current_user.contexts.where(:name => default_context_name).first_or_create
      p['default_context_id'] = default_context.id
    else
      p['default_context_id'] = nil
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :position, :user_id, :description, :state, :default_context_id, :default_tags)
  end

end
