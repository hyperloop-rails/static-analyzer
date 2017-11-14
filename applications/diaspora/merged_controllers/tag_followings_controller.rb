#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.
#

class TagFollowingsController < ApplicationController
  before_action :authenticate_user!

  respond_to :json
  respond_to :html, only: [:manage]

  # POST /tag_followings
  # POST /tag_followings.xml
  def create
    name_normalized = ActsAsTaggableOn::Tag.normalize(params['name'])

    if name_normalized.nil? || name_normalized.empty?
      render :nothing => true, :status => 403
    else
      @tag = ActsAsTaggableOn::Tag.find_or_create_by(name: name_normalized)
      @tag_following = current_user.tag_followings.new(:tag_id => @tag.id)

      if @tag_following.save
        render :json => @tag.to_json, :status => 201
      else
        render :nothing => true, :status => 403
      end
    end
  end

  # DELETE /tag_followings/1
  # DELETE /tag_followings/1.xml
  def destroy
    tag_following = current_user.tag_followings.find_by_tag_id( params['id'] )

    if tag_following && tag_following.destroy
      respond_to do |format|
        format.any(:js, :json) { render :nothing => true, :status => 204 }
      end
    else
      respond_to do |format|
        format.any(:js, :json) {render :nothing => true, :status => 403}
      end
    end
  end

  def index
    respond_to do |format|
      format.json{ render(:json => tags.to_json, :status => 200) }
    end
  end

  def manage
    redirect_to followed_tags_stream_path unless request.format == :mobile
    gon.preloads[:tagFollowings] = tags
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
 
 t("tag_followings.manage.title") 
 if current_user.followed_tags.length == 0 
 t("tag_followings.manage.no_tags") 
 else 
 t("tag_followings.manage.no_tags") 
 current_user.followed_tags.each do |tag| 
 "#" 
 end 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end
end
