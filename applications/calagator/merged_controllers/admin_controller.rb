
  class AdminController < ApplicationController
    require_admin

    def index
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
 link_to "Recent changes", '/changes' 
 link_to "Squash duplicate events", duplicates_events_path 
 link_to "Squash duplicate vennues", duplicates_venues_path 
 link_to "Lock events", admin_events_path 
 
  URI.parse(Calagator.url).host 
 source_code_version 
 
  

end

    end

    def events
      if params[:query].blank?
        @events = Event.future
      else
        @search = Event::Search.new(params)
        @admin_query = params[:query]

        @events = @search.events

        flash[:failure] = @search.failure_message
        return redirect_to admin_events_path if @search.hard_failure?
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
 form_tag admin_events_path, :method => :get do 
 search_field_tag "query", @admin_query, :id => "admin_search_field" 
 submit_tag("Search") 
 end 
 @events.each do |event| 
 link_to event.title, event_path(event) 
 event.start_time 
 if event.locked 
 button_to "Unlock", lock_event_path(:event_id => event.id, :query => @admin_query) 
 else 
 button_to "Lock", lock_event_path(:event_id => event.id, :query => @admin_query) 
 end 
 end 
 
  URI.parse(Calagator.url).host 
 source_code_version 
 
  

end

    end

    def lock_event
      @event = Event.find(params[:event_id])

      if @event.locked?
        @event.unlock_editing!
        flash[:success] = "Unlocked event #{@event.title} (#{@event.id})"
      else
        @event.lock_editing!
        flash[:success] = "Locked event #{@event.title} (#{@event.id})"
      end
      redirect_to :action => :events, :query => params[:query]
    end

  end

