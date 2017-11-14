class VotesController < BaseController
  before_action :find_choice, :only => [:create]
  before_action :login_required
  
  def new
    @post = Post.find(params[:post_id])
    redirect_to user_post_path(@post.user, @post)
  end
  
  def create
    @vote = @choice.votes.new(:user => current_user, :poll => @choice.poll )
    
    @vote.save
    respond_to do |format|
      format.js
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
  
  if @vote.valid? 
 @choice.poll.id.to_s 
 ( has_voted = logged_in? && poll.voted?(current_user) 
 poll.question 
 :total_votes.l 
 poll.votes.size 
 poll.choices.each do |choice| 
 if @is_current_user || has_voted 
 choice.votes_percentage 
 choice.votes_percentage 
 else 
 if logged_in? && !has_voted 
 link_to :vote.l, votes_path(:choice_id => choice), :method => :post, :class => 'act-via-ajax' 
 elsif !logged_in? 
 link_to :vote.l, new_vote_path(:post_id => poll.post.id), {:title => :log_in_to_vote.l, :class => 'vote'} 
 end 
 end 
 choice.description 
 end 
 if !has_voted 
 :you_must_vote_to_see_the_results.l 
 elsif logged_in? 
 :you_have_already_voted.l 
 end 
).gsub('"', '\\"').gsub("\n", "").html_safe 
 else 
 @vote.errors.full_messages.join(', ') 
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
 
 yield :end_javascript 

end

  end
  
  protected
  
  def find_choice
    @choice = Choice.find(params[:choice_id])    
  end
end
