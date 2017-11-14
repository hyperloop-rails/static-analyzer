class PostsController < ApplicationController
  def index
    @tag = params[:tag]
    @posts = Post.find_recent(:tag => @tag, :include => :tags)

    raise(ActiveRecord::RecordNotFound) if @tag && @posts.empty?

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 html_title yield(:page_title) 
 csrf_meta_tag 
 stylesheet_link_tag 'application' 
 javascript_include_tag 'application' 
 open_id_delegation_link_tags(enki_config[:open_id_delegation, :server], enki_config[:open_id_delegation, :delegate]) if enki_config[:open_id_delegation] 
 yield(:head) 
 root_url 
 enki_config[:title] 
 content_for :page_title do 
 posts_title(@tag) 
 end 
 content_for :head do 
 auto_discovery_link_tag(:atom, @tag.nil? ? formatted_posts_path(:format => 'atom') : posts_path(:tag => @tag, :format => 'atom')) 
 end 
 if @posts.empty? 
 else 
 @posts.each do |post| 
 dom_id(post) 
  link_to_post(post) 
 raw(post.body_html) 
 format_post_date(post.published_at) if post.published? 
 link_to_post_comments post 
 unless post.tags.empty? 
 linked_tag_list(post.tags) 
 end 
 
 end 
 if more_content? 
 link_to 'archives', archives_path 
 end 
 end 
 page_links_for_navigation.each do |link| 
 link_to(link.name, link.url) 
 end 
 unless category_links_for_navigation.empty? 
 category_links_for_navigation.each do |link| 
 link_to(link.name, link.url) 
 end 
 end 
 enki_config[:url] 
 enki_config[:title] 
 enki_config[:author, :name] 
 link_to "ATOM", "http://feedvalidator.org/check.cgi?url=#{enki_config[:url]}/posts.atom" 

end

  end

  def show
    @post = Post.find_by_permalink(*([:year, :month, :day, :slug].collect {|x| params[x] } << {:include => [:approved_comments, :tags]}))
    @comment = Comment.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 html_title yield(:page_title) 
 csrf_meta_tag 
 stylesheet_link_tag 'application' 
 javascript_include_tag 'application' 
 open_id_delegation_link_tags(enki_config[:open_id_delegation, :server], enki_config[:open_id_delegation, :delegate]) if enki_config[:open_id_delegation] 
 yield(:head) 
 root_url 
 enki_config[:title] 
 content_for :page_title do 
 post_title @post 
 end 
  link_to_post(post) 
 raw(post.body_html) 
 format_post_date(post.published_at) if post.published? 
 link_to_post_comments post 
 unless post.tags.empty? 
 linked_tag_list(post.tags) 
 end 
 
 @post.approved_comments.each do |comment| 
raw cycle(' class="alt"', '') 
 comment.id 
  author_link(comment) 
 comment.id 
 format_comment_date(comment.created_at) 
 raw(comment.body_html) 
 
 end 
 link_to 'archives', archives_path 
 unless @comment.errors.empty? 
 @comment.errors.sort_by(&:first).each do |error| 
 format_comment_error(error) 
 end 
 end 
 form_for [@post, @comment], :url => post_comments_path(@post, @comment) do |form| 
 form.text_field 'author' 
 form.label :author 
 link_to 'OpenID', 'http://openidexplained.com/' 
 form.text_area 'body' 
 link_to 'lesstile enabled', 'http://lesstile.rubyforge.org' 
 form.submit 'Add Comment' 
 end 
 page_links_for_navigation.each do |link| 
 link_to(link.name, link.url) 
 end 
 unless category_links_for_navigation.empty? 
 category_links_for_navigation.each do |link| 
 link_to(link.name, link.url) 
 end 
 end 
 enki_config[:url] 
 enki_config[:title] 
 enki_config[:author, :name] 
 link_to "ATOM", "http://feedvalidator.org/check.cgi?url=#{enki_config[:url]}/posts.atom" 

end

  end
end
