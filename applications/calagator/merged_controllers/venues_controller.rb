require "calagator/duplicate_checking/controller_actions"


class VenuesController < ApplicationController
  # Provides #duplicates and #squash_many_duplicates
  include DuplicateChecking::ControllerActions
  require_admin only: [:duplicates, :squash_many_duplicates]

  def venue
    @venue ||= params[:id] ? Venue.find(params[:id]) : Venue.new
  end


  # GET /venues
  def index
    @search = Venue::Search.new(params.permit!)
    @venues = @search.venues

    flash[:failure] = @search.failure_message
    return redirect_to venues_path if @search.hard_failure?
    render_venues @venues
  end

  def render_venues venues
    respond_to do |format|
      format.html # index.html.erb
      format.kml  # index.kml.erb
      format.xml  { render xml:  venues }
      format.json { render json: venues }
      format.js   { render json: venues }
    end
  end
  private :render_venues


  # GET /autocomplete via AJAX
  def autocomplete
    @venues = Venue
      .non_duplicates
      .in_business
      .where(["LOWER(title) LIKE ?", "%#{params[:term]}%".downcase])
      .order('LOWER(title)')

    render json: @venues
  end


  # GET /venues/map
  def map
    @venues = Venue.non_duplicates.in_business
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
 map @venues, Calagator.venues_map_options 
 
  URI.parse(Calagator.url).host 
 source_code_version 
 
  

end

  end


  # GET /venues/1
  def show
    Show.new(self).call
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
 edit_venue_url(@venue) 
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
 content_for :title, @venue.title 
  
 link_to "edit", edit_venue_url(@venue) 
 link_to "delete", venue_url(@venue), method: :delete, data: { confirm: "Are you sure?" } 
 link_to "iCalendar file", venue_url(@venue, :format => :ics) 
 link_to "subscribe to a feed", venue_url(@venue, :format => :ics, :protocol => "webcal") 
 datestamp(@venue) 
 " closed" if @venue.closed? 
 @venue.title 
 if @venue.closed? 
 end 
 if @venue.full_address.present? 
 if @venue.street_address.present? 
 @venue.street_address 
 end 
 if @venue.locality.present? 
 @venue.locality 
 "," if @venue.region.present? or @venue.postal_code.present? or @venue.country.present? 
 end 
 if @venue.region.present? 
 @venue.region 
 "," if @venue.country.present? and not @venue.postal_code.present? 
 end 
 if @venue.postal_code.present? 
 @venue.postal_code 
 "," if  @venue.country.present? 
 end 
 if @venue.country.present? 
 @venue.country 
 end 
google_maps_url(@venue.full_address) 
 else 
 if @venue.address.present? 
 @venue.address 
google_maps_url(@venue.address) 
 end 
 end 
 if @venue.url.present? 
 link_to(truncate(url_for(@venue.url), :length => 60), url_for(@venue.url), :rel => "nofollow") 
 end 
 if @venue.email.present? 
 mail_to @venue.email 
 end 
 if @venue.telephone.present? 
 @venue.telephone 
 end 
 if @venue.wifi? 
 end 
 if @venue.description.present? || @venue.access_notes.present? 
 format_description(@venue.description) 
 if @venue.access_notes.present? 
 format_description @venue.access_notes 
 end 
 end 
 if @venue.tags.present? 
 tag_links_for @venue 
 end 
 map @venue 
 
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
 
 
  URI.parse(Calagator.url).host 
 source_code_version 
 
  

end

  end

  class Show < SimpleDelegator
    def call
      show_all_if_not_found or redirect_to_progenitor or render_venue
    end

    private

    def show_all_if_not_found
      return if venue
    rescue ActiveRecord::RecordNotFound => exception
      redirect_to venues_path, flash: { failure: exception.to_s }
    end

    def redirect_to_progenitor
      redirect_to venue.progenitor if venue.duplicate?
    end

    def render_venue
      respond_to do |format|
        format.html
        format.xml  { render xml: venue }
        format.json { render json: venue }
        format.ics  { render ics: venue_events }
      end
    end

    def venue_events
      venue.events.order(:start_time)
    end
  end


  # GET /venues/new
  def new
    venue
    render layout: params[:layout] != "false"
  end


  # GET /venues/1/edit
  def edit
    venue
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
 content_for :title, "Editing #{@venue.title}" 
 
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


  # POST /venues, # PUT /venues/1
  def create
    CreateOrUpdate.new(self).call
  end
  alias_method :update, :create

  class CreateOrUpdate < SimpleDelegator
    def call
      block_spammers or (save and render_success) or render_failure
    end

    private

    def block_spammers
      return unless params[:trap_field].present?
      flash[:failure] = "<h3>Evil Robot</h3> We didn't save this venue because we think you're an evil robot. If you're really not an evil robot, look at the form instructions more carefully. If this doesn't work please file a bug report and let us know."
      render_failure
    end

    def save
      venue.update_attributes params.permit![:venue].to_h
    end

    def render_success
      respond_to do |format|
        format.html { redirect_to from_event || venue, flash: { success: "Venue was successfully saved." } }
        format.xml  { render xml: venue, status: :created, location: venue }
      end
    end

    def render_failure
      respond_to do |format|
        format.html { render action: venue.new_record? ? "new" : "edit" }
        format.xml  { render xml: venue.errors, status: :unprocessable_entity }
      end
    end

    def from_event
      Event.find_by_id(params[:from_event])
    end
  end


  # DELETE /venues/1
  def destroy
    Destroy.new(self).call
  end

  class Destroy < SimpleDelegator
    def call
      prevent_destruction_of_venue_with_events or destroy
    end

    private

    def prevent_destruction_of_venue_with_events
      return if venue.events.none?
      message = "Cannot destroy venue that has associated events, you must reassociate all its events first."
      respond_to do |format|
        format.html { redirect_to venue, flash: { failure: message } }
        format.xml  { render xml: message, status: :unprocessable_entity }
      end
    end

    def destroy
      venue.destroy
      respond_to do |format|
        format.html { redirect_to venues_path, flash: { success: %("#{venue.title}" has been deleted) } }
        format.xml  { head :ok }
      end
    end
  end
end

