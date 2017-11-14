class TopicsController < BaseController
  before_action :find_forum_and_topic, :except => :index
  before_action :login_required, :except => [:index, :show]

  uses_tiny_mce do
    {:only => [:show, :new, :create, :update], :options => configatron.default_mce_options}
  end

  def index
    @forum = Forum.find(params[:forum_id])
    respond_to do |format|
      format.html { redirect_to forum_path(params[:forum_id]) }
      format.xml do
        @topics = @forum.topics.order('sticky desc, replied_at desc').limit(25)
        render :xml => @topics.to_xml
      end
    end
  end

  def new
    @topic = Topic.new
    @topic.sb_posts.build
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
  
  @page_title= :new_topic.l 
 :by.l :login => current_user.display_name 
 link_to :back.l, @forum, :class => 'btn btn-default' 
  if @topic.new_record? 
 url = forum_topics_path(@forum) 
 object = @topic 
 else 
 url = forum_topic_path(@forum, @topic) 
 object = [@forum, @topic] 
 end 
 bootstrap_form_for object, :url => url, :layout => :horizontal do |f| 
 f.text_field :title 
 if admin? or current_user.moderator_of?(@topic.forum) 
 f.form_group :options_group do 
 f.check_box :sticky 
 f.check_box :locked 
 end 
 end 
 f.text_field :tag_list, :autocomplete => "off", :label => :tags.l, :help => :optional_keywords_describing_this_topic_separated_by_commas.l 
  
 if @topic.new_record? 
 f.fields_for :sb_posts do |x| 
 x.text_area :body, :rows => 12, :class => 'rich_text_editor', :label => :body_text.l, :required => false 
 end 
 end 
 if admin? and not @topic.new_record? 
 f.select :forum_id, Forum.order("position ASC").map {|x| [x.name, x.id] }, :label => :forum.l 
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
 
 tag_auto_complete_field 'topic_tag_list', {:url => { :controller => "tags", :action => 'auto_complete_for_tag_name'}, :tokens => [','] } 

end

  end

  def show
    respond_to do |format|
      format.html do
        # see notes in base_controller.rb on how this works
        current_user.update_last_seen_at if logged_in?
        # keep track of when we last viewed this topic for activity indicators
        (session[:topics] ||= {})[@topic.id] = Time.now.utc if logged_in?
        # authors of topics don't get counted towards total hits
        @topic.hit! unless logged_in? and @topic.user == current_user

        @posts = @topic.sb_posts.recent.includes(:user).page(params[:page]).per(25)

        @voices = @posts.map(&:user).compact.uniq
        @post   = SbPost.new(params[:post])
      end
      format.xml do
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
  
  @meta = { :description => "#{@topic.title.capitalize} discussion.",:keywords => "#{@topic.tags.join(', ') if @topic.tags}", :robots => configatron.robots_meta_show_content} 
 @section = 'forums' 
 @page_title = @topic.title 
 @monitoring = logged_in? && current_user.monitoring_topic?(@topic) 
  
 widget do 
 if logged_in? 
 bootstrap_form_tag :url => forum_topic_monitorship_path(@forum, @topic) do 
 @monitoring 
 @monitoring ? :watching_topic.l : :watch_topic.l 
 submit_tag :save.l, :id => 'monitor_submit', :style => "display:none" 
 end 
 end 
 end 
 if @topic.locked? 
 :locked2.l 
 end 
 if logged_in? && @topic.editable_by?(current_user) 
 link_to :back.l, @forum, :class => 'btn btn-default' 
 link_to :edit.l, edit_forum_topic_path(@forum, @topic), :class => "btn btn-warning" 
 link_to :delete.l, forum_topic_path(@forum, @topic), :class => "btn btn-danger", :method => :delete, data: { confirm: :delete_this_topic_forever.l } 
 end 
 forum_topic_path(@forum, @topic, :format => :rss) 
 fa_icon "rss" 
 "#{pluralize @topic.sb_posts.count, :post.l}, #{pluralize @topic.voices, :voice.l}" 
 if @topic.tags.any? 
 :tags.l 
 raw @topic.tags.collect{|t| link_to( h(t.name), tag_url(t), :class => 'tag').html_safe }.join(" ") 
 end 
 :voices.l 
 @voices.each do |user| 
 link_to h(user.display_name), user_path(user) 
 end 
 @posts.to_a.first.dom_id 
 for post in @posts do 
  post.id 
 if logged_in? 
 link_to fa_icon("comment"), new_forum_topic_sb_post_path(post.topic.forum, post.topic), :class => 'reply-toggle' 
 end 
 post.body.html_safe 
 if post.user 
 link_to avatar_for(post.user), post.user 
 link_to truncate(h(post.username), :length => 15), user_path(post.user), :class => (post.topic.editable_by?(post.user) ? "admin" : nil) 
 :post.l.pluralize 
 post.user.sb_posts_count 
 else 
 image_tag(configatron.photo.missing_thumb, :class => 'thumbnail') 
 truncate(h(post.username), :length => 15) 
 end 
 post.dom_id 
 post.created_at.xmlschema 
 time_ago_in_words(post.created_at) 
 if logged_in? && post.editable_by?(current_user) 
 ajax_spinner_for "edit-post-#{post.id}" 
 link_to :edit_post.l, edit_forum_topic_sb_post_path(@forum, @topic, post), :class => 'edit-via-ajax', :id => "edit-post-#{post.id}" 
 end 
 if admin? && post.user && !post.user.admin? 
 post.user_id 
  if !user.moderator_of?(forum) 
 link_to :make_moderator.l, forum_moderators_path(:forum_id => forum.id, :user_id => user.id), :method => :post, :class => 'act-via-ajax', :id => 'moderator-'+user.id.to_s 
 else 
 moderatorship = Moderatorship.find_by_user_id_and_forum_id(user.id, forum.id) 
 link_to :remove_moderator.l, forum_moderator_path(forum, moderatorship.id), :method => :delete, :class => 'act-via-ajax', :id => 'moderator-'+user.id.to_s 
 end 
 
 end 
end 
 paginate @posts, :theme => 'bootstrap' 
 if logged_in? || configatron.allow_anonymous_forum_posting 
 if @topic.locked? 
 fa_icon "lock" 
 :this_topic_is_locked.l 
 else 
 link_to fa_icon("plus", :text => :reply_to_topic.l), new_forum_topic_sb_post_path(@topic.forum, @topic), :class => 'reply-toggle' 
  bootstrap_form_for @post, :url => sb_posts_path(:forum_id => @forum, :topic_id => @topic, :page => @topic.last_page), :layout => :horizontal, :html => {:class => "submit-via-ajax", :id => "reply"} do |f| 
 f.text_area :body, :rows => 10, :style => "width: 99%;", :class => "rich_text_editor", :required => false 
 if !logged_in? && configatron.recaptcha_pub_key && configatron.recaptcha_priv_key 
 f.text_field :author_name 
 f.text_field :author_email, :required => true 
 f.text_field :author_url, :label => :comment_web_site_label.l 
 f.form_group do 
 recaptcha_tags :ajax => true 
 end 
 end 
 f.form_group do 
 ajax_spinner_for "reply" 
 f.primary :save_reply.l 
 :or.l 
 link_to :cancel.l, '#', :class => 'reply-toggle btn btn-default' 
 end 
 end 
 
 end 
 else 
 link_to :log_in_to_reply_to_this_topic.l, new_forum_topic_sb_post_path(@topic.forum, @topic) 
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
 
 javascript_include_tag 'forum' 

end

      end
      format.rss do
        @posts = @topic.sb_posts.recent.limit(25)
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @meta = { :description => "#{@topic.title.capitalize} discussion.",:keywords => "#{@topic.tags.join(', ') if @topic.tags}", :robots => configatron.robots_meta_show_content} 
 @section = 'forums' 
 @page_title = @topic.title 
 @monitoring = logged_in? && current_user.monitoring_topic?(@topic) 
 content_for :end_javascript do 
 javascript_include_tag 'forum' 
 end 
 widget do 
 if logged_in? 
 bootstrap_form_tag :url => forum_topic_monitorship_path(@forum, @topic) do 
 @monitoring 
 @monitoring ? :watching_topic.l : :watch_topic.l 
 submit_tag :save.l, :id => 'monitor_submit', :style => "display:none" 
 end 
 end 
 end 
 if @topic.locked? 
 :locked2.l 
 end 
 if logged_in? && @topic.editable_by?(current_user) 
 link_to :back.l, @forum, :class => 'btn btn-default' 
 link_to :edit.l, edit_forum_topic_path(@forum, @topic), :class => "btn btn-warning" 
 link_to :delete.l, forum_topic_path(@forum, @topic), :class => "btn btn-danger", :method => :delete, data: { confirm: :delete_this_topic_forever.l } 
 end 
 forum_topic_path(@forum, @topic, :format => :rss) 
 fa_icon "rss" 
 "#{pluralize @topic.sb_posts.count, :post.l}, #{pluralize @topic.voices, :voice.l}" 
 if @topic.tags.any? 
 :tags.l 
 raw @topic.tags.collect{|t| link_to( h(t.name), tag_url(t), :class => 'tag').html_safe }.join(" ") 
 end 
 :voices.l 
 @voices.each do |user| 
 link_to h(user.display_name), user_path(user) 
 end 
 @posts.to_a.first.dom_id 
 for post in @posts do 
  post.id 
 if logged_in? 
 link_to fa_icon("comment"), new_forum_topic_sb_post_path(post.topic.forum, post.topic), :class => 'reply-toggle' 
 end 
 post.body.html_safe 
 if post.user 
 link_to avatar_for(post.user), post.user 
 link_to truncate(h(post.username), :length => 15), user_path(post.user), :class => (post.topic.editable_by?(post.user) ? "admin" : nil) 
 :post.l.pluralize 
 post.user.sb_posts_count 
 else 
 image_tag(configatron.photo.missing_thumb, :class => 'thumbnail') 
 truncate(h(post.username), :length => 15) 
 end 
 post.dom_id 
 post.created_at.xmlschema 
 time_ago_in_words(post.created_at) 
 if logged_in? && post.editable_by?(current_user) 
 ajax_spinner_for "edit-post-#{post.id}" 
 link_to :edit_post.l, edit_forum_topic_sb_post_path(@forum, @topic, post), :class => 'edit-via-ajax', :id => "edit-post-#{post.id}" 
 end 
 if admin? && post.user && !post.user.admin? 
 post.user_id 
  if !user.moderator_of?(forum) 
 link_to :make_moderator.l, forum_moderators_path(:forum_id => forum.id, :user_id => user.id), :method => :post, :class => 'act-via-ajax', :id => 'moderator-'+user.id.to_s 
 else 
 moderatorship = Moderatorship.find_by_user_id_and_forum_id(user.id, forum.id) 
 link_to :remove_moderator.l, forum_moderator_path(forum, moderatorship.id), :method => :delete, :class => 'act-via-ajax', :id => 'moderator-'+user.id.to_s 
 end 
 
 end 
end 
 paginate @posts, :theme => 'bootstrap' 
 if logged_in? || configatron.allow_anonymous_forum_posting 
 if @topic.locked? 
 fa_icon "lock" 
 :this_topic_is_locked.l 
 else 
 link_to fa_icon("plus", :text => :reply_to_topic.l), new_forum_topic_sb_post_path(@topic.forum, @topic), :class => 'reply-toggle' 
  bootstrap_form_for @post, :url => sb_posts_path(:forum_id => @forum, :topic_id => @topic, :page => @topic.last_page), :layout => :horizontal, :html => {:class => "submit-via-ajax", :id => "reply"} do |f| 
 f.text_area :body, :rows => 10, :style => "width: 99%;", :class => "rich_text_editor", :required => false 
 if !logged_in? && configatron.recaptcha_pub_key && configatron.recaptcha_priv_key 
 f.text_field :author_name 
 f.text_field :author_email, :required => true 
 f.text_field :author_url, :label => :comment_web_site_label.l 
 f.form_group do 
 recaptcha_tags :ajax => true 
 end 
 end 
 f.form_group do 
 ajax_spinner_for "reply" 
 f.primary :save_reply.l 
 :or.l 
 link_to :cancel.l, '#', :class => 'reply-toggle btn btn-default' 
 end 
 end 
 
 end 
 else 
 link_to :log_in_to_reply_to_this_topic.l, new_forum_topic_sb_post_path(@topic.forum, @topic) 
 end 

end

      end
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
  
  @meta = { :description => "#{@topic.title.capitalize} discussion.",:keywords => "#{@topic.tags.join(', ') if @topic.tags}", :robots => configatron.robots_meta_show_content} 
 @section = 'forums' 
 @page_title = @topic.title 
 @monitoring = logged_in? && current_user.monitoring_topic?(@topic) 
  
 widget do 
 if logged_in? 
 bootstrap_form_tag :url => forum_topic_monitorship_path(@forum, @topic) do 
 @monitoring 
 @monitoring ? :watching_topic.l : :watch_topic.l 
 submit_tag :save.l, :id => 'monitor_submit', :style => "display:none" 
 end 
 end 
 end 
 if @topic.locked? 
 :locked2.l 
 end 
 if logged_in? && @topic.editable_by?(current_user) 
 link_to :back.l, @forum, :class => 'btn btn-default' 
 link_to :edit.l, edit_forum_topic_path(@forum, @topic), :class => "btn btn-warning" 
 link_to :delete.l, forum_topic_path(@forum, @topic), :class => "btn btn-danger", :method => :delete, data: { confirm: :delete_this_topic_forever.l } 
 end 
 forum_topic_path(@forum, @topic, :format => :rss) 
 fa_icon "rss" 
 "#{pluralize @topic.sb_posts.count, :post.l}, #{pluralize @topic.voices, :voice.l}" 
 if @topic.tags.any? 
 :tags.l 
 raw @topic.tags.collect{|t| link_to( h(t.name), tag_url(t), :class => 'tag').html_safe }.join(" ") 
 end 
 :voices.l 
 @voices.each do |user| 
 link_to h(user.display_name), user_path(user) 
 end 
 @posts.to_a.first.dom_id 
 for post in @posts do 
  post.id 
 if logged_in? 
 link_to fa_icon("comment"), new_forum_topic_sb_post_path(post.topic.forum, post.topic), :class => 'reply-toggle' 
 end 
 post.body.html_safe 
 if post.user 
 link_to avatar_for(post.user), post.user 
 link_to truncate(h(post.username), :length => 15), user_path(post.user), :class => (post.topic.editable_by?(post.user) ? "admin" : nil) 
 :post.l.pluralize 
 post.user.sb_posts_count 
 else 
 image_tag(configatron.photo.missing_thumb, :class => 'thumbnail') 
 truncate(h(post.username), :length => 15) 
 end 
 post.dom_id 
 post.created_at.xmlschema 
 time_ago_in_words(post.created_at) 
 if logged_in? && post.editable_by?(current_user) 
 ajax_spinner_for "edit-post-#{post.id}" 
 link_to :edit_post.l, edit_forum_topic_sb_post_path(@forum, @topic, post), :class => 'edit-via-ajax', :id => "edit-post-#{post.id}" 
 end 
 if admin? && post.user && !post.user.admin? 
 post.user_id 
  if !user.moderator_of?(forum) 
 link_to :make_moderator.l, forum_moderators_path(:forum_id => forum.id, :user_id => user.id), :method => :post, :class => 'act-via-ajax', :id => 'moderator-'+user.id.to_s 
 else 
 moderatorship = Moderatorship.find_by_user_id_and_forum_id(user.id, forum.id) 
 link_to :remove_moderator.l, forum_moderator_path(forum, moderatorship.id), :method => :delete, :class => 'act-via-ajax', :id => 'moderator-'+user.id.to_s 
 end 
 
 end 
end 
 paginate @posts, :theme => 'bootstrap' 
 if logged_in? || configatron.allow_anonymous_forum_posting 
 if @topic.locked? 
 fa_icon "lock" 
 :this_topic_is_locked.l 
 else 
 link_to fa_icon("plus", :text => :reply_to_topic.l), new_forum_topic_sb_post_path(@topic.forum, @topic), :class => 'reply-toggle' 
  bootstrap_form_for @post, :url => sb_posts_path(:forum_id => @forum, :topic_id => @topic, :page => @topic.last_page), :layout => :horizontal, :html => {:class => "submit-via-ajax", :id => "reply"} do |f| 
 f.text_area :body, :rows => 10, :style => "width: 99%;", :class => "rich_text_editor", :required => false 
 if !logged_in? && configatron.recaptcha_pub_key && configatron.recaptcha_priv_key 
 f.text_field :author_name 
 f.text_field :author_email, :required => true 
 f.text_field :author_url, :label => :comment_web_site_label.l 
 f.form_group do 
 recaptcha_tags :ajax => true 
 end 
 end 
 f.form_group do 
 ajax_spinner_for "reply" 
 f.primary :save_reply.l 
 :or.l 
 link_to :cancel.l, '#', :class => 'reply-toggle btn btn-default' 
 end 
 end 
 
 end 
 else 
 link_to :log_in_to_reply_to_this_topic.l, new_forum_topic_sb_post_path(@topic.forum, @topic) 
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
 
 javascript_include_tag 'forum' 

end

  end

  def create
    @topic = @forum.topics.new(topic_params)
    assign_protected

    @post = @topic.sb_posts.first
    if (!@post.nil?)
      @post.user = current_user
    end

    @topic.tag_list = params[:tag_list] || ''

    if !@topic.save
      respond_to do |format|
        format.html {
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
  
  @page_title= :new_topic.l 
 :by.l :login => current_user.display_name 
 link_to :back.l, @forum, :class => 'btn btn-default' 
  if @topic.new_record? 
 url = forum_topics_path(@forum) 
 object = @topic 
 else 
 url = forum_topic_path(@forum, @topic) 
 object = [@forum, @topic] 
 end 
 bootstrap_form_for object, :url => url, :layout => :horizontal do |f| 
 f.text_field :title 
 if admin? or current_user.moderator_of?(@topic.forum) 
 f.form_group :options_group do 
 f.check_box :sticky 
 f.check_box :locked 
 end 
 end 
 f.text_field :tag_list, :autocomplete => "off", :label => :tags.l, :help => :optional_keywords_describing_this_topic_separated_by_commas.l 
  
 if @topic.new_record? 
 f.fields_for :sb_posts do |x| 
 x.text_area :body, :rows => 12, :class => 'rich_text_editor', :label => :body_text.l, :required => false 
 end 
 end 
 if admin? and not @topic.new_record? 
 f.select :forum_id, Forum.order("position ASC").map {|x| [x.name, x.id] }, :label => :forum.l 
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
 
 tag_auto_complete_field 'topic_tag_list', {:url => { :controller => "tags", :action => 'auto_complete_for_tag_name'}, :tokens => [','] } 

end

        }
      end
    else
      respond_to do |format|
        format.html {
          redirect_to forum_topic_path(@forum, @topic)
        }
        format.xml  {
          head :created, :location => forum_topic_url(:forum_id => @forum, :id => @topic, :format => :xml)
        }
      end
    end
  end

  def update
    assign_protected
    @topic.tag_list = params[:tag_list] || ''
    @topic.update_attributes!(topic_params)
    respond_to do |format|
      format.html { redirect_to forum_topic_path(@forum, @topic) }
      format.xml  { head 200 }
    end
  end

  def destroy
    @topic.destroy
    flash[:notice] = :topic_deleted.l_with_args(:topic => CGI::escapeHTML(@topic.title))
    respond_to do |format|
      format.html { redirect_to forum_path(@forum) }
      format.xml  { head 200 }
    end
  end

  protected
    def assign_protected
      @topic.sticky = @topic.locked = 0
      @topic.forum_id = @forum.id
      @topic.user = current_user if @topic.new_record?

      # admins and moderators can sticky and lock topics
      return unless admin? or current_user.moderator_of?(@topic.forum)
      @topic.sticky, @topic.locked = topic_params[:sticky], topic_params[:locked]
      # only admins can move
      return unless admin?
      @topic.forum_id = topic_params[:forum_id] if topic_params[:forum_id]
    end

    def find_forum_and_topic
      @forum = Forum.find(params[:forum_id])
      @topic = @forum.topics.find(params[:id]) if params[:id]
    end

    #overide in your app
    def authorized?
      %w(new create).include?(action_name) || @topic.editable_by?(current_user)
    end

  def topic_params
    params[:topic].permit(:title, :sticky, :locked, {:sb_posts_attributes => [:body]}, :forum_id)
  end
end
