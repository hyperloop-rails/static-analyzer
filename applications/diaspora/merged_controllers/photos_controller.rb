#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class PhotosController < ApplicationController
  before_action :authenticate_user!, except: %i(show index)
  respond_to :html, :json

  def show
    @photo = if user_signed_in?
      current_user.photos_from(Person.find_by_guid(params[:person_id])).where(id: params[:id]).first
    else
      Photo.where(id: params[:id], public: true).first
    end

    raise ActiveRecord::RecordNotFound unless @photo
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
 
 image_tag photo.url(:scaled_full) 
 person_image_link(photo.author, :size => :thumb_small) 
 person_link(photo.author) 
 link_to(post_path(photo)) do 
 timeago(photo.created_at) 
 end 
 if additional_photos && additional_photos.length > 1 
 if previous_photo != additional_photos.last 
 link_to(content_tag(:i, nil, id: "arrow-left", class: "entypo-chevron-left"),                person_photo_path(previous_photo.author, previous_photo),                rel:   "prefetch",                class: "arrow left") 
 end 
 if next_photo == additional_photos[additional_photos.index(photo)+1] 
 link_to(content_tag(:i, nil, id: "arrow-right", class: "entypo-chevron-right"),                person_photo_path(next_photo.author, next_photo),                rel: "prefetch",                class: "arrow right") 
 end 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def index
    @post_type = :photos
    @person = Person.find_by_guid(params[:person_id])
    authenticate_user! if @person.try(:remote?) && !user_signed_in?

    if @person
      @contact = current_user.contact_for(@person) if user_signed_in?
      @posts = Photo.visible(current_user, @person, :all, max_time)
      respond_to do |format|
        format.all do
          gon.preloads[:person] = PersonPresenter.new(@person, current_user).as_json
          gon.preloads[:photos] = {
            count: Photo.visible(current_user, @person).count(:all)
          }
          gon.preloads[:contacts] = {
            count: Contact.contact_contacts_for(current_user, @person).count(:all),
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
 yield(:head) 
 csrf_meta_tag 
 include_gon(camel_case:  true) 
 yield :before_content 
 
 content_for :head do 
 if user_signed_in? && @person != current_user.person 
 end 
 end 
 content_for :page_title do 
 @person.name 
 end 
 if user_signed_in? && current_user.person.id == @person.id 
 render 'publisher/publisher', publisher_aspects_for(nil) 
 end 
 if user_signed_in? && @person 
  title 
 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end
        end
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
 
 content_for :head do 
 if user_signed_in? && @person != current_user.person 
 end 
 end 
 content_for :page_title do 
 @person.name 
 end 
 if user_signed_in? && current_user.person.id == @person.id 
 render 'publisher/publisher', publisher_aspects_for(nil) 
 end 
 if user_signed_in? && @person 
  title 
 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end
 }
        format.json{ render_for_api :backbone, :json => @posts, :root => :photos }
      end
    else
      flash[:error] = I18n.t 'people.show.does_not_exist'
      redirect_to people_path
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
 
 for photo in photos 
 link_to image_tag(photo.url(:thumb_large)), person_photo_path(photo.author, photo), class: "thumbnail" 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def create
    rescuing_photo_errors do
      if remotipart_submitted?
        @photo = current_user.build_post(:photo, photo_params)
        if @photo.save
          respond_to do |format|
            format.json { render :json => {"success" => true, "data" => @photo.as_api_response(:backbone)} }
          end
        else
          respond_with @photo, :location => photos_path, :error => message
        end
      else
        legacy_create
      end
    end
  end

  def make_profile_photo
    author_id = current_user.person_id
    @photo = Photo.where(:id => params[:photo_id], :author_id => author_id).first

    if @photo
      profile_hash = {:image_url        => @photo.url(:thumb_large),
                      :image_url_medium => @photo.url(:thumb_medium),
                      :image_url_small  => @photo.url(:thumb_small)}

      if current_user.update_profile(profile_hash)
        respond_to do |format|
          format.js{ render :json => { :photo_id  => @photo.id,
                                       :image_url => @photo.url(:thumb_large),
                                       :image_url_medium => @photo.url(:thumb_medium),
                                       :image_url_small  => @photo.url(:thumb_small),
                                       :author_id => author_id},
                            :status => 201}
        end
      else
        render :nothing => true, :status => 422
      end
    else
      render :nothing => true, :status => 422
    end
  end

  def destroy
    photo = current_user.photos.where(:id => params[:id]).first

    if photo
      current_user.retract(photo)

      respond_to do |format|
        format.json{ render :nothing => true, :status => 204 }
        format.html do
          flash[:notice] = I18n.t 'photos.destroy.notice'
          if StatusMessage.find_by_guid(photo.status_message_guid)
              respond_with photo, :location => post_path(photo.status_message)
          else
            respond_with photo, :location => person_photos_path(current_user.person)
          end
        end
      end
    else
      respond_with photo, :location => person_photos_path(current_user.person)
    end
  end

  def edit
    if @photo = current_user.photos.where(:id => params[:id]).first
      respond_with @photo
    else
      redirect_to person_photos_path(current_user.person)
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
 
 " " 
 @photo.id 
 image_tag @photo.url(:scaled_full) 
 form_for @photo do |photo| 
 photo.label :text 
 photo.text_field :text, value: @photo.text 
 photo.submit 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def update
    photo = current_user.photos.where(:id => params[:id]).first
    if photo
      if current_user.update_post( photo, photo_params )
        flash.now[:notice] = I18n.t 'photos.update.notice'
        respond_to do |format|
          format.js{ render :json => photo, :status => 200 }
        end
      else
        flash.now[:error] = I18n.t 'photos.update.error'
        respond_to do |format|
          format.html{ redirect_to [:edit, photo] }
          format.js{ render :status => 403 }
        end
      end
    else
      redirect_to person_photos_path(current_user.person)
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:public, :text, :pending, :user_file, :image_url, :aspect_ids, :set_profile_photo)
  end

  def file_handler(params)
    # For XHR file uploads, request.params[:qqfile] will be the path to the temporary file
    # For regular form uploads (such as those made by Opera), request.params[:qqfile] will be an UploadedFile which can be returned unaltered.
    if not request.params[:qqfile].is_a?(String)
      params[:qqfile]
    else
      ######################## dealing with local files #############
      # get file name
      file_name = params[:qqfile]
      # get file content type
      att_content_type = (request.content_type.to_s == "") ? "application/octet-stream" : request.content_type.to_s
      # create tempora##l file
      file = Tempfile.new(file_name, {:encoding =>  'BINARY'})
      # put data into this file from raw post request
      file.print request.raw_post.force_encoding('BINARY')

      # create several required methods for this temporal file
      Tempfile.send(:define_method, "content_type") {return att_content_type}
      Tempfile.send(:define_method, "original_filename") {return file_name}
      file
    end
  end

  def legacy_create
    if params[:photo][:aspect_ids] == "all"
      params[:photo][:aspect_ids] = current_user.aspects.collect { |x| x.id }
    elsif params[:photo][:aspect_ids].is_a?(Hash)
      params[:photo][:aspect_ids] = params[:photo][:aspect_ids].values
    end

    params[:photo][:user_file] = file_handler(params)

    @photo = current_user.build_post(:photo, params[:photo])

    if @photo.save
      aspects = current_user.aspects_from_ids(params[:photo][:aspect_ids])

      unless @photo.pending
        current_user.add_to_streams(@photo, aspects)
        current_user.dispatch_post(@photo, :to => params[:photo][:aspect_ids])
      end

      if params[:photo][:set_profile_photo]
        profile_params = {:image_url => @photo.url(:thumb_large),
                          :image_url_medium => @photo.url(:thumb_medium),
                          :image_url_small => @photo.url(:thumb_small)}
        current_user.update_profile(profile_params)
      end

      respond_to do |format|
        format.json{ render(:layout => false , :json => {"success" => true, "data" => @photo}.to_json )}
        format.html{ render(:layout => false , :json => {"success" => true, "data" => @photo}.to_json )}
      end
    else
      respond_with @photo, :location => photos_path, :error => message
    end
  end

  def rescuing_photo_errors
    begin
      yield
    rescue TypeError
      message = I18n.t 'photos.create.type_error'
      respond_with @photo, :location => photos_path, :error => message

    rescue CarrierWave::IntegrityError
      message = I18n.t 'photos.create.integrity_error'
      respond_with @photo, :location => photos_path, :error => message

    rescue RuntimeError => e
      message = I18n.t 'photos.create.runtime_error'
      respond_with @photo, :location => photos_path, :error => message
      raise e
    end
  end
end
