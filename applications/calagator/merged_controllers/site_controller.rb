
class SiteController < ApplicationController
  # Raise exception, mostly for confirming that exception_notification works
  def omfg
    raise ArgumentError, "OMFG"
  end

  # Render something to help benchmark stack without the views
  def hello
    render :text => "hello"
  end

  def index
    @overview = Event::Overview.new
    respond_to do |format|
      format.html { }
      format.any  { redirect_to events_path(format: params[:format]) }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 yield :open_graph_tags 
 "#{yield(:title)} » ".html_safe if content_for?(:title) 
 Calagator.title 
 Calagator.tagline 
 "#{root_path}opensearch.xml" 
 Calagator.title 
 stylesheet_link_tag 'application', :media => :all 
 yield :css_insert 
 javascript_include_tag *mapping_js_includes 
 javascript_include_tag 'application' 
 yield :javascript_insert 
 auto_discovery_link_tag(:atom, events_url(:format => 'atom'), :title => 'Atom: All Events' )
 yield :discovery_insert 
 image_path("site-icon.png") 
 "#{controller.controller_name}_#{action_name}" 
 "#{controller.controller_name}_controller" 
 %w[new create edit update].include?(action_name) ? "#{controller.controller_name}_change" : "" 
  link_to Calagator.title, root_path, id: "project_title" 
link_class[:events]
 link_to "Events", events_path 
link_class[:venues]
 link_to "Venues", venues_path 
  form_tag search_events_path, :method => :get do 
 if request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"].include?("Safari") 
 @query 
 else 
 text_field_tag 'query', @query, id: 'search_field', tabindex: 1 
 end 
 end 
 
 # Pick a subnav 
  link_to 'Browse events', root_url,
              :class => subnav_class_for("site", "index") 
 link_to 'Add an event', new_event_url,
              :class => subnav_class_for("events", "new") 
 link_to 'Import events', new_source_url,
              :class => subnav_class_for("sources", "new") 
 
  link_to 'Browse venues', venues_url,
              :class => subnav_class_for("venues", "index") 
 link_to 'Add a venue', new_venue_url,
              :class => subnav_class_for("venues", "new") 
 
  
 
  render_flash 
 cache(CacheObserver.daily_key_for("site_index", request)) do 
  
  link_to "Find local events", about_url(anchor: "find_local_events") 
 link_to "Share local events", about_url(anchor: "share_local_events") 
 link_to "Get involved", about_url(anchor: "get_involved") 
 link_to "Find out about us", about_url 
 link_to "iCalendar feed", icalendar_feed_link 
 link_to "Atom feed", atom_feed_link 
 
 if @overview.tags.present? 
 tag_cloud @overview.tags, %w(tagcloud_level_0 tagcloud_level_1 tagcloud_level_2 tagcloud_level_3 tagcloud_level_4) do |tag, css_class| 
 link_to tag.name, search_events_path(tag: tag.name), class: css_class 
 end 
 end 
 link_to("View All &raquo;".html_safe, events_path(:anchor => "event-#{@overview.more.id}")) if @overview.more 
 
# Arguments:
# * events => Array of Event records

opts ||= {}
previous_start_time = nil
show_year ||= true
skipped = 0


 unless events.blank? 
 for event in events do 
 new_day = previous_start_time.nil? || (previous_start_time.to_date != event.start_time.to_date) 
 
new_day ||= nil
opts ||= {}
opts[:dates] = opts.has_key?(:dates) ? opts[:dates] : true
show_year ||= false

 date_class = (opts[:dates]==false || !new_day) ? ' hidden' : '' 
date_class
 today_tomorrow_or_weekday(event) 
 datetime_format(event.start_time,'%b %d') 
 if show_year 
 datetime_format(event.start_time,'%Y') 
 end 
 url_for event_url(event) 
 event.title 
 display_tag_icons(event) 
 normalize_time(event, :context => event.start_time.to_date) 
 if event.venue && !event.venue.title.blank? 
 url_for venue_url(event.venue) 
 event.venue.title 
 end 
 if !event.description.blank? 
 format_description(event.description) 
 end 
 if !event.url.blank? 
 link_to "Website", h(event.url), :class => "url u-url", :rel => "nofollow" 
 end 
 
 previous_start_time = event.start_time 
 end 
 else 
 end 
 if skipped > 0 
 link_to "(And #{skipped} more)", events_url 
 end 
 
 
# Arguments:
# * events => Array of Event records

opts ||= {}
previous_start_time = nil
show_year ||= true
skipped = 0


 unless events.blank? 
 for event in events do 
 new_day = previous_start_time.nil? || (previous_start_time.to_date != event.start_time.to_date) 
 
new_day ||= nil
opts ||= {}
opts[:dates] = opts.has_key?(:dates) ? opts[:dates] : true
show_year ||= false

 date_class = (opts[:dates]==false || !new_day) ? ' hidden' : '' 
date_class
 today_tomorrow_or_weekday(event) 
 datetime_format(event.start_time,'%b %d') 
 if show_year 
 datetime_format(event.start_time,'%Y') 
 end 
 url_for event_url(event) 
 event.title 
 display_tag_icons(event) 
 normalize_time(event, :context => event.start_time.to_date) 
 if event.venue && !event.venue.title.blank? 
 url_for venue_url(event.venue) 
 event.venue.title 
 end 
 if !event.description.blank? 
 format_description(event.description) 
 end 
 if !event.url.blank? 
 link_to "Website", h(event.url), :class => "url u-url", :rel => "nofollow" 
 end 
 
 previous_start_time = event.start_time 
 end 
 else 
 end 
 if skipped > 0 
 link_to "(And #{skipped} more)", events_url 
 end 
 
 
# Arguments:
# * events => Array of Event records

opts ||= {}
previous_start_time = nil
show_year ||= true
skipped = 0


 unless events.blank? 
 for event in events do 
 new_day = previous_start_time.nil? || (previous_start_time.to_date != event.start_time.to_date) 
 
new_day ||= nil
opts ||= {}
opts[:dates] = opts.has_key?(:dates) ? opts[:dates] : true
show_year ||= false

 date_class = (opts[:dates]==false || !new_day) ? ' hidden' : '' 
date_class
 today_tomorrow_or_weekday(event) 
 datetime_format(event.start_time,'%b %d') 
 if show_year 
 datetime_format(event.start_time,'%Y') 
 end 
 url_for event_url(event) 
 event.title 
 display_tag_icons(event) 
 normalize_time(event, :context => event.start_time.to_date) 
 if event.venue && !event.venue.title.blank? 
 url_for venue_url(event.venue) 
 event.venue.title 
 end 
 if !event.description.blank? 
 format_description(event.description) 
 end 
 if !event.url.blank? 
 link_to "Website", h(event.url), :class => "url u-url", :rel => "nofollow" 
 end 
 
 previous_start_time = event.start_time 
 end 
 else 
 end 
 if skipped > 0 
 link_to "(And #{skipped} more)", events_url 
 end 
 
 link_to("View future events &raquo;".html_safe, events_path(:anchor => "event-#{@overview.more.id}")) if @overview.more 
 end 
 
  URI.parse(Calagator.url).host 
 source_code_version 
 
  

end

  end

  # Displays the about page.
  def about; end

  def opensearch
    respond_to do |format|
      format.xml { render :content_type => 'application/opensearchdescription+xml' }
    end
  end

  def defunct
    @url = params[:url]
    raise ArgumentError if /^javascript:/.match(@url)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 yield :open_graph_tags 
 "#{yield(:title)} » ".html_safe if content_for?(:title) 
 Calagator.title 
 Calagator.tagline 
 "#{root_path}opensearch.xml" 
 Calagator.title 
 stylesheet_link_tag 'application', :media => :all 
 yield :css_insert 
 javascript_include_tag *mapping_js_includes 
 javascript_include_tag 'application' 
 yield :javascript_insert 
 auto_discovery_link_tag(:atom, events_url(:format => 'atom'), :title => 'Atom: All Events' )
 yield :discovery_insert 
 image_path("site-icon.png") 
 "#{controller.controller_name}_#{action_name}" 
 "#{controller.controller_name}_controller" 
 %w[new create edit update].include?(action_name) ? "#{controller.controller_name}_change" : "" 
  link_to Calagator.title, root_path, id: "project_title" 
link_class[:events]
 link_to "Events", events_path 
link_class[:venues]
 link_to "Venues", venues_path 
  form_tag search_events_path, :method => :get do 
 if request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"].include?("Safari") 
 @query 
 else 
 text_field_tag 'query', @query, id: 'search_field', tabindex: 1 
 end 
 end 
 
 # Pick a subnav 
  link_to 'Browse events', root_url,
              :class => subnav_class_for("site", "index") 
 link_to 'Add an event', new_event_url,
              :class => subnav_class_for("events", "new") 
 link_to 'Import events', new_source_url,
              :class => subnav_class_for("sources", "new") 
 
  link_to 'Browse venues', venues_url,
              :class => subnav_class_for("venues", "index") 
 link_to 'Add a venue', new_venue_url,
              :class => subnav_class_for("venues", "new") 
 
  
 
  render_flash 
 link_to 'Wayback Machine', 'https://archive.org/web/' 
 link_to @url, @url 
 
  URI.parse(Calagator.url).host 
 source_code_version 
 
  

end

  end
end

