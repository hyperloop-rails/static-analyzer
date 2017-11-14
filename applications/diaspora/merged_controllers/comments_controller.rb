#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class CommentsController < ApplicationController
  before_action :authenticate_user!, except: :index

  respond_to :html, :mobile, :json

  rescue_from ActiveRecord::RecordNotFound do
    render nothing: true, status: 404
  end

  def create
    @comment = CommentService.new(post_id: params[:post_id], text: params[:text], user: current_user).create_comment
    if @comment
      respond_create_success
    else
      render nothing: true, status: 404
    end
  end

  def destroy
    service = CommentService.new(comment_id: params[:id], user: current_user)
    if service.destroy_comment
      respond_destroy_success
    else
      respond_destroy_error
    end
  end

  def new
    respond_to do |format|
      format.mobile { render layout: false }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 og_prefix 
 page_title yield(:page_title) 
  if @post.present? 
 og_page_post_tags(@post) 
 else 
 og_general_tags 
 end 
 
 chartbeat_head_block 
 include_mixpanel 
 include_color_theme 
 if rtl? 
 stylesheet_link_tag :rtl, media:  'all' 
 end 
 old_browser_js_support 
 javascript_include_tag :ie 
 jquery_include_tag 
 unless @landing_page 
 javascript_include_tag :main, :templates 
 load_javascript_locales 
 end 
 translation_missing_warnings 
 current_user_atom_tag 
 yield(:head) 
 csrf_meta_tag 
 include_gon(camel_case:  true) 
 yield :before_content 
 
  link_to "#", class: "back_to_stream_element_top pull-right" do 
 image_tag "mobile/arrow_up_small.png" 
 end 
 if user_signed_in? 
 form_tag( post_comments_path(post_id), id: "new_comment_on_", class: "new_comment", autocomplete: "off") do 
 hidden_field_tag :post_id,  post_id, id: "post_id_on_" 
 text_area_tag :text, nil, class: "col-md-12 comment_box form-control form-group", id: "comment_text_on_", placeholder: t(".comment") 
 submit_tag t(".comment"), :id => "comment_submit_", "data-disable-with" => t(".commenting"), :class => "btn btn-primary btn-block" 
 end 
 end 
 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def index
    service = CommentService.new(post_id: params[:post_id], user: current_user)
    @post = service.post
    @comments = service.comments
    respond_with do |format|
      format.json  { render json: CommentPresenter.as_collection(@comments), status: 200 }
      format.mobile { render layout: false }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 og_prefix 
 page_title yield(:page_title) 
  if @post.present? 
 og_page_post_tags(@post) 
 else 
 og_general_tags 
 end 
 
 chartbeat_head_block 
 include_mixpanel 
 include_color_theme 
 if rtl? 
 stylesheet_link_tag :rtl, media:  'all' 
 end 
 old_browser_js_support 
 javascript_include_tag :ie 
 jquery_include_tag 
 unless @landing_page 
 javascript_include_tag :main, :templates 
 load_javascript_locales 
 end 
 translation_missing_warnings 
 current_user_atom_tag 
 yield(:head) 
 csrf_meta_tag 
 include_gon(camel_case:  true) 
 yield :before_content 
 
  if @post.public? 
 @post.reshares.size 
 end 
 @post.comments.size 
 @post.likes.size 
  person_image_link(comment.author, size: :thumb_small, class: "media-object") 
 person_link(comment.author) 
 timeago(comment.created_at ? comment.created_at : Time.now) 
 if user_signed_in? && comment.author == current_user.person 
 link_to(raw("<i class='entypo-trash'></i>"), comment_path(comment), method: :delete,                          data: {}, class: "remove") 
 end 
 direction_for(comment.text) 
 comment.message.markdownified 
 
 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  private

  def respond_create_success
    respond_to do |format|
      format.json { render json: CommentPresenter.new(@comment), status: 201 }
      format.html { render nothing: true, status: 201 }
      format.mobile { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 og_prefix 
 page_title yield(:page_title) 
  if @post.present? 
 og_page_post_tags(@post) 
 else 
 og_general_tags 
 end 
 
 chartbeat_head_block 
 include_mixpanel 
 include_color_theme 
 if rtl? 
 stylesheet_link_tag :rtl, media:  'all' 
 end 
 old_browser_js_support 
 javascript_include_tag :ie 
 jquery_include_tag 
 unless @landing_page 
 javascript_include_tag :main, :templates 
 load_javascript_locales 
 end 
 translation_missing_warnings 
 current_user_atom_tag 
 yield(:head) 
 csrf_meta_tag 
 include_gon(camel_case:  true) 
 yield :before_content 
 
 person_image_link(comment.author, size: :thumb_small, class: "media-object") 
 person_link(comment.author) 
 timeago(comment.created_at ? comment.created_at : Time.now) 
 if user_signed_in? && comment.author == current_user.person 
 link_to(raw("<i class='entypo-trash'></i>"), comment_path(comment), method: :delete,                          data: {}, class: "remove") 
 end 
 direction_for(comment.text) 
 comment.message.markdownified 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end
 }
    end
  end

  def respond_destroy_success
    respond_to do |format|
      format.mobile { redirect_to :back }
      format.js { render nothing: true, status: 204 }
      format.json { render nothing: true, status: 204 }
    end
  end

  def respond_destroy_error
    respond_to do |format|
      format.mobile { redirect_to :back }
      format.js { render nothing: true, status: 403 }
      format.json { render nothing: true, status: 403 }
    end
  end
end
