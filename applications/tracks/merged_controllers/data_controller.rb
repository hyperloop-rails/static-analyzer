class DataController < ApplicationController

  require 'csv'

  def index
    @page_title = "TRACKS::Export"
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
  link_to "YAML file", data_yaml_export_path 
 link_to "CSV file (actions, contexts and projects)", data_csv_actions_path 
 link_to "CSV file (notes only)", data_csv_notes_path 
 link_to "XML file (actions only)", data_xml_export_path 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def import

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
  form_tag csv_map_data_path, :id => 'upload_form', multipart: true do 
 select_tag(:import_to, options_for_select([['Projects', 'projects'], ['Todos', 'todos']], 1) ) 
 file_field_tag :file 
 submit_tag "Upload", :id => "upload_form_submit" 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def csv_map
    if params[:file].blank?
      flash[:notice] = "File can't be blank"
      redirect_to :back
    else
      @import_to = params[:import_to]

      begin
        #get column headers and format as [['name', column_number]...]
        i = -1
        @headers = import_headers(params[:file].path).collect { |v| [v, i+=1] }
        @headers.unshift ['',i]
      rescue Exception => e
        flash[:error] = "Invalid CVS: could not read headers: #{e}"
        redirect_to :back
        return
      end

      #save file for later
      begin
        uploaded_file = params[:file]
        @filename = Tracks::Utils.sanitize_filename(uploaded_file.original_filename)
        path_and_file = Rails.root.join('public', 'uploads', 'csv', @filename)
        File.open(path_and_file, "wb") { |f| f.write(uploaded_file.read) }
      rescue Exception => e
        flash[:error] = "Could not save uploaded CSV (#{path_and_file}). Can Tracks write to the upload directory? #{e}"
        redirect_to :back
        return
      end

      case @import_to
      when 'projects'
        @labels = [:name, :description]
      when 'todos'
        @labels = [:description, :context, :project, :notes, :created_at, :due, :completed_at]
      else
        flash[:error] = "Invalid import destination"
        redirect_to :back
      end
      respond_to do |format|
        format.html
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
  form_tag csv_import_data_path do 
 @labels.each do |l| 
 label_tag l 
 select_tag(l, options_for_select(@headers) ) 
 end 
 hidden_field_tag :file, @filename 
 hidden_field_tag :import_to, @import_to 
 submit_tag "Import" 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  def csv_import
    begin
      filename = Tracks::Utils.sanitize_filename(params[:file])
      path_and_file = Rails.root.join('public', 'uploads', 'csv', filename)
      case params[:import_to]
      when 'projects'
        count = Project.import path_and_file, params, current_user
        flash[:notice] = "#{count} Projects imported"
      when 'todos'
        count = Todo.import path_and_file, params, current_user
        flash[:notice] = "#{count} Todos imported"
      else
        flash[:error] = t('data.invalid_import_destination')
      end
    rescue Exception => e
      flash[:error] = t('data.invalid_import_destination') + ": #{e}"
    end
    File.delete(path_and_file)
    redirect_to import_data_path
  end

  def import_headers(file)
    CSV.foreach(file, headers: false) do |row|
      return row
    end
  end

  def export
    # Show list of formats for export
  end

  # Thanks to a tip by Gleb Arshinov
  # <http://lists.rubyonrails.org/pipermail/rails/2004-November/000199.html>
  def yaml_export
    all_tables = {}

    all_tables['todos'] = current_user.todos.includes(:tags).load
    all_tables['contexts'] = current_user.contexts.load
    all_tables['projects'] = current_user.projects.load

    todo_tag_ids = Tag.find_by_sql(
        "SELECT DISTINCT tags.id "+
          "FROM tags, taggings, todos "+
          "WHERE todos.user_id=? "+
          "AND tags.id = taggings.tag_id " +
          "AND taggings.taggable_id = todos.id ", current_user.id)
    rec_todo_tag_ids = Tag.find_by_sql(
        "SELECT DISTINCT tags.id "+
          "FROM tags, taggings, recurring_todos "+
          "WHERE recurring_todos.user_id=? "+
          "AND tags.id = taggings.tag_id " +
          "AND taggings.taggable_id = recurring_todos.id ", current_user.id)
    tags = Tag.where("id IN (?) OR id IN (?)", todo_tag_ids, rec_todo_tag_ids)
    taggings = Tagging.where("tag_id IN (?) OR tag_id IN(?)", todo_tag_ids, rec_todo_tag_ids)

    all_tables['tags'] = tags.load
    all_tables['taggings'] = taggings.load
    all_tables['notes'] = current_user.notes.load
    all_tables['recurring_todos'] = current_user.recurring_todos.load

    result = all_tables.to_yaml
    result.gsub!(/\n/, "\r\n")   # TODO: general functionality for line endings
    send_data(result, :filename => "tracks_backup.yml", :type => 'text/plain')
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
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  # export all actions as csv
  def csv_actions
    content_type = 'text/csv'
    CSV.generate(result = "") do |csv|
      csv << ["id", "Context", "Project", "Description", "Notes", "Tags",
        "Created at", "Due", "Completed at", "User ID", "Show from",
        "state"]
      current_user.todos.includes(:context, :project, :taggings, :tags).each do |todo|
        csv << [todo.id, todo.context.name,
          todo.project_id.nil? ? "" : todo.project.name,
          todo.description,
          todo.notes, todo.tags.collect{|t| t.name}.join(', '),
          todo.created_at.to_formatted_s(:db),
          todo.due? ? todo.due.to_formatted_s(:db) : "",
          todo.completed_at? ? todo.completed_at.to_formatted_s(:db) : "",
          todo.user_id,
          todo.show_from? ? todo.show_from.to_formatted_s(:db) : "",
          todo.state]
      end
    end
    send_data(result, :filename => "todos.csv", :type => content_type)
  end

  # export all notes as csv
  def csv_notes
    content_type = 'text/csv'
    CSV.generate(result = "") do |csv|
      csv << ["id", "User ID", "Project", "Note",
        "Created at", "Updated at"]
      # had to remove project include because it's association order is leaking
      # through and causing an ambiguous column ref even with_exclusive_scope
      # didn't seem to help -JamesKebinger
      current_user.notes.reorder("notes.created_at").each do |note|
        # Format dates in ISO format for easy sorting in spreadsheet Print
        # context and project names for easy viewing
        csv << [note.id, note.user_id,
          note.project_id = note.project_id.nil? ? "" : note.project.name,
          note.body, note.created_at.to_formatted_s(:db),
          note.updated_at.to_formatted_s(:db)]
      end
    end
    send_data(result, :filename => "notes.csv", :type => content_type)
  end

  def xml_export
    todo_tag_ids = Tag.find_by_sql(
        "SELECT DISTINCT tags.id "+
          "FROM tags, taggings, todos "+
          "WHERE todos.user_id=? "+
          "AND tags.id = taggings.tag_id " +
          "AND taggings.taggable_id = todos.id ", current_user.id)
    rec_todo_tag_ids = Tag.find_by_sql(
        "SELECT DISTINCT tags.id "+
          "FROM tags, taggings, recurring_todos "+
          "WHERE recurring_todos.user_id=? "+
          "AND tags.id = taggings.tag_id " +
          "AND taggings.taggable_id = recurring_todos.id ", current_user.id)
    tags = Tag.where("id IN (?) OR id IN (?)", todo_tag_ids, rec_todo_tag_ids)
    taggings = Tagging.where("tag_id IN (?) OR tag_id IN(?)", todo_tag_ids, rec_todo_tag_ids)

    result = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><tracks_data>"
    result << current_user.todos.to_xml(:skip_instruct => true)
    result << current_user.contexts.to_xml(:skip_instruct => true)
    result << current_user.projects.to_xml(:skip_instruct => true)
    result << tags.to_xml(:skip_instruct => true)
    result << taggings.to_xml(:skip_instruct => true)
    result << current_user.notes.to_xml(:skip_instruct => true)
    result << current_user.recurring_todos.to_xml(:skip_instruct => true)
    result << "</tracks_data>"
    send_data(result, :filename => "tracks_data.xml", :type => 'text/xml')
  end

  def yaml_form
    # Draw the form to input the YAML text data
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
  form_for :import, @import, :url => {:controller => 'data', :action => 'yaml_import'} do |f| 
 f.text_area :yaml 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

  # adjusts time to utc
  def adjust_time(timestring)
    if (timestring=='') or ( timestring == nil)
      return nil
    else
      return Time.parse(timestring + 'UTC')
    end
  end

  def yaml_import
    raise "YAML loading is disabled"
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
  if !(@errmessage == '') 
 t('data.import_errors') 
 @errmessage 
 else 
 t('data.import_successful') 
 end 
  TRACKS_VERSION 
 (link_to(t('layouts.mobile_navigation.full'),  todos_path(:format => 'html'))) 
 

end

  end

end
