class EventsController < BaseController

  require 'htmlentities'
  caches_page :ical
  cache_sweeper :event_sweeper, :only => [:create, :update, :destroy]


  uses_tiny_mce do
    {:only => [:new, :edit, :create, :update, :clone ], :options => configatron.default_mce_options}
  end

  uses_tiny_mce do
    {:only => [:show], :options => configatron.simple_mce_options}
  end

  before_action :admin_required, :except => [:index, :show, :ical]

  def ical
    @calendar = RiCal.Calendar
    @calendar.add_x_property 'X-WR-CALNAME', configatron.community_name
    @calendar.add_x_property 'X-WR-CALDESC', "#{configatron.community_name} #{:events.l}"
    Event.all.each do |ce_event|
      rical_event = RiCal.Event do |event|
        event.dtstart = ce_event.start_time
        event.dtend = ce_event.end_time
        event.summary = ce_event.name + (ce_event.metro_area.blank? ? '' : " (#{ce_event.metro_area})")
        coder = HTMLEntities.new
        event.description = (ce_event.description.blank? ? '' : coder.decode(view_context.strip_tags(ce_event.description).to_s) + "\n\n") + event_url(ce_event)
        event.location = ce_event.location unless ce_event.location.blank?
      end
      @calendar.add_subcomponent rical_event
    end
    headers['Content-Type'] = "text/calendar; charset=UTF-8"
    render :text => @calendar.export_to, :layout => false
  end

  def show
    @is_admin_user = (current_user && current_user.admin?)
    @event = Event.find(params[:id])
    @comments = @event.comments.includes(:user).order('created_at DESC').limit(20)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 home_url 
 csrf_meta_tag 
 page_title 
 if @meta 
 @meta.each do |key| 
 key[1] 
 key[0] 
 end 
 end 
 if @rss_title && @rss_url 
 auto_discovery_link_tag(:rss, @rss_url, {:title => @rss_title}) 
 end 
  stylesheet_link_tag 'community_engine' 
 if forum_page? 
 unless @feed_icons.blank? 
 @feed_icons.each do |feed| 
 auto_discovery_link_tag :rss, feed[:url], :title => "Subscribe to '#{feed[:title]}'" 
 end 
 end 
 end 
 yield :head_css 
 
 unless configatron.auth_providers.facebook.key.blank? 
  
 end 
  link_to configatron.community_name, home_path, :class => 'navbar-brand' 
  
  if current_page?(site_clippings_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :clippings.l, site_clippings_path 
 
  if params[:controller] == 'events' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :events.l, events_path 
 
  if params[:controller] == 'forums' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :forums.l, forums_path 
 
  if current_page?(popular_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :popular.l, popular_path 
 
  if current_page?(users_path) || (params[:controller] == 'users' && !@user.nil? && @user != current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :people.l, users_path 
 
 if @header_tabs.any? 
 for tab in @header_tabs 
 link_to tab.name, tab.url 
 end 
 end 
  if logged_in? 
 if current_user.unread_messages? 
 if params[:controller] == 'messages' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 user_messages_path(current_user) 
 current_user.unread_message_count 
 fa_icon "envelope inverse" 
 end 
 end 
 
  
 
 render_jumbotron 
 container_title 
  
  @section = 'events' 
 @page_title = @event.name 
 widget do 
 if @is_admin_user 
 link_to :administer_events.l, admin_events_path 
 end 
 link_to fa_icon('plus-circle', :text => :see_all_events.l), events_path 
 end 
  widget do 
 :subscribe_to.l + ' ' + :events.l 
 :subscribe_events_instructions.l 
 link_to image_tag('icons/ical.gif'), ical_events_url(:protocol => 'webcal://', :format=>'ics') 
 link_to image_tag("http://www.google.com/calendar/images/ext/gc_button1.gif"), "http://www.google.com/calendar/render?cid=#{ical_events_url(:format=>'ics')}", :target=>'_blank' 
 end 
 
 if (logged_in? && (@event.user.eql?(current_user) || admin?)) 
 link_to :back.l, events_path, :class => 'btn btn-default' 
 link_to :clone.l, clone_event_path(@event), :class => 'btn btn-success' 
 link_to :edit.l, edit_event_path(@event), :class => 'btn btn-warning' 
 link_to :delete.l, event_path(@event), data: { confirm: :are_you_sure.l }, :method => :delete, :class => 'btn btn-danger' 
 end 
 :when.l 
 @event.time_and_date 
 unless @event.location.blank? 
 :where.l+":" 
 @event.location 
 link_to :map_it.l, "http://www.google.com/maps?q=#{URI::encode(@event.location)}", :title=>:map_it.l, :target=>'_blank' 
 end 
 if @event.allow_rsvp? 
 :rsvps.l 
 attending = @event.attendees_count == 1 ? :is_attending_this_event.l : :are_attending_this_event.l 
 pluralize(@event.attendees_count, 'person') + ' ' + attending 
 if @event.end_time > Time.now 
 if rsvp = @event.rsvped?(current_user) 
 link_to :retract_rsvp.l, [@event, rsvp], data: { confirm: :are_you_sure.l }, :method=>:delete, :class => 'btn btn-primary btn-xs' 
 link_to :update_rsvp.l, edit_event_rsvp_url(@event, rsvp), :class => 'btn btn-primary btn-xs' 
 else 
 link_to :rsvp.l, new_event_rsvp_url(@event), :class => 'btn btn-primary btn-xs' 
 end 
 end 
 end 
 @event.description.html_safe unless @event.description.blank? 
 unless @event.attendees.blank? 
 :attendees.l 
 @event.attendees.each do |user| 
 link_to h(user.display_name), user_path(user) 
 if (count = @event.attendees_for_user(user)) > 1 
 "+#{count-1}" 
 end 
 end 
 end 
 :event_comments.l 
 :add_your_comment.l 
  if logged_in? || configatron.allow_anonymous_commenting 
 bootstrap_form_for(:comment, :url => commentable_comments_path(commentable.class.to_s.tableize, commentable), :remote => true, :layout => :horizontal, :html => {:id => 'comment'}) do |f| 
 f.text_area :comment, :rows => 5, :style => 'width: 99%', :class => "rich_text_editor", :help => :comment_character_limit.l 
 if !logged_in? && configatron.recaptcha_pub_key && configatron.recaptcha_priv_key 
 f.text_field :author_name 
 f.text_field :author_email, :required => true 
 f.form_group do 
 f.check_box :notify_by_email, :label => :notify_me_of_follow_ups_via_email.l 
 if commentable.respond_to?(:send_comment_notifications?) && !commentable.send_comment_notifications? 
 :comment_notifications_off.l 
 end 
 end 
 f.text_field :author_url, :label => :comment_web_site_label.l 
 f.form_group do 
 recaptcha_tags :ajax => true 
 end 
 end 
 f.form_group :submit_group do 
 f.primary :add_comment.l, data: { disable_with: "Please wait..." } 
 end 
 end 
 else 
 link_to :log_in_to_leave_a_comment.l, new_commentable_comment_path(commentable.class, commentable.id), :class => 'btn btn-primary' 
 link_to :create_an_account.l, signup_path, :class => 'btn btn-primary' 
 end 
 
  comment.id 
 if comment.pending? 
 end 
 if comment.user 
 link_to image_tag(comment.user.avatar_photo_url(:medium), :alt => comment.user.login, :class => "img-responsive"), user_path(comment.user), :rel => 'bookmark', :title => :users_profile.l(:user => comment.user.login), :class => 'list-group-item' 
 user_path(comment.user) 
 fa_icon "hand-o-right fw", :text => comment.user.login 
 commentable_url(comment) 
 fa_icon "calendar" 
 comment.created_at 
 I18n.l(comment.created_at, :format => :short_literal_date) 
 if logged_in? && (current_user.admin? || current_user.moderator?) 
 link_to fa_icon("pencil-square-o fw", :text => :edit.l), edit_commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :class => 'edit-via-ajax list-group-item' 
 end 
 if ( comment.can_be_deleted_by(current_user) ) 
 link_to fa_icon("trash-o fw", :text => :delete.l), commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :method => :delete, 'data-confirm' => :are_you_sure_you_want_to_permanently_delete_this_comment.l, :remote => true, :class => "list-group-item" 
 end 
 comment.comment.html_safe 
 else 
 image_tag(configatron.photo.missing_thumb, :height => '50', :width => '50', :class => "img-responsive") 
 if comment.author_url.blank? 
 h comment.username 
 else 
 link_to fa_icon('hand-o-right', :text => h(comment.username)), h(comment.author_url) 
 end 
 commentable_url(comment) 
 fa_icon "calendar fw" 
 comment.created_at 
 I18n.l(comment.created_at, :format => :short_literal_date) 
 if logged_in? && (current_user.admin? || current_user.moderator?) 
 link_to fa_icon("pencil-square-o fw", :text => :edit.l), edit_commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :class => 'edit-via-ajax list-group-item' 
 end 
 if ( comment.can_be_deleted_by(current_user) ) 
 link_to fa_icon("trash-o fw", :text => :delete.l), commentable_comment_path(comment.commentable_type, comment.commentable_id, comment), :method => :delete, 'data-confirm' => :are_you_sure_you_want_to_permanently_delete_this_comment.l, :remote => true, :class => "list-group-item" 
 end 
 comment.comment.html_safe 
 end 
 
 more_comments_links(@event) 
  render_widgets 
 
 if show_footer_content? 
 image_tag 'spinner.gif', :plugin => 'community_engine' 
 :loading_recent_content.l 
 end 
  
 :community_tagline.l 
  javascript_include_tag 'community_engine' 
 tiny_mce_init_if_needed 
 if show_footer_content? 
 end 
 
 yield :end_javascript 

end

  end

  def index
    @is_admin_user = (current_user && current_user.admin?)
    @events = Event.upcoming.page(params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 home_url 
 csrf_meta_tag 
 page_title 
 if @meta 
 @meta.each do |key| 
 key[1] 
 key[0] 
 end 
 end 
 if @rss_title && @rss_url 
 auto_discovery_link_tag(:rss, @rss_url, {:title => @rss_title}) 
 end 
  stylesheet_link_tag 'community_engine' 
 if forum_page? 
 unless @feed_icons.blank? 
 @feed_icons.each do |feed| 
 auto_discovery_link_tag :rss, feed[:url], :title => "Subscribe to '#{feed[:title]}'" 
 end 
 end 
 end 
 yield :head_css 
 
 unless configatron.auth_providers.facebook.key.blank? 
  
 end 
  link_to configatron.community_name, home_path, :class => 'navbar-brand' 
  
  if current_page?(site_clippings_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :clippings.l, site_clippings_path 
 
  if params[:controller] == 'events' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :events.l, events_path 
 
  if params[:controller] == 'forums' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :forums.l, forums_path 
 
  if current_page?(popular_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :popular.l, popular_path 
 
  if current_page?(users_path) || (params[:controller] == 'users' && !@user.nil? && @user != current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :people.l, users_path 
 
 if @header_tabs.any? 
 for tab in @header_tabs 
 link_to tab.name, tab.url 
 end 
 end 
  if logged_in? 
 if current_user.unread_messages? 
 if params[:controller] == 'messages' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 user_messages_path(current_user) 
 current_user.unread_message_count 
 fa_icon "envelope inverse" 
 end 
 end 
 
  
 
 render_jumbotron 
 container_title 
  
  @section = 'events' 
 @page_title = :events.l 
 :find_out_where_to_be_and_when_to_be_there.l 
 if @is_admin_user 
 widget do 
 link_to_unless_current :past_events.l, past_events_path 
 link_to_unless_current :upcoming_events.l, events_path 
 link_to :administer_events.l, admin_events_path 
 end 
 end 
  widget do 
 :subscribe_to.l + ' ' + :events.l 
 :subscribe_events_instructions.l 
 link_to image_tag('icons/ical.gif'), ical_events_url(:protocol => 'webcal://', :format=>'ics') 
 link_to image_tag("http://www.google.com/calendar/images/ext/gc_button1.gif"), "http://www.google.com/calendar/render?cid=#{ical_events_url(:format=>'ics')}", :target=>'_blank' 
 end 
 
  event.name 
 !event.metro_area.nil? ? " (#{event.metro_area.to_s})" : '' 
 if (logged_in? && (event.user.eql?(current_user) || admin?)) 
 link_to :show.l, event_path(event), :class => 'btn btn-default' 
 link_to :clone.l, clone_event_path(event), :class => 'btn btn-success' 
 link_to :edit.l, edit_event_path(event), :class => 'btn btn-warning' 
 link_to :delete.l, event_path(event), data: { confirm: :are_you_sure.l }, :method => :delete, :class => 'btn btn-danger' 
 end 
 :when.l 
 event.time_and_date 
 unless event.location.blank? 
 :where.l+":" 
 event.location 
 link_to :map_it.l, "http://www.google.com/maps?q=#{URI::encode(event.location)}", :title=>:map_it.l, :target=>'_blank' 
 end 
 if event.allow_rsvp? 
 :rsvps.l 
 attending = event.attendees_count == 1 ? :is_attending_this_event.l : :are_attending_this_event.l 
 pluralize(event.attendees_count, 'person') + ' ' + attending 
 if event.end_time > Time.now 
 if rsvp = event.rsvped?(current_user) 
 link_to :retract_rsvp.l, [event, rsvp], data: { confirm: :are_you_sure.l }, :method=>:delete, :class => 'btn btn-primary btn-xs' 
 link_to :update_rsvp.l, edit_event_rsvp_url(event, rsvp), :class => 'btn btn-primary btn-xs' 
 else 
 link_to :rsvp.l, new_event_rsvp_url(event), :class => 'btn btn-primary btn-xs' 
 end 
 end 
 end 
 if show_details_link 
 link_to :event_details.l, event_url(event) 
 end 
 
 paginate @events , :theme => 'bootstrap' 
  render_widgets 
 
 if show_footer_content? 
 image_tag 'spinner.gif', :plugin => 'community_engine' 
 :loading_recent_content.l 
 end 
  
 :community_tagline.l 
  javascript_include_tag 'community_engine' 
 tiny_mce_init_if_needed 
 if show_footer_content? 
 end 
 
 yield :end_javascript 

end

  end

  def past
    @is_admin_user = (current_user && current_user.admin?)
    @events = Event.past.page(params[:page])
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 home_url 
 csrf_meta_tag 
 page_title 
 if @meta 
 @meta.each do |key| 
 key[1] 
 key[0] 
 end 
 end 
 if @rss_title && @rss_url 
 auto_discovery_link_tag(:rss, @rss_url, {:title => @rss_title}) 
 end 
  stylesheet_link_tag 'community_engine' 
 if forum_page? 
 unless @feed_icons.blank? 
 @feed_icons.each do |feed| 
 auto_discovery_link_tag :rss, feed[:url], :title => "Subscribe to '#{feed[:title]}'" 
 end 
 end 
 end 
 yield :head_css 
 
 unless configatron.auth_providers.facebook.key.blank? 
  
 end 
  link_to configatron.community_name, home_path, :class => 'navbar-brand' 
  
  if current_page?(site_clippings_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :clippings.l, site_clippings_path 
 
  if params[:controller] == 'events' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :events.l, events_path 
 
  if params[:controller] == 'forums' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :forums.l, forums_path 
 
  if current_page?(popular_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :popular.l, popular_path 
 
  if current_page?(users_path) || (params[:controller] == 'users' && !@user.nil? && @user != current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :people.l, users_path 
 
 if @header_tabs.any? 
 for tab in @header_tabs 
 link_to tab.name, tab.url 
 end 
 end 
  if logged_in? 
 if current_user.unread_messages? 
 if params[:controller] == 'messages' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 user_messages_path(current_user) 
 current_user.unread_message_count 
 fa_icon "envelope inverse" 
 end 
 end 
 
  
 
 render_jumbotron 
 container_title 
  
  @section = 'events' 
 @page_title = :events.l 
 :find_out_where_to_be_and_when_to_be_there.l 
 if @is_admin_user 
 widget do 
 link_to_unless_current :past_events.l, past_events_path 
 link_to_unless_current :upcoming_events.l, events_path 
 link_to :administer_events.l, admin_events_path 
 end 
 end 
  widget do 
 :subscribe_to.l + ' ' + :events.l 
 :subscribe_events_instructions.l 
 link_to image_tag('icons/ical.gif'), ical_events_url(:protocol => 'webcal://', :format=>'ics') 
 link_to image_tag("http://www.google.com/calendar/images/ext/gc_button1.gif"), "http://www.google.com/calendar/render?cid=#{ical_events_url(:format=>'ics')}", :target=>'_blank' 
 end 
 
  event.name 
 !event.metro_area.nil? ? " (#{event.metro_area.to_s})" : '' 
 if (logged_in? && (event.user.eql?(current_user) || admin?)) 
 link_to :show.l, event_path(event), :class => 'btn btn-default' 
 link_to :clone.l, clone_event_path(event), :class => 'btn btn-success' 
 link_to :edit.l, edit_event_path(event), :class => 'btn btn-warning' 
 link_to :delete.l, event_path(event), data: { confirm: :are_you_sure.l }, :method => :delete, :class => 'btn btn-danger' 
 end 
 :when.l 
 event.time_and_date 
 unless event.location.blank? 
 :where.l+":" 
 event.location 
 link_to :map_it.l, "http://www.google.com/maps?q=#{URI::encode(event.location)}", :title=>:map_it.l, :target=>'_blank' 
 end 
 if event.allow_rsvp? 
 :rsvps.l 
 attending = event.attendees_count == 1 ? :is_attending_this_event.l : :are_attending_this_event.l 
 pluralize(event.attendees_count, 'person') + ' ' + attending 
 if event.end_time > Time.now 
 if rsvp = event.rsvped?(current_user) 
 link_to :retract_rsvp.l, [event, rsvp], data: { confirm: :are_you_sure.l }, :method=>:delete, :class => 'btn btn-primary btn-xs' 
 link_to :update_rsvp.l, edit_event_rsvp_url(event, rsvp), :class => 'btn btn-primary btn-xs' 
 else 
 link_to :rsvp.l, new_event_rsvp_url(event), :class => 'btn btn-primary btn-xs' 
 end 
 end 
 end 
 if show_details_link 
 link_to :event_details.l, event_url(event) 
 end 
 
 paginate @events , :theme => 'bootstrap' 
  render_widgets 
 
 if show_footer_content? 
 image_tag 'spinner.gif', :plugin => 'community_engine' 
 :loading_recent_content.l 
 end 
  
 :community_tagline.l 
  javascript_include_tag 'community_engine' 
 tiny_mce_init_if_needed 
 if show_footer_content? 
 end 
 
 yield :end_javascript 

end

  end

  def new
    @event = Event.new
    @metro_areas, @states = setup_metro_area_choices_for(current_user)
    @metro_area_id, @state_id, @country_id = setup_location_for(current_user)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 home_url 
 csrf_meta_tag 
 page_title 
 if @meta 
 @meta.each do |key| 
 key[1] 
 key[0] 
 end 
 end 
 if @rss_title && @rss_url 
 auto_discovery_link_tag(:rss, @rss_url, {:title => @rss_title}) 
 end 
  stylesheet_link_tag 'community_engine' 
 if forum_page? 
 unless @feed_icons.blank? 
 @feed_icons.each do |feed| 
 auto_discovery_link_tag :rss, feed[:url], :title => "Subscribe to '#{feed[:title]}'" 
 end 
 end 
 end 
 yield :head_css 
 
 unless configatron.auth_providers.facebook.key.blank? 
  
 end 
  link_to configatron.community_name, home_path, :class => 'navbar-brand' 
  
  if current_page?(site_clippings_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :clippings.l, site_clippings_path 
 
  if params[:controller] == 'events' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :events.l, events_path 
 
  if params[:controller] == 'forums' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :forums.l, forums_path 
 
  if current_page?(popular_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :popular.l, popular_path 
 
  if current_page?(users_path) || (params[:controller] == 'users' && !@user.nil? && @user != current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :people.l, users_path 
 
 if @header_tabs.any? 
 for tab in @header_tabs 
 link_to tab.name, tab.url 
 end 
 end 
  if logged_in? 
 if current_user.unread_messages? 
 if params[:controller] == 'messages' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 user_messages_path(current_user) 
 current_user.unread_message_count 
 fa_icon "envelope inverse" 
 end 
 end 
 
  
 
 render_jumbotron 
 container_title 
  
  @page_title = :new_event.l 
  bootstrap_form_for(@event, :layout => :horizontal) do |f| 
 f.text_field :name 
 f.text_area :description, :rows => 10, :class => "rich_text_editor" 
 f.datetime_select :start_time 
 f.datetime_select :end_time 
 f.form_group :rsvp, :help => :when_checked_users_will_be_able_to_rsvp_for_this_event.l do 
 f.check_box :allow_rsvp 
 end 
 f.text_field :location 
 f.form_group :location_group, :label => {:text => :metro_area.l} do 
  :country.l 
 select_tag(:country_id, options_from_collection_for_select(Country.find_countries_with_metros, "id", "name", selected_country), {:include_blank => true, :class => "form-control"}) 
 :state.l 
 select_tag(:state_id, options_from_collection_for_select(states, "id", "name", (selected_state rescue nil)), {:disabled => states.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 :metro_area.l 
 select_tag(:metro_area_id, options_from_collection_for_select(metro_areas, "id", "name", (selected_metro_area rescue nil)), {:disabled => metro_areas.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 js ||= nil 
 if js 
 else 
  
 end 
 
 end 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 
 
  render_widgets 
 
 if show_footer_content? 
 image_tag 'spinner.gif', :plugin => 'community_engine' 
 :loading_recent_content.l 
 end 
  
 :community_tagline.l 
  javascript_include_tag 'community_engine' 
 tiny_mce_init_if_needed 
 if show_footer_content? 
 end 
 
  

end

  end

  def edit
    @event = Event.find(params[:id])
    @metro_areas, @states = setup_metro_area_choices_for(@event)
    @metro_area_id, @state_id, @country_id = setup_location_for(@event)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 home_url 
 csrf_meta_tag 
 page_title 
 if @meta 
 @meta.each do |key| 
 key[1] 
 key[0] 
 end 
 end 
 if @rss_title && @rss_url 
 auto_discovery_link_tag(:rss, @rss_url, {:title => @rss_title}) 
 end 
  stylesheet_link_tag 'community_engine' 
 if forum_page? 
 unless @feed_icons.blank? 
 @feed_icons.each do |feed| 
 auto_discovery_link_tag :rss, feed[:url], :title => "Subscribe to '#{feed[:title]}'" 
 end 
 end 
 end 
 yield :head_css 
 
 unless configatron.auth_providers.facebook.key.blank? 
  
 end 
  link_to configatron.community_name, home_path, :class => 'navbar-brand' 
  
  if current_page?(site_clippings_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :clippings.l, site_clippings_path 
 
  if params[:controller] == 'events' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :events.l, events_path 
 
  if params[:controller] == 'forums' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :forums.l, forums_path 
 
  if current_page?(popular_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :popular.l, popular_path 
 
  if current_page?(users_path) || (params[:controller] == 'users' && !@user.nil? && @user != current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :people.l, users_path 
 
 if @header_tabs.any? 
 for tab in @header_tabs 
 link_to tab.name, tab.url 
 end 
 end 
  if logged_in? 
 if current_user.unread_messages? 
 if params[:controller] == 'messages' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 user_messages_path(current_user) 
 current_user.unread_message_count 
 fa_icon "envelope inverse" 
 end 
 end 
 
  
 
 render_jumbotron 
 container_title 
  
  @page_title = :edit_event.l 
 link_to :back.l, events_path, :class => 'btn btn-default' 
 link_to :show.l, event_path(@event), :class => 'btn btn-primary' 
 link_to :clone.l, clone_event_path(@event), :class => 'btn btn-success' 
 link_to :delete.l, event_path(@event), data: { confirm: :are_you_sure.l }, :method => :delete, :class => 'btn btn-danger' 
  bootstrap_form_for(@event, :layout => :horizontal) do |f| 
 f.text_field :name 
 f.text_area :description, :rows => 10, :class => "rich_text_editor" 
 f.datetime_select :start_time 
 f.datetime_select :end_time 
 f.form_group :rsvp, :help => :when_checked_users_will_be_able_to_rsvp_for_this_event.l do 
 f.check_box :allow_rsvp 
 end 
 f.text_field :location 
 f.form_group :location_group, :label => {:text => :metro_area.l} do 
  :country.l 
 select_tag(:country_id, options_from_collection_for_select(Country.find_countries_with_metros, "id", "name", selected_country), {:include_blank => true, :class => "form-control"}) 
 :state.l 
 select_tag(:state_id, options_from_collection_for_select(states, "id", "name", (selected_state rescue nil)), {:disabled => states.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 :metro_area.l 
 select_tag(:metro_area_id, options_from_collection_for_select(metro_areas, "id", "name", (selected_metro_area rescue nil)), {:disabled => metro_areas.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 js ||= nil 
 if js 
 else 
  
 end 
 
 end 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 
 
  render_widgets 
 
 if show_footer_content? 
 image_tag 'spinner.gif', :plugin => 'community_engine' 
 :loading_recent_content.l 
 end 
  
 :community_tagline.l 
  javascript_include_tag 'community_engine' 
 tiny_mce_init_if_needed 
 if show_footer_content? 
 end 
 
  

end

  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if params[:metro_area_id]
      @event.metro_area = MetroArea.find(params[:metro_area_id])
    else
      @event.metro_area = nil
    end
    respond_to do |format|
      if @event.save
        flash[:notice] = :event_was_successfully_created.l

        format.html { redirect_to event_path(@event) }
      else
        format.html {
          @metro_areas, @states = setup_metro_area_choices_for(@event)
          if params[:metro_area_id]
            @metro_area_id = params[:metro_area_id].to_i
            @state_id = params[:state_id].to_i
            @country_id = params[:country_id].to_i
          end
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 home_url 
 csrf_meta_tag 
 page_title 
 if @meta 
 @meta.each do |key| 
 key[1] 
 key[0] 
 end 
 end 
 if @rss_title && @rss_url 
 auto_discovery_link_tag(:rss, @rss_url, {:title => @rss_title}) 
 end 
  stylesheet_link_tag 'community_engine' 
 if forum_page? 
 unless @feed_icons.blank? 
 @feed_icons.each do |feed| 
 auto_discovery_link_tag :rss, feed[:url], :title => "Subscribe to '#{feed[:title]}'" 
 end 
 end 
 end 
 yield :head_css 
 
 unless configatron.auth_providers.facebook.key.blank? 
  
 end 
  link_to configatron.community_name, home_path, :class => 'navbar-brand' 
  
  if current_page?(site_clippings_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :clippings.l, site_clippings_path 
 
  if params[:controller] == 'events' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :events.l, events_path 
 
  if params[:controller] == 'forums' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :forums.l, forums_path 
 
  if current_page?(popular_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :popular.l, popular_path 
 
  if current_page?(users_path) || (params[:controller] == 'users' && !@user.nil? && @user != current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :people.l, users_path 
 
 if @header_tabs.any? 
 for tab in @header_tabs 
 link_to tab.name, tab.url 
 end 
 end 
  if logged_in? 
 if current_user.unread_messages? 
 if params[:controller] == 'messages' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 user_messages_path(current_user) 
 current_user.unread_message_count 
 fa_icon "envelope inverse" 
 end 
 end 
 
  
 
 render_jumbotron 
 container_title 
  
  @page_title = :new_event.l 
  bootstrap_form_for(@event, :layout => :horizontal) do |f| 
 f.text_field :name 
 f.text_area :description, :rows => 10, :class => "rich_text_editor" 
 f.datetime_select :start_time 
 f.datetime_select :end_time 
 f.form_group :rsvp, :help => :when_checked_users_will_be_able_to_rsvp_for_this_event.l do 
 f.check_box :allow_rsvp 
 end 
 f.text_field :location 
 f.form_group :location_group, :label => {:text => :metro_area.l} do 
  :country.l 
 select_tag(:country_id, options_from_collection_for_select(Country.find_countries_with_metros, "id", "name", selected_country), {:include_blank => true, :class => "form-control"}) 
 :state.l 
 select_tag(:state_id, options_from_collection_for_select(states, "id", "name", (selected_state rescue nil)), {:disabled => states.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 :metro_area.l 
 select_tag(:metro_area_id, options_from_collection_for_select(metro_areas, "id", "name", (selected_metro_area rescue nil)), {:disabled => metro_areas.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 js ||= nil 
 if js 
 else 
  
 end 
 
 end 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 
 
  render_widgets 
 
 if show_footer_content? 
 image_tag 'spinner.gif', :plugin => 'community_engine' 
 :loading_recent_content.l 
 end 
  
 :community_tagline.l 
  javascript_include_tag 'community_engine' 
 tiny_mce_init_if_needed 
 if show_footer_content? 
 end 
 
  

end

        }
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    if params[:metro_area_id]
      @event.metro_area = MetroArea.find(params[:metro_area_id])
    else
      @event.metro_area = nil
    end

    respond_to do |format|
      if @event.update_attributes(event_params)
        format.html { redirect_to event_path(@event) }
      else
        format.html {
          @metro_areas, @states = setup_metro_area_choices_for(@event)
          if params[:metro_area_id]
            @metro_area_id = params[:metro_area_id].to_i
            @state_id = params[:state_id].to_i
            @country_id = params[:country_id].to_i
          end
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 home_url 
 csrf_meta_tag 
 page_title 
 if @meta 
 @meta.each do |key| 
 key[1] 
 key[0] 
 end 
 end 
 if @rss_title && @rss_url 
 auto_discovery_link_tag(:rss, @rss_url, {:title => @rss_title}) 
 end 
  stylesheet_link_tag 'community_engine' 
 if forum_page? 
 unless @feed_icons.blank? 
 @feed_icons.each do |feed| 
 auto_discovery_link_tag :rss, feed[:url], :title => "Subscribe to '#{feed[:title]}'" 
 end 
 end 
 end 
 yield :head_css 
 
 unless configatron.auth_providers.facebook.key.blank? 
  
 end 
  link_to configatron.community_name, home_path, :class => 'navbar-brand' 
  
  if current_page?(site_clippings_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :clippings.l, site_clippings_path 
 
  if params[:controller] == 'events' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :events.l, events_path 
 
  if params[:controller] == 'forums' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :forums.l, forums_path 
 
  if current_page?(popular_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :popular.l, popular_path 
 
  if current_page?(users_path) || (params[:controller] == 'users' && !@user.nil? && @user != current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :people.l, users_path 
 
 if @header_tabs.any? 
 for tab in @header_tabs 
 link_to tab.name, tab.url 
 end 
 end 
  if logged_in? 
 if current_user.unread_messages? 
 if params[:controller] == 'messages' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 user_messages_path(current_user) 
 current_user.unread_message_count 
 fa_icon "envelope inverse" 
 end 
 end 
 
  
 
 render_jumbotron 
 container_title 
  
  @page_title = :edit_event.l 
 link_to :back.l, events_path, :class => 'btn btn-default' 
 link_to :show.l, event_path(@event), :class => 'btn btn-primary' 
 link_to :clone.l, clone_event_path(@event), :class => 'btn btn-success' 
 link_to :delete.l, event_path(@event), data: { confirm: :are_you_sure.l }, :method => :delete, :class => 'btn btn-danger' 
  bootstrap_form_for(@event, :layout => :horizontal) do |f| 
 f.text_field :name 
 f.text_area :description, :rows => 10, :class => "rich_text_editor" 
 f.datetime_select :start_time 
 f.datetime_select :end_time 
 f.form_group :rsvp, :help => :when_checked_users_will_be_able_to_rsvp_for_this_event.l do 
 f.check_box :allow_rsvp 
 end 
 f.text_field :location 
 f.form_group :location_group, :label => {:text => :metro_area.l} do 
  :country.l 
 select_tag(:country_id, options_from_collection_for_select(Country.find_countries_with_metros, "id", "name", selected_country), {:include_blank => true, :class => "form-control"}) 
 :state.l 
 select_tag(:state_id, options_from_collection_for_select(states, "id", "name", (selected_state rescue nil)), {:disabled => states.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 :metro_area.l 
 select_tag(:metro_area_id, options_from_collection_for_select(metro_areas, "id", "name", (selected_metro_area rescue nil)), {:disabled => metro_areas.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 js ||= nil 
 if js 
 else 
  
 end 
 
 end 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 
 
  render_widgets 
 
 if show_footer_content? 
 image_tag 'spinner.gif', :plugin => 'community_engine' 
 :loading_recent_content.l 
 end 
  
 :community_tagline.l 
  javascript_include_tag 'community_engine' 
 tiny_mce_init_if_needed 
 if show_footer_content? 
 end 
 
  

end

        }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def clone
    @event = Event.find(params[:id]).clone
    @metro_areas, @states = setup_metro_area_choices_for(@event)
    @metro_area_id, @state_id, @country_id = setup_location_for(@event)
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 home_url 
 csrf_meta_tag 
 page_title 
 if @meta 
 @meta.each do |key| 
 key[1] 
 key[0] 
 end 
 end 
 if @rss_title && @rss_url 
 auto_discovery_link_tag(:rss, @rss_url, {:title => @rss_title}) 
 end 
  stylesheet_link_tag 'community_engine' 
 if forum_page? 
 unless @feed_icons.blank? 
 @feed_icons.each do |feed| 
 auto_discovery_link_tag :rss, feed[:url], :title => "Subscribe to '#{feed[:title]}'" 
 end 
 end 
 end 
 yield :head_css 
 
 unless configatron.auth_providers.facebook.key.blank? 
  
 end 
  link_to configatron.community_name, home_path, :class => 'navbar-brand' 
  
  if current_page?(site_clippings_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :clippings.l, site_clippings_path 
 
  if params[:controller] == 'events' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :events.l, events_path 
 
  if params[:controller] == 'forums' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :forums.l, forums_path 
 
  if current_page?(popular_path) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :popular.l, popular_path 
 
  if current_page?(users_path) || (params[:controller] == 'users' && !@user.nil? && @user != current_user) 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 link_to :people.l, users_path 
 
 if @header_tabs.any? 
 for tab in @header_tabs 
 link_to tab.name, tab.url 
 end 
 end 
  if logged_in? 
 if current_user.unread_messages? 
 if params[:controller] == 'messages' 
 css_class = 'active' 
 else 
 css_class = 'inactive' 
 end 
 css_class 
 user_messages_path(current_user) 
 current_user.unread_message_count 
 fa_icon "envelope inverse" 
 end 
 end 
 
  
 
 render_jumbotron 
 container_title 
  
  @page_title = :new_event.l 
  bootstrap_form_for(@event, :layout => :horizontal) do |f| 
 f.text_field :name 
 f.text_area :description, :rows => 10, :class => "rich_text_editor" 
 f.datetime_select :start_time 
 f.datetime_select :end_time 
 f.form_group :rsvp, :help => :when_checked_users_will_be_able_to_rsvp_for_this_event.l do 
 f.check_box :allow_rsvp 
 end 
 f.text_field :location 
 f.form_group :location_group, :label => {:text => :metro_area.l} do 
  :country.l 
 select_tag(:country_id, options_from_collection_for_select(Country.find_countries_with_metros, "id", "name", selected_country), {:include_blank => true, :class => "form-control"}) 
 :state.l 
 select_tag(:state_id, options_from_collection_for_select(states, "id", "name", (selected_state rescue nil)), {:disabled => states.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 :metro_area.l 
 select_tag(:metro_area_id, options_from_collection_for_select(metro_areas, "id", "name", (selected_metro_area rescue nil)), {:disabled => metro_areas.empty?, :class => "form-control" }) 
 ajax_spinner_for 'location_chooser' 
 js ||= nil 
 if js 
 else 
  
 end 
 
 end 
 f.form_group :submit_group do 
 f.primary :save.l 
 end 
 end 
 
  render_widgets 
 
 if show_footer_content? 
 image_tag 'spinner.gif', :plugin => 'community_engine' 
 :loading_recent_content.l 
 end 
  
 :community_tagline.l 
  javascript_include_tag 'community_engine' 
 tiny_mce_init_if_needed 
 if show_footer_content? 
 end 
 
  

end

  end

  protected

  def setup_metro_area_choices_for(object)
    metro_areas = states = []
    if object.metro_area
      if object.is_a? Event
        states = object.metro_area.country.states
        if object.metro_area.state
          metro_areas = object.metro_area.state.metro_areas.order("name")
        else
          metro_areas = object.metro_area.country.metro_areas.order("name")
        end
      elsif object.is_a? User
        states = object.country.states if object.country
        if object.state
          metro_areas = object.state.metro_areas.order("name")
        else
          metro_areas = object.country.metro_areas.order("name")
        end
      end
    end
    return metro_areas, states
  end

  def setup_location_for(object)
    metro_area_id = state_id = country_id = nil
    if object.metro_area
      metro_area_id = object.metro_area_id
      if object.is_a? Event
        state_id = object.metro_area.state_id
        country_id = object.metro_area.country_id
      elsif object.is_a? User
        state_id = object.state_id
        country_id = object.country_id
      end
    end
    return metro_area_id, state_id, country_id
  end

  def event_params
    params[:event].permit(:name, :start_time, :end_time, :description, :metro_area, :location, :allow_rsvp)
  end

end
