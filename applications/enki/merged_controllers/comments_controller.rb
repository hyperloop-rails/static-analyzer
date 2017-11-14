class CommentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  before_filter :verify_authenticity_token_unless_using_openid, :only => :create

  include UrlHelper

  before_filter :find_post, :except => [:new]

  def index
    redirect_to(post_path(@post))
  end

  def new
    @comment = Comment.build_for_preview(comment_params)

    respond_to do |format|
      format.js do
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 html_title yield(:page_title) 
 csrf_meta_tag 
 stylesheet_link_tag 'application' 
 javascript_include_tag 'application' 
 open_id_delegation_link_tags(enki_config[:open_id_delegation, :server], enki_config[:open_id_delegation, :delegate]) if enki_config[:open_id_delegation] 
 yield(:head) 
 root_url 
 enki_config[:title] 
 author_link(comment) 
 comment.id 
 format_comment_date(comment.created_at) 
 raw(comment.body_html) 
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
  end

  # TODO: Spec OpenID with cucumber and rack-my-id
  def create
    @comment = Comment.new((session[:pending_comment] || comment_params || {}).
      reject { |key, value| !Comment.protected_attribute?(key) })

    @comment.post = @post

    if !@comment.requires_openid_authentication?
      @comment.blank_openid_fields
      save_comment_or_show_error
    else
      if request.env['omniauth.auth'].nil? && params[:message].blank? # Begin auth.
        session[:pending_comment] = comment_params
        session[:post_id] = @post.id
        redirect_to auth_path(:open_id_comment, "openid_url=#{@comment.author}")
      elsif request.env['omniauth.auth'].persent? # Process success response.
        @comment.author_url = request.env['omniauth.auth'][:uid]
        @comment.author = request.env['omniauth.auth'][:info][:name]
        @comment.author_email = request.env['omniauth.auth'][:info][:email] || ''
        @comment.openid_error = ''
        save_comment_or_show_error
      else # Process error response.
        @comment.openid_error = params[:message]
        save_comment_or_show_error
      end
    end
  end

  private

  def save_comment_or_show_error
    if @comment.save
      session[:pending_comment] = nil
      session[:post_id] = nil
      redirect_to post_path(@post)
    else
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

  def comment_params
    params.require(:comment).permit(:author, :body)
  end

  protected

  def find_post
    @post = Post.find_by_permalink(*[:year, :month, :day, :slug].map {|x|
      params[x]
    })

    rescue ActiveRecord::RecordNotFound
      @post = Post.find(session[:post_id])
  end

  def verify_authenticity_token_unless_using_openid
    verify_authenticity_token unless using_open_id?
  end

  def using_open_id?
    if request.env['omniauth.auth'].present? &&
       request.env['omniauth.auth'][:provider] == OMNIAUTH_OPEN_ID_COMMENT_STRATEGY
      return true
    end

    return false
  end
end
