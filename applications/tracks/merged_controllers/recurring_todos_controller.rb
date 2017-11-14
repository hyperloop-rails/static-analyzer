class RecurringTodosController < ApplicationController

  helper :todos, :recurring_todos

  append_before_filter :init, :only => [:index, :new, :edit, :create]
  append_before_filter :get_recurring_todo_from_param, :only => [:destroy, :toggle_check, :toggle_star, :edit, :update]

  def index
    @page_title = t('todos.recurring_actions_title')
    @source_view = params['_source_view'] || 'recurring_todo'
    find_and_inactivate
    @recurring_todos = current_user.recurring_todos.active.includes(:tags, :taggings)
    @completed_recurring_todos = current_user.recurring_todos.completed.limit(10).includes(:tags, :taggings)

    @no_recurring_todos = @recurring_todos.count == 0
    @no_completed_recurring_todos = @completed_recurring_todos.count == 0
    @count = @recurring_todos.count

    @new_recurring_todo = RecurringTodo.new
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
  t('todos.recurring_todos') 
 @no_recurring_todos ? 'display:block' : 'display:none'
 t('todos.no_recurring_todos') 
 render :partial => @recurring_todos 
 link_to t('common.show_all'), done_recurring_todos_path
 t('common.last') 
 t('todos.completed_recurring') 
 @no_completed_recurring_todos ? 'display:block' : 'display:none'
 t('todos.no_completed_recurring') 
 render :partial => @completed_recurring_todos 
 image_tag("add.png", {:alt => "[ADD]"})
 t('todos.add_new_recurring') 
 t('todos.add_new_recurring') 
  form_for(@new_recurring_todo, :html=> { :id=>'recurring-todo-form-new-action', :name=>'recurring_todo', :class => 'inline-form' }) do 
 get_list_of_error_messages_for(@new_recurring_todo) 
 Todo.human_attribute_name('description') 

        text_field_tag( "recurring_todo[description]", "", "size" => 30, "maxlength" => 100) 
 Todo.human_attribute_name('notes') 

        text_area_tag( "recurring_todo[notes]", nil, {:cols => 29, :rows => 6}) 
 Todo.human_attribute_name('project') 
 Todo.human_attribute_name('context') 
 current_user.contexts.first.name unless current_user.contexts.first.nil?
 "#{Todo.human_attribute_name('tags')} #{t('shared.separate_tags_with_commas')}"
 text_field_tag "tag_list", nil, :size => 30 
 t('todos.recurrence_period') 
 radio_button_tag('recurring_todo[recurring_period]', 'daily', true)
 t('todos.recurrence.daily') 
 radio_button_tag('recurring_todo[recurring_period]', 'weekly', false)
 t('todos.recurrence.weekly') 
 radio_button_tag('recurring_todo[recurring_period]', 'monthly', false)
 t('todos.recurrence.monthly') 
 radio_button_tag('recurring_todo[recurring_period]', 'yearly', false)
 t('todos.recurrence.yearly') 
 t('todos.recurrence.starts_on') 

        text_field(:recurring_todo, :start_from, "value" => format_date(Date.current), "size" => 12, "class" => "Date", "autocomplete" => "off") 
 t('todos.recurrence.ends_on') 
 radio_button_tag('recurring_todo[ends_on]', 'no_end_date', true)
 t('todos.recurrence.no_end_date') 
 radio_button_tag('recurring_todo[ends_on]', 'ends_on_number_of_times', false)
 raw t('todos.recurrence.ends_on_number_times', :number => text_field( :recurring_todo, :number_of_occurrences, "size" => 3)) 
 radio_button_tag('recurring_todo[ends_on]', 'ends_on_end_date', false)
 raw t('todos.recurrence.ends_on_date', :date => text_field(:recurring_todo, :end_date, "size" => 12, "class" => "Date", "autocomplete" => "off", "value" => "")) 
 t('todos.recurrence.daily_options') 
 radio_button_tag('recurring_todo[daily_selector]', 'daily_every_x_day', true)
 raw t('todos.recurrence.daily_every_number_day', :number=> text_field_tag( 'recurring_todo[daily_every_x_days]', "1", {"size" => 3})) 
 radio_button_tag('recurring_todo[daily_selector]', 'daily_every_work_day', false)
 t('todos.recurrence.every_work_day') 
 t('todos.recurrence.weekly_options') 
 raw t('todos.recurrence.weekly_every_number_week', :number => text_field_tag('recurring_todo[weekly_every_x_week]', 1, {"size" => 3})) 
 week_day = Time.new.wday 
 check_box_tag('recurring_todo[weekly_return_monday]', 'm', week_day == 1 ? true : false) 
 t('date.day_names')[1] 
 check_box_tag('recurring_todo[weekly_return_tuesday]', 't', week_day == 2 ? true : false) 
 t('date.day_names')[2] 
 check_box_tag('recurring_todo[weekly_return_wednesday]', 'w', week_day == 3 ? true : false) 
 t('date.day_names')[3] 
 check_box_tag('recurring_todo[weekly_return_thursday]', 't', week_day == 4 ? true : false) 
 t('date.day_names')[4] 
 check_box_tag('recurring_todo[weekly_return_friday]', 'f', week_day == 5 ? true : false) 
 t('date.day_names')[5] 
 check_box_tag('recurring_todo[weekly_return_saturday]', 's', week_day == 6 ? true : false) 
 t('date.day_names')[6] 
 check_box_tag('recurring_todo[weekly_return_sunday]', 's', week_day == 0 ? true : false) 
 t('date.day_names')[0] 
 t('todos.recurrence.monthly_options') 
 radio_button_tag('recurring_todo[monthly_selector]', 'monthly_every_x_day', true)
 raw t('todos.recurrence.day_x_on_every_x_month',
            :day => text_field_tag('recurring_todo[monthly_every_x_day]', Time.zone.now.mday, {"size" => 3}),
            :month => text_field_tag('recurring_todo[monthly_every_x_month]', 1, {"size" => 3})) 
 radio_button_tag('recurring_todo[monthly_selector]', 'monthly_every_xth_day')
 raw t('todos.recurrence.monthly_every_xth_day',
            :day => select_tag('recurring_todo[monthly_every_xth_day]', options_for_select(@xth_day)),
            :day_of_week => select_tag('recurring_todo[monthly_day_of_week]' , options_for_select(@days_of_week, Time.zone.now.wday)),
            :month => text_field_tag('recurring_todo[monthly_every_x_month2]', 1, {"size" => 3})) 
 t('todos.recurrence.yearly_options') 
 radio_button_tag('recurring_todo[yearly_selector]', 'yearly_every_x_day', true)
 raw t('todos.recurrence.yearly_every_x_day',
      :month => select_tag('recurring_todo[yearly_month_of_year]', options_for_select(@months_of_year, Time.zone.now.month)),
            :day => text_field_tag('recurring_todo[yearly_every_x_day]', Time.zone.now.day, "size" => 3)) 
 radio_button_tag('recurring_todo[yearly_selector]', 'yearly_every_xth_day', false)
 raw t('todos.recurrence.yearly_every_xth_day',
            :day => select_tag('recurring_todo[yearly_every_xth_day]', options_for_select(@xth_day)),
            :day_of_week => select_tag('recurring_todo[yearly_day_of_week]', options_for_select(@days_of_week, Time.zone.now.wday)),
            :month => select_tag('recurring_todo[yearly_month_of_year2]', options_for_select(@months_of_year, Time.zone.now.month))) 
 t('todos.recurrence.recurrence_on.options') 
 radio_button_tag('recurring_todo[recurring_target]', 'due_date', true)
 t('todos.recurrence.recurrence_on.due_date') 
 t('todos.recurrence.recurrence_on.show_options') 
 radio_button_tag('recurring_todo[recurring_show_always]', '1', true)
 t('todos.recurrence.recurrence_on.show_always') 
 radio_button_tag('recurring_todo[recurring_show_always]', '0', false)
 raw t('todos.recurrence.recurrence_on.show_days_before', :days => text_field_tag( 'recurring_todo[recurring_show_days_before]', "0", {"size" => 3})) 
 radio_button_tag('recurring_todo[recurring_target]', 'show_from_date', false)
 t('todos.recurrence.recurrence_on.from_tickler') 
 end 
 
 t('todos.edit_recurring_todo') 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def new
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
   form_for(@new_recurring_todo, :html=> { :id=>'recurring-todo-form-new-action', :name=>'recurring_todo', :class => 'inline-form' }) do 
 get_list_of_error_messages_for(@new_recurring_todo) 
 Todo.human_attribute_name('description') 

        text_field_tag( "recurring_todo[description]", "", "size" => 30, "maxlength" => 100) 
 Todo.human_attribute_name('notes') 

        text_area_tag( "recurring_todo[notes]", nil, {:cols => 29, :rows => 6}) 
 Todo.human_attribute_name('project') 
 Todo.human_attribute_name('context') 
 current_user.contexts.first.name unless current_user.contexts.first.nil?
 "#{Todo.human_attribute_name('tags')} #{t('shared.separate_tags_with_commas')}"
 text_field_tag "tag_list", nil, :size => 30 
 t('todos.recurrence_period') 
 radio_button_tag('recurring_todo[recurring_period]', 'daily', true)
 t('todos.recurrence.daily') 
 radio_button_tag('recurring_todo[recurring_period]', 'weekly', false)
 t('todos.recurrence.weekly') 
 radio_button_tag('recurring_todo[recurring_period]', 'monthly', false)
 t('todos.recurrence.monthly') 
 radio_button_tag('recurring_todo[recurring_period]', 'yearly', false)
 t('todos.recurrence.yearly') 
 t('todos.recurrence.starts_on') 

        text_field(:recurring_todo, :start_from, "value" => format_date(Date.current), "size" => 12, "class" => "Date", "autocomplete" => "off") 
 t('todos.recurrence.ends_on') 
 radio_button_tag('recurring_todo[ends_on]', 'no_end_date', true)
 t('todos.recurrence.no_end_date') 
 radio_button_tag('recurring_todo[ends_on]', 'ends_on_number_of_times', false)
 raw t('todos.recurrence.ends_on_number_times', :number => text_field( :recurring_todo, :number_of_occurrences, "size" => 3)) 
 radio_button_tag('recurring_todo[ends_on]', 'ends_on_end_date', false)
 raw t('todos.recurrence.ends_on_date', :date => text_field(:recurring_todo, :end_date, "size" => 12, "class" => "Date", "autocomplete" => "off", "value" => "")) 
 t('todos.recurrence.daily_options') 
 radio_button_tag('recurring_todo[daily_selector]', 'daily_every_x_day', true)
 raw t('todos.recurrence.daily_every_number_day', :number=> text_field_tag( 'recurring_todo[daily_every_x_days]', "1", {"size" => 3})) 
 radio_button_tag('recurring_todo[daily_selector]', 'daily_every_work_day', false)
 t('todos.recurrence.every_work_day') 
 t('todos.recurrence.weekly_options') 
 raw t('todos.recurrence.weekly_every_number_week', :number => text_field_tag('recurring_todo[weekly_every_x_week]', 1, {"size" => 3})) 
 week_day = Time.new.wday 
 check_box_tag('recurring_todo[weekly_return_monday]', 'm', week_day == 1 ? true : false) 
 t('date.day_names')[1] 
 check_box_tag('recurring_todo[weekly_return_tuesday]', 't', week_day == 2 ? true : false) 
 t('date.day_names')[2] 
 check_box_tag('recurring_todo[weekly_return_wednesday]', 'w', week_day == 3 ? true : false) 
 t('date.day_names')[3] 
 check_box_tag('recurring_todo[weekly_return_thursday]', 't', week_day == 4 ? true : false) 
 t('date.day_names')[4] 
 check_box_tag('recurring_todo[weekly_return_friday]', 'f', week_day == 5 ? true : false) 
 t('date.day_names')[5] 
 check_box_tag('recurring_todo[weekly_return_saturday]', 's', week_day == 6 ? true : false) 
 t('date.day_names')[6] 
 check_box_tag('recurring_todo[weekly_return_sunday]', 's', week_day == 0 ? true : false) 
 t('date.day_names')[0] 
 t('todos.recurrence.monthly_options') 
 radio_button_tag('recurring_todo[monthly_selector]', 'monthly_every_x_day', true)
 raw t('todos.recurrence.day_x_on_every_x_month',
            :day => text_field_tag('recurring_todo[monthly_every_x_day]', Time.zone.now.mday, {"size" => 3}),
            :month => text_field_tag('recurring_todo[monthly_every_x_month]', 1, {"size" => 3})) 
 radio_button_tag('recurring_todo[monthly_selector]', 'monthly_every_xth_day')
 raw t('todos.recurrence.monthly_every_xth_day',
            :day => select_tag('recurring_todo[monthly_every_xth_day]', options_for_select(@xth_day)),
            :day_of_week => select_tag('recurring_todo[monthly_day_of_week]' , options_for_select(@days_of_week, Time.zone.now.wday)),
            :month => text_field_tag('recurring_todo[monthly_every_x_month2]', 1, {"size" => 3})) 
 t('todos.recurrence.yearly_options') 
 radio_button_tag('recurring_todo[yearly_selector]', 'yearly_every_x_day', true)
 raw t('todos.recurrence.yearly_every_x_day',
      :month => select_tag('recurring_todo[yearly_month_of_year]', options_for_select(@months_of_year, Time.zone.now.month)),
            :day => text_field_tag('recurring_todo[yearly_every_x_day]', Time.zone.now.day, "size" => 3)) 
 radio_button_tag('recurring_todo[yearly_selector]', 'yearly_every_xth_day', false)
 raw t('todos.recurrence.yearly_every_xth_day',
            :day => select_tag('recurring_todo[yearly_every_xth_day]', options_for_select(@xth_day)),
            :day_of_week => select_tag('recurring_todo[yearly_day_of_week]', options_for_select(@days_of_week, Time.zone.now.wday)),
            :month => select_tag('recurring_todo[yearly_month_of_year2]', options_for_select(@months_of_year, Time.zone.now.month))) 
 t('todos.recurrence.recurrence_on.options') 
 radio_button_tag('recurring_todo[recurring_target]', 'due_date', true)
 t('todos.recurrence.recurrence_on.due_date') 
 t('todos.recurrence.recurrence_on.show_options') 
 radio_button_tag('recurring_todo[recurring_show_always]', '1', true)
 t('todos.recurrence.recurrence_on.show_always') 
 radio_button_tag('recurring_todo[recurring_show_always]', '0', false)
 raw t('todos.recurrence.recurrence_on.show_days_before', :days => text_field_tag( 'recurring_todo[recurring_show_days_before]', "0", {"size" => 3})) 
 radio_button_tag('recurring_todo[recurring_target]', 'show_from_date', false)
 t('todos.recurrence.recurrence_on.from_tickler') 
 end 
 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def show
  end

  def done
    @source_view = params['_source_view'] || 'recurring_todo'
    @page_title = t('todos.completed_recurring_actions_title')

    items_per_page = 20
    page = params[:page] || 1
    @completed_recurring_todos = current_user.recurring_todos.completed.paginate :page => page, :per_page => items_per_page
    @total = @count = current_user.recurring_todos.completed.count

    @range_low = (page.to_i-1) * items_per_page + 1
    @range_high = @range_low + @completed_recurring_todos.size - 1

    @range_low = 0 if @total == 0
    @range_high = @total if @range_high > @total
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

 will_paginate @completed_recurring_todos, paginate_options 
 "#{@total} (#{@range_low}-#{@range_high})" 
 t('todos.completed_recurring') 
 @no_completed_recurring_todos ? 'display:block' : 'display:none'
 t('todos.no_completed_recurring') 
 render :partial => @completed_recurring_todos 
 will_paginate @completed_recurring_todos, paginate_options 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def edit
    @form_helper = RecurringTodos::FormHelper.new(@recurring_todo)

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
  object_name = unique_object_name_for("edit_rec_todo_#{@recurring_todo.id}") 
object_name
object_name
 js_render('edit_form') 
object_name
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def update
    updater = RecurringTodos::RecurringTodosBuilder.new(current_user, update_recurring_todo_params)
    @saved = updater.update(@recurring_todo)

    @recurring_todo.reload

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
  if @saved 
 else 
 end 
dom_id(@recurring_todo)

    # first add the updated recurring todo after the old one, then remove old one
    # using html() does not work, because it will replace the _content_ of
    # the container instead of the container itself, i.e. you will get
    # a container within a container which will break drag-and-drop sorting (when/if implemented)

dom_id(@recurring_todo)
dom_id(@recurring_todo)
dom_id(@recurring_todo)
 js_render(@recurring_todo)

  status_message = t('todos.recurring_action_saved')
  status_message = t('todos.added_new_project') + ' / ' + status_message if @new_project_created
  status_message = t('todos.added_new_context') + ' / ' + status_message if @new_context_created
  
 status_message
 js_error_messages_for(@recurring_todo) 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def create
    builder = RecurringTodos::RecurringTodosBuilder.new(current_user, all_recurring_todo_params)
    @saved = builder.save

    if @saved
      @recurring_todo = builder.saved_recurring_todo
      todo_saved = TodoFromRecurringTodo.new(current_user, @recurring_todo).create.nil? == false

      @status_message =
        t('todos.recurring_action_saved') + " / " +
        t("todos.new_related_todo_#{todo_saved ? "" : "not_"}created_short")

      @down_count = current_user.recurring_todos.active.count
      @new_recurring_todo = RecurringTodo.new
    else
      @recurring_todo = builder.recurring_todo
      @status_message = t('todos.error_saving_recurring')
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
  if @saved 
@status_message
 @down_count 
 else 
 end 
 dom_id(@recurring_todo)
 @saved ? js_render(@recurring_todo) : "" 
 @saved ? js_render('recurring_todo_form') : "" 
 js_error_messages_for(@recurring_todo) 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def destroy
    @number_of_todos = @recurring_todo.todos.count

    # remove all references to this recurring todo
    @recurring_todo.clear_todos_association

    # delete the recurring todo
    @saved = @recurring_todo.destroy

    # count remaining recurring todos
    @active_remaining = current_user.recurring_todos.active.count
    @completed_remaining = current_user.recurring_todos.completed.count

    respond_to do |format|

      format.html do
        if @saved
          notify :notice, t('todos.recurring_deleted_success')
        else
          notify :error,  t('todos.error_deleting_recurring', :description => @recurring_todo.description)
        end
        redirect_to :action => 'index'
      end

      format.js do
        render
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
  escape_javascript(t('todos.recurring_deleted_success') + t('todos.recurring_pattern_removed', :count => pluralize(@number_of_todos,t('common.todo')))) 
 else 
 t('todos.error_deleting_recurring', :description => @recurring_todo.description) 
 end 
 if @active_remaining == 0 
 end 
 if @completed_remaining == 0 
 end 
dom_id(@recurring_todo)
dom_id(@recurring_todo)
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def toggle_check
    @saved = @recurring_todo.toggle_completion!

    @down_count = current_user.recurring_todos.active.count
    @active_remaining = @down_count
    @completed_remaining = 0

    if @recurring_todo.active?
      @completed_remaining = current_user.recurring_todos.completed.count

      # from completed back to active -> check if there is an active todo
      @active_todos = @recurring_todo.todos.active.count
      # create todo if there is no active todo belonging to the activated
      # recurring_todo
      @new_recurring_todo = TodoFromRecurringTodo.new(current_user, @recurring_todo).create if @active_todos == 0
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
  unless @saved 
  t('todos.error_completing_todo', :description => @recurring_todo.description) 
 else
  object_name = unique_object_name_for("toggle_check_rec")

object_name
 @down_count 
object_name
 "#{object_name}.inform_if_new_todo_created();" if @new_recurring_todo 
  t('todos.new_related_todo_created') 
dom_id(@recurring_todo)
dom_id(@recurring_todo)
object_name
 if @recurring_todo.completed? 
object_name
 else 
object_name
 end 
object_name
 dom_id(@recurring_todo)
object_name
 dom_id(@recurring_todo)
 if @active_remaining == 0 
 end 
 if @completed_remaining == 0 
 end 
 @saved ? js_render(@recurring_todo) : "" 
object_name
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def toggle_star
    @recurring_todo.toggle_star!
    @saved = @recurring_todo.save!
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
  if @saved 
 @recurring_todo.id 
 else 
 t('todos.error_starring_recurring', :description => @recurring_todo.description) 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  private

  def recurring_todo_params
    params.require(:recurring_todo).permit(
      # model attributes
      :context_id, :project_id, :description, :notes, :state, :start_from,
      :ends_on, :end_date, :number_of_occurrences, :occurrences_count, :target,
      :show_from_delta, :recurring_period, :recurrence_selector, :every_other1,
      :every_other2, :every_other3, :every_day, :only_work_days, :every_count,
      :weekday, :show_always, :context_name, :project_name, :tag_list,
      # form attributes
      :recurring_period, :daily_selector, :monthly_selector, :yearly_selector,
      :recurring_target, :daily_every_x_days, :monthly_day_of_week,
      :monthly_every_x_day, :monthly_every_x_month2, :monthly_every_x_month,
      :monthly_every_xth_day, :recurring_show_days_before,
      :recurring_show_always, :weekly_every_x_week, :weekly_return_monday,
      :yearly_day_of_week, :yearly_every_x_day, :yearly_every_xth_day,
      :yearly_month_of_year2, :yearly_month_of_year,
      # derived attributes
      :weekly_return_monday, :weekly_return_tuesday, :weekly_return_wednesday,
      :weekly_return_thursday, :weekly_return_friday, :weekly_return_saturday, :weekly_return_sunday
      )
  end

  def all_recurring_todo_params
    # move context_name, project_name and tag_list into :recurring_todo hash for easier processing
    {
      context_name: :context_name,
      project_name: :project_name,
      tag_list:     :tag_list
    }.each do |target,source|
      move_into_recurring_todo_param(params, target, source)
    end
    recurring_todo_params
  end

  def update_recurring_todo_params
    # we needed to rename the recurring_period selector in the edit form because
    # the form for a new recurring todo and the edit form are on the same page.
    # Same goes for start_from and end_date
    params['recurring_todo']['recurring_period'] = params['recurring_edit_todo']['recurring_period']

    {
      context_name: :context_name,
      project_name: :project_name,
      tag_list:     :edit_recurring_todo_tag_list,
      end_date:     :recurring_todo_edit_end_date,
      start_from:   :recurring_todo_edit_start_from
    }.each do |target,source|
      move_into_recurring_todo_param(params, target, source)
    end

    # make sure that we set weekly_return_xxx to empty (space) when they are
    # not checked (and thus not present in params["recurring_todo"])
    %w{monday tuesday wednesday thursday friday saturday sunday}.each do |day|
      params["recurring_todo"]["weekly_return_#{day}"]=' ' if params["recurring_todo"]["weekly_return_#{day}"].nil?
    end

    recurring_todo_params
  end

  def move_into_recurring_todo_param(params, target, source)
    params[:recurring_todo][target] = params[source] unless params[source].blank?
  end

  def init
    @days_of_week   = (0..6).map{|i| [t('date.day_names')[i], i] }
    @months_of_year = (1..12).map{|i| [t('date.month_names')[i], i] }
    @xth_day = [[t('common.first'),1],[t('common.second'),2],[t('common.third'),3],[t('common.fourth'),4],[t('common.last'),5]]
    @projects = current_user.projects.includes(:default_context)
    @contexts = current_user.contexts
  end

  def get_recurring_todo_from_param
    @recurring_todo = current_user.recurring_todos.find(params[:id])
  end

  def find_and_inactivate
    # find active recurring todos without active todos and inactivate them

    current_user.recurring_todos.active.
      select("recurring_todos.id, recurring_todos.state").
      joins("LEFT JOIN todos fai_todos ON (recurring_todos.id = fai_todos.recurring_todo_id) AND (NOT fai_todos.state='completed')").
      where("fai_todos.id IS NULL").
      each { |rt| current_user.recurring_todos.find(rt.id).toggle_completion! }
  end

end
