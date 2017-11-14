#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class LikesController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!

  respond_to :html,
             :mobile,
             :json

  def create
    begin
      @like = if target
        current_user.like!(target)
      end
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
      # do nothing
    end

    if @like
      respond_to do |format|
        format.html { render :nothing => true, :status => 201 }
        format.mobile { redirect_to post_path(@like.post_id) }
        format.json { render :json => @like.as_api_response(:backbone), :status => 201 }
      end
    else
      render :nothing => true, :status => 422
    end
  end

  def destroy
    @like = Like.find_by_id_and_author_id!(params[:id], current_user.person.id)

    current_user.retract(@like)
    respond_to do |format|
      format.json { render :nothing => true, :status => 204 }
    end
  end

  #I can go when the old stream goes.
  def index
    @likes = target.likes.includes(:author => :profile)
    @people = @likes.map(&:author)

    respond_to do |format|
      format.all { render :layout => false }
      format.json { render :json => @likes.as_api_response(:backbone) }
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
 
  @people[0..17].each do |person| 
 person_image_link(person, size: :thumb_small) 
 end 
 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  private

  def target
    @target ||= if params[:post_id]
      current_user.find_visible_shareable_by_id(Post, params[:post_id]) || raise(ActiveRecord::RecordNotFound.new)
    else
      Comment.find(params[:comment_id]).tap do |comment|
       raise(ActiveRecord::RecordNotFound.new) unless current_user.find_visible_shareable_by_id(Post, comment.commentable_id)
      end
    end
  end
end
