class Admin::DashboardController < Admin::BaseController
  def show
    @posts            = Post.find_recent(:limit => 8)
    @comment_activity = CommentActivity.find_recent
    @stats            = Stats.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 enki_config[:title] 
 csrf_meta_tag 
 javascript_include_tag 'admin' 
 stylesheet_link_tag 'admin' 
 yield(:head) 
 if flash[:notice] 
 javascript_tag do 
 escape_javascript(flash[:notice]) 
 end 
 end 
 link_to(enki_config[:title], '/') 
 pluralize(@stats.post_count, 'post') 
 pluralize(@stats.comment_count, 'comment') 
 pluralize(@stats.tag_count, 'tag') 
 @posts.each_with_index do |post, i| 
 i == 0 ? 'first ' : '' 
 link_to(truncate(post.title, :length => 50), admin_post_path(post)) 
 post.published_at.strftime("%b %e") 
 link_to(post.approved_comments.size, post_path(post)) 
 end 
 @comment_activity.each_with_index do |activity, i| 
 i == 0 ? 'first ' : '' 
 link_to_post(activity.post, truncate(activity.post.title, :length => 50)) 
 activity.most_recent_comment.created_at.strftime("%b %e") 
 activity.post.approved_comments.size 
 activity.comments.each_with_index do |comment, index| 
 content_tag :li, :class => activity.comments.size == index + 1 ? 'last' : nil do 
 link_to(comment.author, admin_comment_path(comment), {:id => "comment-link-#{comment.id}", :class => 'comment-link'}) 
 end 
 end 
 activity.comments.each do |comment| 
 comment.id 
 link_to(image_tag('silk/pencil.png', :alt => 'edit'), admin_comment_path(comment)) 
 form_for(comment, :as => :comment, :url => admin_comment_path(comment), :html => {:class => 'delete-item', :id => "delete-comment-#{comment.id}", :method => :delete}) do |form| 
 image_submit_tag("silk/delete.png", :alt => 'Delete Comment') 
 end 
 comment.body_html 
 end 
 end 
 nav_link_to("Dashboard", admin_root_path,       :accesskey => '1') 
 nav_link_to("Posts",     admin_posts_path,      :accesskey => '2') 
 nav_link_to("(+)", new_admin_post_path, :accesskey => 'n') 
 nav_link_to("Pages",     admin_pages_path,      :accesskey => '3') 
 nav_link_to("(+)", new_admin_page_path, :accesskey => 'p') 
 nav_link_to("Comments",  admin_comments_path,   :accesskey => '4') 
 nav_link_to("Actions",   admin_undo_items_path, :accesskey => '5') 
 nav_link_to("Health",    admin_health_path,     :accesskey => '6') 
 link_to("Logout", admin_session_path, :accesskey => 'l', :method => :delete) 
 link_to("View Site", root_path,       :accesskey => 'v', :title => 'View Site') 

end

  end
end
