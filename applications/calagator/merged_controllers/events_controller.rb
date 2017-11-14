require "calagator/duplicate_checking/controller_actions"


class EventsController < ApplicationController
  # Provides #duplicates and #squash_many_duplicates
  include DuplicateChecking::ControllerActions
  require_admin only: [:duplicates, :squash_many_duplicates]

  before_filter :find_and_redirect_if_locked, :only => [:edit, :update, :destroy]

  # GET /events
  # GET /events.xml
  def index
    @browse = Event::Browse.new(params)
    @events = @browse.events
    @browse.errors.each { |error| append_flash :failure, error }
    render_events @events
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    return redirect_to(@event.progenitor) if @event.duplicate?

    render_event @event
  rescue ActiveRecord::RecordNotFound => e
    return redirect_to events_path, flash: { failure: e.to_s }
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new(params.permit![:event])
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
 content_for :title, "Add an Event" 
  begin 
 render :partial => 'site/appropriateness' 
 rescue ActionView::MissingTemplate => e 
 end 
 
 
# USAGE: Display a form for creating or editing an event.
#
# VARIABLES:
# * event: An new or existing Event instance.

 if params[:preview] && event.valid? 
 
# VARIABLES:
# * event: An Event instance.
# * has_contentbar: Should room be left to display a contentbar on the side? Defaults to true.

has_contentbar = local_assigns.has_key?(:has_contentbar) ? local_assigns[:has_contentbar] : true

html_classes = "single_event"
html_classes << " contentbar" if has_contentbar

 html_classes 
 event.title 
 event.start_time.to_time.iso8601 
 if event.end_time 
 event.end_time.to_time.iso8601 
 end 
 normalize_time(event) 
 unless event.venue.blank? 
 " closed" if event.venue.closed? 
 map event.venue 
 event.venue.new_record? ? "#" : venue_url(event.venue) 
 event.venue.title 
 if event.venue.closed? 
 end 
 if !event.venue.street_address.blank? 
 event.venue.street_address 
 end 
 if !event.venue.locality.blank? 
 event.venue.locality 
 "," if event.venue.region.present? or event.venue.postal_code.present? or event.venue.country.present? 
 end 
 if !event.venue.region.blank? 
 event.venue.region 
 "," if event.venue.country.present? and not event.venue.postal_code.present? 
 end 
 if !event.venue.postal_code.blank? 
 event.venue.postal_code 
 "," if  event.venue.country.present? 
 end 
 if !event.venue.country.blank? 
 event.venue.country 
 end 
 if event.venue && event.venue.full_address.present? 
google_maps_url(event.venue.full_address) 
 end 
 if event.venue.wifi? 
 end 
 if event.venue.access_notes.present? 
 format_description event.venue.access_notes 
 end 
 unless event.venue_details.blank? 
 format_description(event.venue_details) 
 end 
 end 
 unless event.url.blank? 
 link_to "#{truncate(event.url, :length => 128)}", h(event.url), :class => "url u-url", :rel => "nofollow", 
        :itemprop => "url" 
 end 
 unless event.description.blank? 
 format_description(event.description) 
 end 
 if event.persisted? 
 shareable_event_url(event) 
 shareable_event_url(event) 
 tweet_text(event) 
 end 
 unless event.tags.blank? 
 tag_links_for event 
 end 
 
 end 
 semantic_form_for(event, :html => {:id => 'event_form', :class => 'standard_form', :novalidate => 'novalidate'}) do |f| 
 f.inputs :name => "#{'Editing: ' unless event.new_record?} <em>#{event.title}</em>".html_safe do 
 f.input :title, label: "Event Name", input_html: { autofocus: true } 
 label_tag :venue_name, "Venue", :class => 'label' 
 text_field_tag 'venue_name', '', :class=> 'autocomplete', :value => !event.venue.nil? ? event.venue.title : params[:venue_name] 
 hidden_field(:event, :venue_id, :value => (!event.venue.nil? ? event.venue.id : params[:event_venue_id])) 
 image_tag "spinner.gif", :id=> "event_venue_loading", :style => "display: none; margin-left: 0.5em;" 
 f.label :when, :class => 'label'  do 
 end 
 text_field_tag 'start_date', format_event_date(event.start_time), :id => 'date_start', :class => 'date_picker' 
 text_field_tag 'start_time', format_event_time(event.start_time), :id => 'time_start', :class => 'time_picker' 
 text_field_tag 'end_date', format_event_date(event.end_time), :id => 'date_end', :class => 'date_picker' 
 text_field_tag 'end_time', format_event_time(event.end_time), :id => 'time_end', :class => 'time_picker' 
 f.semantic_errors :start_date, :start_time, :end_date, :end_time 
 f.input :url, :label => 'Website' 
 f.input :description,
                :input_html => {:rows => 12},
                :hint => "(Format text using #{link_to("Markdown", "http://www.simpleeditions.com/59001/markdown-an-introduction", :target => "_blank")} and HTML)".html_safe 
 f.input :venue_details, :required => false,
                :input_html => {:rows => 4},
                :hint => "(Event-specific details like the room number, or who to call to be let into the building.)" 
 f.input :tag_list, :input_html => { :value => event.tag_list.to_s }, :required => false,
                :label => 'Tags',
                :hint => "(Tags are comma-separated keywords that make it easier to find your event and boost its position in searches. You can also use a tag like <code>plancast:plan=ABCD</code> to associate this with a particular <a href='http://plancast.com/'>Plancast</a> event, or a tag like <code>epdx:group=1234</code> to associate the event with a particular <a href='http://epdx.org/'>ePDX</a> group)".html_safe 
 label 'trap', 'field', "Leave this field blank or we'll think you're a robot." 
 text_field_tag 'trap_field', params[:trap_field] 
 end 
 f.actions do 
 f.action :submit, :label => "Preview", :button_html => {:name => 'preview'} 
 f.action :submit 
 end 
 end 
 
 
  URI.parse(Calagator.url).host 
 source_code_version 
 
  

end

  end

  # GET /events/1/edit
  def edit
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
 target 
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
 content_for :title, "Editing: #{@event.title}" 
 
# USAGE: Renders an edit form for an ActiveRecord model.
#
# VARIABLES:
# * record: The record to render this form for.

name = record.class.name.underscore.split("/").last
target = "edit_#{name}_form"
template = "calagator/#{name.pluralize}/form"

 
# USAGE: Displays a version picker for the given object.
#
# VARIABLES:
# * record: The record to show a version picker for.
# * target: The DOM id to update when refreshing the version.

 if record.versions.present? 
 select_tag("version", options_for_select(record.versions.reverse.map { |version| ["#{version.created_at.strftime('%B %d, %Y at %I:%M %p')}", version.id]})) 
 image_tag "spinner.gif", :alt => "Spinner", :id => "version_loading", :style => "display: none; margin-left: 0.5em;" 
  
 end 
 
 target 
 render template, name.to_sym => record 
 
 
  URI.parse(Calagator.url).host 
 source_code_version 
 
  

end

  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new
    create_or_update
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    create_or_update
  end

  def create_or_update
    saver = Event::Saver.new(@event, params.permit!)
    respond_to do |format|
      if saver.save
        format.html {
          flash[:success] = 'Event was successfully saved.'
          if saver.has_new_venue?
            flash[:success] += " Please tell us more about where it's being held."
            redirect_to edit_venue_url(@event.venue, from_event: @event.id)
          else
            redirect_to @event
          end
        }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html {
          flash[:failure] = saver.failure
          render action: @event.new_record? ? "new" : "edit"
        }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url, :flash => {:success => "\"#{@event.title}\" has been deleted"}) }
      format.xml  { head :ok }
    end
  end

  # GET /events/search
  def search
    @search = Event::Search.new(params)

    # setting @events so that we can reuse the index atom builder
    @events = @search.events

    flash[:failure] = @search.failure_message
    return redirect_to root_path if @search.hard_failure?

    render_events(@events)
  end

  def clone
    @event = Event::Cloner.clone(Event.find(params[:id]))
    flash[:success] = "This is a new event cloned from an existing one. Please update the fields, like the time and description."
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
 content_for :title, "Add an Event" 
  begin 
 render :partial => 'site/appropriateness' 
 rescue ActionView::MissingTemplate => e 
 end 
 
 
# USAGE: Display a form for creating or editing an event.
#
# VARIABLES:
# * event: An new or existing Event instance.

 if params[:preview] && event.valid? 
 
# VARIABLES:
# * event: An Event instance.
# * has_contentbar: Should room be left to display a contentbar on the side? Defaults to true.

has_contentbar = local_assigns.has_key?(:has_contentbar) ? local_assigns[:has_contentbar] : true

html_classes = "single_event"
html_classes << " contentbar" if has_contentbar

 html_classes 
 event.title 
 event.start_time.to_time.iso8601 
 if event.end_time 
 event.end_time.to_time.iso8601 
 end 
 normalize_time(event) 
 unless event.venue.blank? 
 " closed" if event.venue.closed? 
 map event.venue 
 event.venue.new_record? ? "#" : venue_url(event.venue) 
 event.venue.title 
 if event.venue.closed? 
 end 
 if !event.venue.street_address.blank? 
 event.venue.street_address 
 end 
 if !event.venue.locality.blank? 
 event.venue.locality 
 "," if event.venue.region.present? or event.venue.postal_code.present? or event.venue.country.present? 
 end 
 if !event.venue.region.blank? 
 event.venue.region 
 "," if event.venue.country.present? and not event.venue.postal_code.present? 
 end 
 if !event.venue.postal_code.blank? 
 event.venue.postal_code 
 "," if  event.venue.country.present? 
 end 
 if !event.venue.country.blank? 
 event.venue.country 
 end 
 if event.venue && event.venue.full_address.present? 
google_maps_url(event.venue.full_address) 
 end 
 if event.venue.wifi? 
 end 
 if event.venue.access_notes.present? 
 format_description event.venue.access_notes 
 end 
 unless event.venue_details.blank? 
 format_description(event.venue_details) 
 end 
 end 
 unless event.url.blank? 
 link_to "#{truncate(event.url, :length => 128)}", h(event.url), :class => "url u-url", :rel => "nofollow", 
        :itemprop => "url" 
 end 
 unless event.description.blank? 
 format_description(event.description) 
 end 
 if event.persisted? 
 shareable_event_url(event) 
 shareable_event_url(event) 
 tweet_text(event) 
 end 
 unless event.tags.blank? 
 tag_links_for event 
 end 
 
 end 
 semantic_form_for(event, :html => {:id => 'event_form', :class => 'standard_form', :novalidate => 'novalidate'}) do |f| 
 f.inputs :name => "#{'Editing: ' unless event.new_record?} <em>#{event.title}</em>".html_safe do 
 f.input :title, label: "Event Name", input_html: { autofocus: true } 
 label_tag :venue_name, "Venue", :class => 'label' 
 text_field_tag 'venue_name', '', :class=> 'autocomplete', :value => !event.venue.nil? ? event.venue.title : params[:venue_name] 
 hidden_field(:event, :venue_id, :value => (!event.venue.nil? ? event.venue.id : params[:event_venue_id])) 
 image_tag "spinner.gif", :id=> "event_venue_loading", :style => "display: none; margin-left: 0.5em;" 
 f.label :when, :class => 'label'  do 
 end 
 text_field_tag 'start_date', format_event_date(event.start_time), :id => 'date_start', :class => 'date_picker' 
 text_field_tag 'start_time', format_event_time(event.start_time), :id => 'time_start', :class => 'time_picker' 
 text_field_tag 'end_date', format_event_date(event.end_time), :id => 'date_end', :class => 'date_picker' 
 text_field_tag 'end_time', format_event_time(event.end_time), :id => 'time_end', :class => 'time_picker' 
 f.semantic_errors :start_date, :start_time, :end_date, :end_time 
 f.input :url, :label => 'Website' 
 f.input :description,
                :input_html => {:rows => 12},
                :hint => "(Format text using #{link_to("Markdown", "http://www.simpleeditions.com/59001/markdown-an-introduction", :target => "_blank")} and HTML)".html_safe 
 f.input :venue_details, :required => false,
                :input_html => {:rows => 4},
                :hint => "(Event-specific details like the room number, or who to call to be let into the building.)" 
 f.input :tag_list, :input_html => { :value => event.tag_list.to_s }, :required => false,
                :label => 'Tags',
                :hint => "(Tags are comma-separated keywords that make it easier to find your event and boost its position in searches. You can also use a tag like <code>plancast:plan=ABCD</code> to associate this with a particular <a href='http://plancast.com/'>Plancast</a> event, or a tag like <code>epdx:group=1234</code> to associate the event with a particular <a href='http://epdx.org/'>ePDX</a> group)".html_safe 
 label 'trap', 'field', "Leave this field blank or we'll think you're a robot." 
 text_field_tag 'trap_field', params[:trap_field] 
 end 
 f.actions do 
 f.action :submit, :label => "Preview", :button_html => {:name => 'preview'} 
 f.action :submit 
 end 
 end 
 
 
  URI.parse(Calagator.url).host 
 source_code_version 
 
  

end

  end

  private

  def render_event(event)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml  => event.to_xml(root: "events", :include => :venue) }
      format.json { render :json => event.to_json(:include => :venue) }
      format.ics  { render :ics  => [event] }
    end
  end

  # Render +events+ for a particular format.
  def render_events(events)
    respond_to do |format|
      format.html # *.html.erb
      format.kml  # *.kml.erb
      format.ics  { render :ics => events || Event.future.non_duplicates }
      format.atom { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 content_for :title, "Events" 
 cache_if(@browse.default?, CacheObserver.daily_key_for("events_index", request)) do 
 @browse.events.size 
 @browse.date ? 'filtered' : 'future' 
 events_sort_label(@browse.order) 
 form_tag events_url, :method => 'get' do  
 text_field_tag 'date[start]', @browse.start_date, :id => 'date_start', :class => 'date_picker' 
 text_field_tag 'date[end]', @browse.end_date, :id => 'date_end', :class => 'date_picker' 
 text_field_tag 'time[start]', @browse.start_time, :id => 'filter_time_start', :class => 'time_picker_filter' 
 text_field_tag 'time[end]', @browse.end_time, :id => 'filter_time_end', :class => 'time_picker_filter' 
 submit_tag 'Filter' 
 link_to 'Reset', events_url 
 end 
 link_to "iCalendar feed", icalendar_feed_link 
 link_to "Atom feed", atom_feed_link 
 link_to "Google Calendar", google_events_subscription_link 
 link_to "iCalendar file", icalendar_export_link 
 
# Arguments:
# * events => Array of Event records.
# * scores => Offer a sort by score, like for search? Default to false.

scores = defined?(scores) ? scores : false

previous_start_time = nil
#show_year ||= false
skipped = 0

# calculate rowspans array for events
# each entry is number of rows spanned by today_tomorrow_weekday entry, if any, to left of event
# entry will be > 0 for first event of day, 0 for other events
rowspans = calculate_rowspans(events)

 link_to "Date", url_for(params.merge(:order => 'date')) 
 events_sort_link('name') 
 events_sort_link('venue') 
 if scores 
 events_sort_link('score') 
 end 
 events_sort_link(nil) 
 unless events.size==0 
 events.each_with_index do |event, index| 
 if rowspans[index] > 0 
rowspans[index]
 today_tomorrow_or_weekday(event).downcase 
 today_tomorrow_or_weekday(event) 
 show_year = event.start_time.year != Time.now.year 
 datetime_format(event.start_time,'%b %d') 
 ", "+datetime_format(event.start_time,'%Y') if show_year 
 end 
 url_for event_url(event) 
 "event-#{event.id}" 
 "event-#{event.id}" 
 event.title 
 normalize_time(event, :context => event.start_time.to_date) 
 if event.venue && !event.venue.title.blank? 
 url_for venue_url(event.venue) 
 event.venue.title 
 end 
 if !event.description.blank? 
 format_description(event.description) 
 end 
 if !event.url.blank? 
 link_to "Website", event.url, :class => "url u-url", :rel => "nofollow" 
 end 
 end 
 else 
 end 
 if skipped > 0 
 link_to "(And #{skipped} more)", events_url 
 end 
 
 end 
 
  URI.parse(Calagator.url).host 
 source_code_version 
 
  

end
 }
      format.xml  { render :xml  => events.to_xml(root: "events", :include => :venue) }
      format.json { render :json => events.to_json(:include => :venue) }
    end
  end

  def find_and_redirect_if_locked
    @event = Event.find(params[:id])
    if @event.locked?
      flash[:failure] = "You are not permitted to modify this event."
      redirect_to root_path
    end
  end
end

