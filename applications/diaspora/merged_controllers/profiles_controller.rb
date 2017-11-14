#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class ProfilesController < ApplicationController
  before_action :authenticate_user!, :except => ['show']

  respond_to :html, :except => [:show]
  respond_to :js, :only => :update

  # this is terrible because we're actually serving up the associated person here;
  # however, this is the effect that we want for now
  def show
    @person = Person.find_by_guid!(params[:id])

    respond_to do |format|
      format.json { render :json => PersonPresenter.new(@person, current_user) }
    end
  end

  def edit
    @person = current_user.person
    @aspect  = :person_edit
    @profile = @person.profile

    @tags = @profile.tags
    @tags_array = []
    @tags.each do |obj|
      @tags_array << { :name => ("#"+obj.name),
        :value => ("#"+obj.name)}
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
 
  t("settings") 
 current_page?(edit_profile_path) 
 link_to t("profile"), edit_profile_path 
 current_page?(edit_user_path) 
 link_to t("account"), edit_user_path 
 current_page?(privacy_settings_path) 
 link_to t("privacy"), privacy_settings_path 
 current_page?(services_path) 
 link_to t("_services"), services_path 
 
 content_for :submit_block do 
 link_to t("cancel"), local_or_remote_person_path(current_user.person), class: "btn btn-default" 
 submit_tag t(".update_profile"), class: "btn btn-primary pull-right", id: "update_profile" 
 end 
 form_tag profile_path, method: :put, multipart: true, id: "update_profile_form" do 
  content_for :head do 
 if mobile 
 javascript_include_tag :jquery 
 end 
 end 
 if mobile 
 flash.each do |name, msg| 
 msg 
 msg 
 end 
 end 
 t("profiles.edit.basic") 
 t("profiles.edit.basic_hint") 
 error_messages_for profile 
 t('profiles.edit.your_name') 
 label_tag 'profile[first_name]', t('profiles.edit.first_name') 
 text_field_tag 'profile[first_name]', profile.first_name, class: 'form-control' 
 label_tag 'profile[last_name]', t('profiles.edit.last_name') 
 text_field_tag 'profile[last_name]', profile.last_name, class: 'form-control' 
 t('profiles.edit.your_tags') 
 text_field_tag 'profile[tag_string]', "", placeholder: t('profiles.edit.your_tags_placeholder'),class: "form-control" 
 t('profiles.edit.your_photo') 
  content_for :head do 
 end 
 owner_image_tag(:thumb_large) 
 t('.upload') 
 image_tag('mobile-spinner.gif', :class => 'hidden', :style => "z-index:-1", :id => 'file-upload-spinner') 
 
 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def update
    # upload and set new profile photo
    @profile_attrs = profile_params

    munge_tag_string

    #checkbox tags wtf
    @profile_attrs[:searchable] ||= false
    @profile_attrs[:nsfw] ||= false
    @profile_attrs[:public_details] ||= false

    if params[:photo_id]
      @profile_attrs[:photo] = Photo.where(:author_id => current_user.person_id, :id => params[:photo_id]).first
    end

    if current_user.update_profile(@profile_attrs)
      flash[:notice] = I18n.t 'profiles.update.updated'
    else
      flash[:error] = I18n.t 'profiles.update.failed'
    end

    respond_to do |format|
      format.js { render :nothing => true, :status => 200 }
      format.any {
        if current_user.getting_started?
          redirect_to getting_started_path
        else
          redirect_to edit_profile_path
        end
      }
    end
  end

  private

  def munge_tag_string
    unless @profile_attrs[:tag_string].nil? || @profile_attrs[:tag_string] == I18n.t('profiles.edit.your_tags_placeholder')
      @profile_attrs[:tag_string].split( " " ).each do |extra_tag|
        extra_tag.strip!
        unless extra_tag == ""
          extra_tag = "##{extra_tag}" unless extra_tag.start_with?( "#" )
          params[:tags] += " #{extra_tag}"
        end
      end
    end
    @profile_attrs[:tag_string] = (params[:tags]) ? params[:tags].gsub(',',' ') : ""
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :gender, :bio,
                                    :location, :searchable, :tag_string, :nsfw,
                                    :public_details, date: %i(year month day)) || {}
  end
end
