#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.
class StatusMessagesController < ApplicationController
  before_action :authenticate_user!

  before_action :remove_getting_started, only: :create

  respond_to :html, :mobile, :json

  layout "application", only: :bookmarklet

  # Called when a user clicks "Mention" on a profile page
  # @param person_id [Integer] The id of the person to be mentioned
  def new
    if params[:person_id] && fetch_person(params[:person_id])
      @aspect = :profile
      @contact = current_user.contact_for(@person)
      if @contact
        @aspects_with_person = @contact.aspects.load
        @aspect_ids = @aspects_with_person.map(&:id)
        gon.aspect_ids = @aspect_ids
        render layout: nil
      else
        @aspects_with_person = []
      end
    elsif request.format == :mobile
      @aspect = :all
      @aspects = current_user.aspects.load
      @aspect_ids = @aspects.map(&:id)
      gon.aspect_ids = @aspect_ids
    else
      redirect_to stream_path
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
 
  form_for StatusMessage.new, html: {} do |status| 
 status.hidden_field :provider_display_name, value: 'mobile' 
 status.text_area :text, placeholder: t('shared.publisher.whats_on_your_mind'), rows: 4, autofocus: "autofocus", class: "form-control" 
 if current_user.services 
 for service in current_user.services 
 image_tag "social_media_logos/-32x32.png", title: service.provider.titleize, class: "service_icon dim", id:"", maxchar: "" 
 end 
 end 
 t('public') 
 true 
 t('all_aspects') 
 current_user.aspects.each do |aspect| 
 aspect.id 
 " " 
 end 
 t('shared.publisher.upload_photos') 
 submit_tag t('shared.publisher.share'), class: 'btn btn-primary', id: "submit_new_message" 
 end 
 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def bookmarklet
    @aspects = current_user.aspects
    @aspect_ids = current_user.aspect_ids

    gon.preloads[:bookmarklet] = {
      content: params[:content],
      title:   params[:title],
      url:     params[:url],
      notes:   params[:notes]
    }
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
 javascript_include_tag :jquery 
 csrf_meta_tag 
 include_gon(camel_case:  true) 
 yield :before_content 
 
  form_for StatusMessage.new, html: {} do |status| 
 status.hidden_field :provider_display_name, value: 'mobile' 
 status.text_area :text, placeholder: t('shared.publisher.whats_on_your_mind'), rows: 4, autofocus: "autofocus", class: "form-control" 
 if current_user.services 
 for service in current_user.services 
 image_tag "social_media_logos/-32x32.png", title: service.provider.titleize, class: "service_icon dim", id:"", maxchar: "" 
 end 
 end 
 t('public') 
 true 
 t('all_aspects') 
 current_user.aspects.each do |aspect| 
 aspect.id 
 " " 
 end 
 t('shared.publisher.upload_photos') 
 submit_tag t('shared.publisher.share'), class: 'btn btn-primary', id: "submit_new_message" 
 end 
 
  
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def create
    @status_message = StatusMessageCreationService.new(params, current_user).status_message
    handle_mention_feedback
    respond_to do |format|
      format.html { redirect_to :back }
      format.mobile { redirect_to stream_path }
      format.json { render json: PostPresenter.new(@status_message, current_user), status: 201 }
    end
  rescue StandardError => error
    handle_create_error(error)
  end

  private

  def fetch_person(person_id)
    @person = Person.where(id: person_id).first
  end

  def handle_create_error(error)
    respond_to do |format|
      format.html { redirect_to :back }
      format.mobile { redirect_to stream_path }
      format.json { render text: error.message, status: 403 }
    end
  end

  def handle_mention_feedback
    return unless comes_from_others_profile_page?
    flash[:notice] = successful_mention_message
  end

  def comes_from_others_profile_page?
    coming_from_profile_page? && !own_profile_page?
  end

  def coming_from_profile_page?
    request.env["HTTP_REFERER"].include?("people")
  end

  def own_profile_page?
    request.env["HTTP_REFERER"].include?("/people/" + params[:status_message][:author][:guid].to_s)
  end

  def successful_mention_message
    t("status_messages.create.success", names: @status_message.mentioned_people_names)
  end

  def remove_getting_started
    current_user.disable_getting_started
  end
end
