#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class PostsController < ApplicationController
  include PostsHelper

  before_action :authenticate_user!, only: :destroy
  before_action :set_format_if_malformed_from_status_net, only: :show

  respond_to :html, :mobile, :json, :xml

  rescue_from Diaspora::NonPublic do
    if user_signed_in?
      @code = "not-public"
      respond_to do |format|
        format.all { render template: "errors/not_public", status: 404, layout: "error_page" }
      end
    else
      authenticate_user!
    end
  end

  rescue_from Diaspora::NotMine do
    render text: "You are not allowed to do that", status: 403
  end

  def show
    post_service = PostService.new(id: params[:id], user: current_user)
    post_service.mark_user_notifications
    @post = post_service.post
    respond_to do |format|
      format.html { gon.post = post_service.present_json }
      format.xml { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 
 content_for :page_title do 
 post_page_title @post 
 end 
 content_for :content do 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end
 }
      format.json { render json: post_service.present_json }
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
 
 content_for :page_title do 
 post_page_title @post 
 end 
 content_for :content do 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def iframe
    render text: post_iframe_url(params[:id]), layout: false
  end

  def oembed
    post_id = OEmbedPresenter.id_from_url(params.delete(:url))
    post_service = PostService.new(id: post_id, user: current_user,
                                    oembed: params.slice(:format, :maxheight, :minheight))
    render json: post_service.present_oembed
  end

  def interactions
    post_service = PostService.new(id: params[:id], user: current_user)
    respond_with post_service.present_interactions_json
  end

  def destroy
    post_service = PostService.new(id: params[:id], user: current_user)
    post_service.retract_post
    @post = post_service.post
    respond_to do |format|
      format.js { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @post.guid 

end
 }
      format.json { render nothing: true, status: 204 }
      format.any { redirect_to stream_path }
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
 
 @post.guid 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  private

  def set_format_if_malformed_from_status_net
    request.format = :html if request.format == "application/html+xml"
  end
end
