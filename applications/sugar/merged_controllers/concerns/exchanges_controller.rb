# encoding: utf-8

module ExchangesController
  extend ActiveSupport::Concern

  included do
    protect_from_forgery except: [:mark_as_read]
    respond_to :html, :mobile, :json
  end

  def search_posts
    @search_path = polymorphic_path([:search_posts, @exchange])
    @posts = Post.search_results(
      search_query,
      user: current_user,
      exchange: @exchange,
      page: params[:page]
    )
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_title = "\"#{@search_query}\" in " + @exchange.title

 if @posts 
 
  # Options
  discussion         ||= false
  functions          ||= false
  permalink          ||= false
  post_distance      ||= false
  title              ||= false
  new_posts_notifier ||= false
  no_pagination      ||= false
  no_container       ||= false

  previous_post = nil
  pagination_params ||= {}

 
  anchor ||= nil
  pagination_params ||= {}

 if p.total_pages > 1 
 link_to_unless((p.current_page == 1),
                           "First",
                           {
                             page: 1,
                             anchor: anchor
                           }.merge(pagination_params),
                           class: :first_page_link) 
 link_to_if(p.previous_page,
                       "Previous",
                       {
                         page: p.previous_page,
                         anchor: anchor
                       }.merge(pagination_params),
                       class: :prev_page_link) 
 link_to_if(p.next_page,
                       "Next",
                       {
                         page: p.next_page,
                         anchor: anchor
                       }.merge(pagination_params),
                       class: :next_page_link) 
 link_to_unless((p.current_page == p.total_pages),
                           "Last",
                           {
                             page: p.total_pages,
                             anchor: anchor
                           }.merge(pagination_params),
                           class: :last_page_link) 
 end 
 p.current_page 
 p.total_pages 
 
 unless no_container 
 end 
 posts.each do |post| 
 if posts.kind_of?(Paginatable::ClassMethods::WithContext) && posts.context? && posts.to_a.index(post) == 0 
 end 
 
  # Options
  posts              ||= false
  discussion         ||= false
  functions          ||= false
  permalink          ||= false
  post_distance      ||= false
  title              ||= false
  preview            ||= false

  previous_post      ||= nil

 if post_distance && previous_post 
 if (post.created_at - previous_post.created_at) >= 12.hours 
 distance_of_time_in_words(post.created_at, previous_post.created_at) 
 elsif (previous_post.created_at - post.created_at) >= 12.hours 
 distance_of_time_in_words(post.created_at, previous_post.created_at) 
 end 
 end 
 post.user.id 
 " me_post" if post.me_post? 
 post.user.id 
 post.exchange_id 
 post.exchange.type 
 post.id 
 post.id 
 if title 
 if post.exchange.labels? 
 post.exchange.labels.join(',') 
 end 
 link_to post.exchange.title, polymorphic_path(post.exchange, page: post.page, anchor: "post-#{post.id}") 
 profile_link(post.exchange.poster) 
 time_tag post.exchange.last_post_at, class: 'relative' 
 post.exchange.posts_count 
 end 
 if functions 
 end 
 if post.me_post? 
 avatar_image_tag(post.user) 
 post.id 
 format_post post.body, post.user 
 if preview 
 else 
 if permalink 
 link_to(polymorphic_path((discussion||post.exchange), page: post_page(post), anchor: "post-#{post.id}"), title: "Permalink to this post", class: "permalink") do 
 time_tag post.created_at, class: 'relative date' 
 end 
 else 
 time_tag post.created_at, class: 'relative date' 
 end 
 end 
 else 
 avatar_image_tag(post.user) 
 profile_link(post.user) 
 if preview 
 else 
 if permalink 
 link_to(polymorphic_path((discussion||post.exchange), page: post_page(post), anchor: "post-#{post.id}"), title: "Permalink to this post", class: "permalink") do 
 time_tag post.created_at, class: 'relative date' 
 end 
 else 
 time_tag post.created_at, class: 'relative date' 
 end 
 end 
 post.id 
 format_post(post.body_html, post.user) 
 if post.edited? 
 time_tag post.edited_at, class: 'relative' 
 end 
 end 
 
 previous_post = post 
 if posts.kind_of?(Paginatable::ClassMethods::WithContext) && posts.context? && posts.to_a.index(post) == (posts.context-1) 
 end 
 end 
 unless no_container 
 end 
 if new_posts_notifier 
 end 
 
  anchor ||= nil
  pagination_params ||= {}

 if p.total_pages > 1 
 link_to_unless((p.current_page == 1),
                           "First",
                           {
                             page: 1,
                             anchor: anchor
                           }.merge(pagination_params),
                           class: :first_page_link) 
 link_to_if(p.previous_page,
                       "Previous",
                       {
                         page: p.previous_page,
                         anchor: anchor
                       }.merge(pagination_params),
                       class: :prev_page_link) 
 link_to_if(p.next_page,
                       "Next",
                       {
                         page: p.next_page,
                         anchor: anchor
                       }.merge(pagination_params),
                       class: :next_page_link) 
 link_to_unless((p.current_page == p.total_pages),
                           "Last",
                           {
                             page: p.total_pages,
                             anchor: anchor
                           }.merge(pagination_params),
                           class: :last_page_link) 
 end 
 p.current_page 
 p.total_pages 
 
 
 else 
 end 

end

  end

  def show
    context = (request.format == :mobile) ? 0 : 3
    @page = params[:page] || 1
    @posts = @exchange.posts.page(@page, context: context).for_view

    mark_as_viewed!(
      @exchange,
      @posts.last,
      (@posts.offset_value + @posts.count)
    )

    respond_with(@exchange)
  end

  def edit
    @exchange.body = @exchange.posts.first.body
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_title = @exchange.title

 form_for(@exchange) do |f| 
  f.hidden_field :type 
 f.hidden_field(:format, class: "format") 
 if @recipient 
 hidden_field_tag :recipient_id, @recipient.id 
 end 
 f.labelled_text_field :title, class: "text title" 
 f.labelled_text_area :body, id: "compose-body", class: "rich", "data-format-binding" => ".format", "data-formats" => "markdown html", "data-remember-format" => @exchange.new_record? 
 f.labelled_check_box :nsfw 
 if @exchange.closeable_by?(current_user) 
 f.labelled_check_box :closed 
 end 
 if @exchange.kind_of?(Discussion) && current_user.moderator? 
 f.labelled_check_box :sticky 
 end 
 if @exchange.kind_of?(Discussion) && current_user.trusted? 
 f.labelled_check_box :trusted 
 end 
 
 end 

end

  end

  def update
    @exchange.update_attributes(exchange_params.merge(updated_by: current_user))
    if @exchange.valid?
      flash[:notice] = "Your changes were saved."
      redirect_to @exchange
    else
      flash.now[:notice] = "Could not save your discussion! " \
                           "Please make sure all required fields are filled in."
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|

  @page_title = @exchange.title

 form_for(@exchange) do |f| 
  f.hidden_field :type 
 f.hidden_field(:format, class: "format") 
 if @recipient 
 hidden_field_tag :recipient_id, @recipient.id 
 end 
 f.labelled_text_field :title, class: "text title" 
 f.labelled_text_area :body, id: "compose-body", class: "rich", "data-format-binding" => ".format", "data-formats" => "markdown html", "data-remember-format" => @exchange.new_record? 
 f.labelled_check_box :nsfw 
 if @exchange.closeable_by?(current_user) 
 f.labelled_check_box :closed 
 end 
 if @exchange.kind_of?(Discussion) && current_user.moderator? 
 f.labelled_check_box :sticky 
 end 
 if @exchange.kind_of?(Discussion) && current_user.trusted? 
 f.labelled_check_box :trusted 
 end 
 
 end 

end

    end
  end

  def mark_as_read
    mark_as_viewed!(
      @exchange,
      @exchange.posts.last,
      @exchange.posts_count
    )
    render layout: false, text: "OK" if request.xhr?
  end

  protected

  def mark_as_viewed!(exchange, last_post, count)
    return unless current_user?
    current_user.mark_exchange_viewed(exchange, last_post, count)
  end

  def verify_editable
    render_error 403 unless @exchange.editable_by?(current_user)
  end

  def search_query
    params[:query] || params[:q]
  end

  def require_and_set_search_query
    @search_query = search_query
    return if @search_query
    flash[:notice] = "No query specified!"
    redirect_to root_url
  end
end
