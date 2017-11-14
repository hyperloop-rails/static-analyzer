# encoding: UTF-8
# Provide a RSS feed of Project WorkLog activities.

require "rss/maker"
require "icalendar"
require "google_chart"

class FeedsController < ApplicationController
  include Icalendar
  include TaskFilterHelper

  def get_action(log)
    if log.task && log.task_id > 0
      action = "Completed" if log.event_log.event_type == EventLog::TASK_COMPLETED
      action = "Reverted"  if log.event_log.event_type == EventLog::TASK_REVERTED
      action = "Created"   if log.event_log.event_type == EventLog::TASK_CREATED
      action = "Modified"  if log.event_log.event_type == EventLog::TASK_MODIFIED
      action = "Commented" if log.event_log.event_type == EventLog::TASK_COMMENT
      action = "Worked"    if log.event_log.event_type == EventLog::TASK_WORK_ADDED
      action = "Archived"  if log.event_log.event_type == EventLog::TASK_ARCHIVED
      action = "Restored"  if log.event_log.event_type == EventLog::TASK_RESTORED
    else
      action = "Note created"  if log.event_log.event_type == EventLog::PAGE_CREATED
      action = "Note deleted"  if log.event_log.event_type == EventLog::PAGE_DELETED
      action = "Note modified" if log.event_log.event_type == EventLog::PAGE_MODIFIED
      action = "Deleted"       if log.event_log.event_type == EventLog::TASK_DELETED
      action = "Commit"        if log.event_log.event_type == EventLog::SCM_COMMIT
    end
    action
  end

  # Get the RSS feed, based on the secret key passed on the url
  def rss
    return if params[:id].blank?

    headers["Content-Type"] = "application/rss+xml"

    # Lookup user based on the secret key
    user = User.where("uuid = ?", params[:id]).first

    if user.nil?
      render :nothing => true, :layout => false
      return
    end

    content = nil
    if params[:widget].blank?
      # Find all Project ids this user has access to
      pids = user.projects

      # Find 50 last WorkLogs of the Projects
      unless pids.nil? || pids.empty?
        pids = pids.collect{|p|p.id}
        @activities = WorkLog.accessed_by(user).order("work_logs.started_at DESC").limit(50).includes(:customer, :task)
      else
        @activities = []
      end

      # Create the RSS
      content = RSS::Maker.make("2.0") do |m|
        m.channel.title = "#{user.company.name} Activities"
        m.channel.link = "#{user.company.site_URL}/activities"
        m.channel.description = "Last changes for #{user.name}@#{user.company.name}."
        m.items.do_sort = true # sort items by date

        @activities.each do |log|
          action = get_action(log)

          i = m.items.new_item
          i.title = " #{action}: #{log.task.issue_name}" unless log.task.nil?
          i.title ||= "#{action}"
          i.link = "#{user.company.site_URL}/tasks/view/#{log.task.task_num}" unless log.task.nil?
          i.description = log.body unless log.body.blank?
          i.date = log.started_at.utc
          i.author = log.user.name unless log.user.nil?
          action = nil
        end
      end
      @activities = nil
    else
      widget = user.widgets.find(params[:widget]) rescue nil

      if widget
        filter = ''
        if widget.filter_by?
          filter = widget.from_filter_by
        end
        pids = user.projects.collect{|p| p.id}

        unless widget.mine?
          tasks = TaskRecord.accessed_by(user).where("tasks.completed_at IS NULL #{filter} AND (tasks.hide_until IS NULL OR tasks.hide_until < ?)", user.tz.now.utc.to_s(:db))
        else
          tasks = user.tasks.where("tasks.project_id IN (?) #{filter} AND tasks.completed_at IS NULL AND (tasks.hide_until IS NULL OR tasks.hide_until < ?)", pids, user.tz.now.utc.to_s(:db))
        end

        tasks = case widget.order_by
               when 'priority' then
                    user.company.sort(tasks)[0, widget.number]
               when 'date' then
                   tasks.sort_by {|t| t.created_at.to_i }[0, widget.number]
              end

        # Create the RSS
        content = RSS::Maker.make("2.0") do |m|
          m.channel.title = widget.name
          m.channel.link = "#{user.company.site_URL}/tasks"
          m.channel.description = widget.name
          m.items.do_sort = true # sort items by date
          tasks.each do |task|
            i = m.items.new_item
            i.title = "#{task.issue_name}"
            i.link = "#{user.company.site_URL}/tasks/view/#{task.task_num}"
            i.description = task.description unless task.description.blank?
            i.date = task.created_at.utc
            i.author = task.creator.name unless task.creator.nil?
          end
        end
      else
        content = '<?xml version="1.0" encoding="UTF-8"?>
        <rss version="2.0"
          xmlns:content="http://purl.org/rss/1.0/modules/content/"
          xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
          xmlns:dc="http://purl.org/dc/elements/1.1/"
          xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/">
          <channel>
            <title>No such widget</title>
            <link>#{user.company.site_URL}</link>
            <description>No such widget.</description>
          </channel>
        </rss>'
      end
    end
    # Render it inline
    render :text => content.to_s
    content = nil
    user = nil
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :content do 
 yield(:side_panel) 
  t("task_filters.filters") 
 t("task_filters.save_current") 
 filters_user_path(current_user) 
 t("task_filters.manage") 
 TaskFilter.recent_for(current_user).each do |filter| 
 select_task_filter_link(filter) 
 end 
 link_to_open_tasks 
 link_to_open_tasks(current_user) 
 link_to_unread_tasks(current_user) 
 current_user.visible_task_filters.each do |tf| 
 select_task_filter_link(tf) 
 end 
 
  cache(grouped_cache_key "tags/company_#{current_user.company_id}/", current_user.id) do 
 t("tags.tags") 
 if current_user.admin? 
 t("button.edit") 
 end 
 tag_links 
 end 
 
  current_user.id 
 current_user.id 
 t("tasks.next_tasks") 
 count = 5 if ( count.nil? || count < 5) 
 current_user.schedule_tasks(:limit => count, :save => false) do |task| 
  pill_date ||= task.estimate_date 
 time ||= :minutes_left 
 sorting_disabled ||= false 
 user.top_next_task == task ? 'top-next-task' : nil 
 human_future_date(pill_date, user.tz) 
 task.css_classes 
 link_to "<b>##{task.task_num}</b>".html_safe, task_view_path(task.task_num), 'data-taskid' => task.id, "data-content" => task_detail(task, user) 
 task.name 
 case time 
 when :minutes_left 
 "(" + TimeParser.format_duration(task.minutes_left) + ")" 
 when :worked_minutes 
 "(" + TimeParser.format_duration(task.worked_minutes, true) + ")" 
 end 
 unless sorting_disabled 
 link_to "<i class=\"icon-move\"></i>".html_safe, "#", :title => t("tasks.reorder_task"), :class => "pull-right" 
 end 
 
 end 
 if current_user.tasks.open_only.not_snoozed.count > count 
 t("tasks.more_tasks") 
 end 
 
 end 
  javascript_include_tag 'application' 
 yield :head 
 stylesheet_link_tag 'application' 
 auto_discovery_link_tag(:rss, {:controller => 'feeds', :action => 'rss', :id => current_user.uuid }) 
 csrf_meta_tag 
 @page_title || Setting.productName 
 if Setting.version 
 Setting.version 
 end 
 new_user_session_url 
  image_tag('spinner.gif', :border => 0) 
 
  if current_user.company.logo? 
 image_tag("/companies/show_logo/#{current_user.company.id}", :alt => "logo" ) 
 else 
 image_tag("logo.gif", :alt => "logo" ) 
 end 
 if total_today > 0 
 t("shared.worked_today", time: distance_of_time_in_words(total_today.minutes)) 
 end 
 if @current_sheet && @current_sheet.task 
  start_stop_work_link(@current_sheet.task) 
 cancel_work_link(@current_sheet.task) 
 pause_task_link(@current_sheet.task) 
 link_to(@current_sheet.task.issue_name + " - " + @current_sheet.task.project.name, edit_task_path(@current_sheet.task.task_num)) 
 percent = ((@current_sheet.task.worked_minutes + @current_sheet.duration / 60) / @current_sheet.task.duration.to_f  * 100).round unless (@current_sheet.task.duration.nil? or @current_sheet.task.duration == 0) 
 TimeParser.format_duration(@current_sheet.duration/60) 
 TimeParser.format_duration(@current_sheet.task.worked_minutes + @current_sheet.duration / 60) 
 percent.nil? ? 0 : percent 
 
 end 
 
  t('tabmenu.overview') 
 link_to t('tabmenu.dashboard'), :controller => 'activities', :action => 'index' 
 if current_user.admin? 
 link_to t('tabmenu.planning'), planning_tasks_path 
 end 
 if current_user.can_any?(current_user.projects, 'report') 
 billing_title = current_user.can_use_billing? ? 'billing' : 'reports'  
 link_to t("tabmenu.#{billing_title}"), :controller => 'billing', :action => 'index' 
 end 
 link_to t('tabmenu.history'), :controller => 'timeline', :action => 'index' 
 t('tabmenu.create') 
 link_to t('tabmenu.task'), :controller => 'tasks', :action => 'new' 
 if current_templates.size > 0 
 t('tabmenu.from_template') 
 current_templates.order("tasks.position_task_template").each do |task| 
 link_to task, clone_task_path(task.task_num) 
 end 
 end 
 if current_user.create_projects? 
 link_to t('tabmenu.project'), :controller => 'projects', :action => 'new' 
 end 
 link_to t('tabmenu.milestone'), new_milestone_path 
 if Setting.contact_creation_allowed && current_user.can_view_clients? 
 link_to t('tabmenu.person'), :controller => 'users', :action => 'new' 
 link_to t('tabmenu.company'), :controller => 'customers', :action => 'new' 
 end 
 if current_user.use_resources? 
 link_to(t('tabmenu.resource'), new_resource_path) 
 end 
 if menu_class("activities") == "active" 
 link_to t('tabmenu.add_new_widget'), '#', :id => "add-widget-menu-link" 
 end 
 menu_class("tasks") 
 link_to t('tabmenu.tasks'), :controller => 'tasks', :action => 'index' 
 menu_class("milestones") 
 link_to t('tabmenu.milestones'), milestones_path 
 if current_user.company.show_wiki? 
 menu_class("wiki") 
 link_to t('tabmenu.wiki'), :controller => 'wiki', :action => 'show', :id => nil 
 end 
 link_to t('tabmenu.projects'), :controller => 'projects', :action => 'index' 
  text_field_tag("keyword", "", :class => "search_filter input-xlarge", :placeholder => t('tabmenu.search'), :id => "menubar_search", :autocomplete => "off") 
 
 current_user.display_login 
 if current_user.admin? 
 link_to  t('tabmenu.my_account'), edit_user_path(current_user) 
 link_to t('tabmenu.company_settings'), :controller => 'companies', :action => 'edit', :id => current_user.company_id 
 else 
 link_to t('tabmenu.my_account'), edit_user_path(current_user) 
 end 
 link_to t('tabmenu.log_out'), destroy_user_session_path 
 
   flash.each do |key, val| 
key.to_s
 val 
 end 
 
 news = NewsItem.order("id desc").where("id > ?", current_user.seen_news_id).first
unless news.nil? 
 tz.utc_to_local(news.created_at).strftime("#{current_user.time_format} #{current_user.date_format}") 
 news.body 
 link_to( "[#{t("button.hide")}]", { :controller => 'users', :action => 'update_seen_news', :id => news.id}, :class => "right",
        :onclick => "jQuery('#news').fadeOut(500)",
        :remote => true) 
 end 
 
 content_for?(:content) ? yield(:content) : yield 
 current_user.id 
 current_user.dateFormat 
 

end

  end

  def to_localtime(tz, time)
    DateTime.parse(tz.utc_to_local(time).to_s)
  end

  def to_duration(dur)
    TimeParser.format_duration(dur).upcase
  end

  def ical_all
    ical(:all)
  end

  def ical(mode = :personal)

    if params[:id].nil? || params[:id].empty?
      render :nothing => true
      return
    end

    I18n.locale = :en

    headers["Content-Type"] = "text/calendar"

    # Lookup user based on the secret key
    user = User.where("uuid = ?", params[:id]).first

    if user.nil?
      render :nothing => true, :layout => false
      return
    end

    tz = TZInfo::Timezone.get(user.time_zone)

    cached = []

    # Find all Project ids this user has access to
    pids = user.projects



    # Find 50 last WorkLogs of the Projects
    unless pids.nil? || pids.empty?
      pids = pids.collect{|p|p.id}
      if mode == :all

        if params['mode'].nil? || params['mode'] == 'logs'
          logger.info("selecting logs")
          @activities = WorkLog.accessed_by(user).where("work_logs.task_id > 0 AND work_logs.duration > 0").includes({ :task => :users, :task => :tags }, :ical_entry)
        end

        if params['mode'].nil? || params['mode'] == 'tasks'
          logger.info("selecting tasks")
          @tasks = TaskRecord.accessed_by(user).includes(:milestone, :tags, :task_users, :ical_entry)
        end

      else

        if params['mode'].nil? || params['mode'] == 'logs'
          logger.info("selecting personal logs")
          @activities = WorkLog.accessed_by(user).where("work_logs.user_id = ? AND work_logs.task_id > 0 AND work_logs.duration > 0", user.id).includes({:task => :tags }, :ical_entry)
        end

        if params['mode'].nil? || params['mode'] == 'tasks'
          logger.info("selecting personal tasks")
          @tasks = user.tasks.where("tasks.project_id IN (?)", pids).includes(:milestone, :tags, :task_users, :users, :ical_entry)
        end
      end

      if params['mode'].nil? || params['mode'] == 'milestones'
        logger.info("selecting milestones")
        @milestones = Milestone.where("company_id = ? AND project_id IN (?) AND due_at IS NOT NULL", user.company_id, pids)
      end

    end

    @activities ||= []
    @tasks ||= []
    @milestones ||= []

    cal = Calendar.new

    @milestones.each do |m|
      event = cal.event

      if m.completed_at
        event.start = to_localtime(tz, m.completed_at).beginning_of_day + 8.hours
      else
        event.start = to_localtime(tz, m.due_at).beginning_of_day + 8.hours
      end
      event.duration = "PT#{480}M"
      event.uid =  "m#{m.id}_#{event.created}@#{user.company.subdomain}.#{Setting.domain}"
      event.organizer = "MAILTO:#{m.user.nil? ? user.email : m.user.email}"
      event.url = user.company.site_URL + path_to_tasks_filtered_by(m)
      event.summary = "Milestone: #{m.name}"

      if m.description
        description = m.description.gsub(/<[^>]*>/,'')
        description.gsub!(/\r/, '') if description
        event.description = description if description && description.length > 0
      end
    end


    @tasks.each do |t|

      if t.ical_entry
        cached << [t.ical_entry.body]
        next
      end

      todo = cal.todo

      unless t.completed_at
        if t.due_at
          todo.start = to_localtime(tz, t.due_at - 12.hours)
        elsif t.milestone && t.milestone.due_at
          todo.start = to_localtime(tz, t.milestone.due_at - 12.hours)
        else
          todo.start = to_localtime(tz, t.created_at)
        end
      else
        todo.start = to_localtime(tz, t.completed_at)
      end

      todo.created = to_localtime(tz, t.created_at)
      todo.uid =  "t#{t.id}_#{todo.created}@#{user.company.subdomain}.#{Setting.domain}"
      todo.organizer = "MAILTO:#{t.users.first.email}" if t.users.size > 0
      todo.url = "#{user.company.site_URL}/tasks/view/#{t.task_num}"
      todo.summary = "#{t.issue_name}"

      description = t.description.gsub(/<[^>]*>/,'').gsub(/[\r]/, '') if t.description

      todo.description = description if description && description.length > 0
      todo.categories = t.tags.collect{ |tag| tag.name.upcase } if(t.tags.size > 0)
      todo.percent = 100 if t.done?

      event = cal.event
      event.start = todo.start
      event.duration = "PT1M"
      event.created = todo.created
      event.uid =  "te#{t.id}_#{todo.created}@#{user.company.subdomain}.#{Setting.domain}"
      event.organizer = todo.organizer
      event.url = todo.url
      event.summary = "#{t.issue_name} - #{t.owners}" unless t.done?
      event.summary = "#{t.status_type} #{t.issue_name} (#{t.owners})" if t.done?
      event.description = todo.description
      event.categories = t.tags.collect{ |tag| tag.name.upcase } if(t.tags.size > 0)


      unless t.ical_entry
        cache = IcalEntry.new( :body => "#{event.to_ical}#{todo.to_ical}", :task_id => t.id )
        cache.save
      end

    end


    @activities.each do |log|

      if log.ical_entry
        cached << [log.ical_entry.body]
        next
      end

      event = cal.event
      event.start = to_localtime(tz, log.started_at)
#      event.end = to_localtime(tz, log.started_at + (log.duration > 0 ? (log.duration) : 60) )
      event.duration = "PT" + (log.duration > 0 ? to_duration(log.duration) : "1M")
      event.created = to_localtime(tz, log.task.created_at) unless log.task.nil?
      event.uid = "l#{log.id}_#{event.created}@#{user.company.subdomain}.#{Setting.domain}"
      event.organizer = "MAILTO:#{log.user.email}"

      event.url = "#{user.company.site_URL}/tasks/view/#{log.task.task_num}"

      action = get_action(log)

      event.summary = "#{action}: #{log.task.issue_name} - #{log.user.name}" unless log.task.nil?
      event.summary = "#{action} #{to_duration(log.duration).downcase}: #{log.task.issue_name} - #{log.user.name}" if log.duration > 0
      event.summary ||= "#{action} - #{log.user.name}"
      description = log.body.gsub(/<[^>]*>/,'').gsub(/[\r]/, '') if log.body
      event.description = description unless description.blank?

      event.categories = log.task.tags.collect{ |t| t.name.upcase } if log.task.tags.size > 0

      unless log.ical_entry
        cache = IcalEntry.new( :body => "#{event.to_ical}", :work_log_id => log.id )
        cache.save
      end

    end

    ical_feed = cal.to_ical.gsub(/END:VCALENDAR/,"#{cached.join}END:VCALENDAR").gsub(/^PERCENT:/, 'PERCENT-COMPLETE:')
    render :text => ical_feed

    ical_feed = nil
    @activities = nil
    @tasks = nil
    @milestones = nil
    tz = nil
    cached = ""
    cal = nil

    GC.start
  end

end
