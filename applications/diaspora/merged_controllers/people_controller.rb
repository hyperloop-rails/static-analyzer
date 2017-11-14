#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class PeopleController < ApplicationController
  before_action :authenticate_user!, except: [:show, :stream]
  before_action :find_person, only: [:show, :stream, :hovercard]

  respond_to :html, :except => [:tag_index]
  respond_to :json, :only => [:index, :show]
  respond_to :js, :only => [:tag_index]

  rescue_from ActiveRecord::RecordNotFound do
    render :file => Rails.root.join('public', '404').to_s,
           :format => :html, :layout => false, :status => 404
  end

  rescue_from Diaspora::AccountClosed do
    respond_to do |format|
      format.any { redirect_to :back, :notice => t("people.show.closed_account") }
      format.json { render :nothing => true, :status => 410 } # 410 GONE
    end
  end

  helper_method :search_query

  def index
    @aspect = :search
    limit = params[:limit] ? params[:limit].to_i : 15

    @people = Person.search(search_query, current_user)

    respond_to do |format|
      format.json do
        @people = @people.limit(limit)
        render :json => @people
      end

      format.any(:html, :mobile) do
        #only do it if it is an email address
        if diaspora_id?(search_query)
          @people =  Person.where(:diaspora_handle => search_query.downcase)
          if @people.empty?
            Workers::FetchWebfinger.perform_async(search_query)
            @background_query = search_query.downcase
          end
        end
        @people = @people.paginate(:page => params[:page], :per_page => 15)
        @hashes = hashes_for_people(@people, @aspects)
      end
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
 t('search') 
 end 
 form_tag(search_path, :method => 'get') do 
 search_field_tag :q, nil, :placeholder => t('find_people'), :class => 'search' 
 submit_tag t('search'), 'data-inline' => 'true', :class => 'btn' 
 end 
 if params[:q].blank? 
 t('.no_results') 
 else 
 t('.results_for', search_term: params[:q]) 
 if @hashes.empty? 
 t('.no_one_found') 
 else 
 for hash in @hashes 
  person.id 
 person_image_link(person, size: :thumb_small, class: "media-object") 
 person_link(person, size: :thumb_small) 
 link_to person.diaspora_handle, local_or_remote_person_path(person), class: "black" 
end 
 will_paginate @people, :renderer => WillPaginate::ActionView::BootstrapLinkRenderer 
 end 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def refresh_search
    @aspect = :search
    @people =  Person.where(:diaspora_handle => search_query.downcase)
    @answer_html = ""
    unless @people.empty?
      @hashes = hashes_for_people(@people, @aspects)

      self.formats = self.formats + [:html]
      @answer_html = render_to_string :partial => 'people/person', :locals => @hashes.first
    end
    render :json => { :search_count => @people.count, :search_html => @answer_html }.to_json
  end


  def tag_index
    profiles = Profile.tagged_with(params[:name]).where(:searchable => true).select('profiles.id, profiles.person_id')
    @people = Person.where(:id => profiles.map{|p| p.person_id}).paginate(:page => params[:page], :per_page => 15)
    respond_with @people
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
 t('search') 
 end 
 form_tag(search_path, :method => 'get') do 
 search_field_tag :q, nil, :placeholder => t('find_people'), :class => 'search' 
 submit_tag t('search'), 'data-inline' => 'true', :class => 'btn' 
 end 
 if params[:q].blank? 
 t('.no_results') 
 else 
 t('.results_for', search_term: params[:q]) 
 if @hashes.empty? 
 t('.no_one_found') 
 else 
 for hash in @hashes 
  person.id 
 person_image_link(person, size: :thumb_small, class: "media-object") 
 person_link(person, size: :thumb_small) 
 link_to person.diaspora_handle, local_or_remote_person_path(person), class: "black" 
end 
 will_paginate @people, :renderer => WillPaginate::ActionView::BootstrapLinkRenderer 
 end 
 end 
 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  # renders the persons user profile page
  def show
    mark_corresponding_notifications_read if user_signed_in?

    @person_json = PersonPresenter.new(@person, current_user).as_json

    respond_to do |format|
      format.all do
        if user_signed_in?
          @contact = current_user.contact_for(@person)
        end
        gon.preloads[:person] = @person_json
        gon.preloads[:photos] = {
          count: Photo.visible(current_user, @person).count(:all)
        }
        gon.preloads[:contacts] = {
          count: Contact.contact_contacts_for(current_user, @person).count(:all),
        }
        respond_with @person, layout: "with_header"
      end

      format.mobile do
        @post_type = :all
        person_stream
        respond_with @person
      end

      format.json { render json: @person_json }
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

  def stream
    respond_to do |format|
      format.all { redirect_to person_path(@person) }
      format.json {
        render json: person_stream.stream_posts.map { |p| LastThreeCommentsDecorator.new(PostPresenter.new(p, current_user)) }
      }
    end
  end

  # hovercards fetch some the persons public profile data via json and display
  # it next to the avatar image in a nice box
  def hovercard
    respond_to do |format|
      format.all do
        redirect_to :action => "show", :id => params[:person_id]
      end

      format.json do
        render :json => HovercardPresenter.new(@person)
      end
    end
  end

  def retrieve_remote
    if params[:diaspora_handle]
      Workers::FetchWebfinger.perform_async(params[:diaspora_handle])
      render :nothing => true
    else
      render :nothing => true, :status => 422
    end
  end

  def contacts
    respond_to do |format|
      format.json { render nothing: true, status: 406 }

      format.any do
        @person = Person.find_by_guid(params[:person_id])

        if @person
          @contact = current_user.contact_for(@person)
          @contacts_of_contact = Contact.contact_contacts_for(current_user, @person)
          gon.preloads[:person] = PersonPresenter.new(@person, current_user).as_json
          gon.preloads[:photos] = {
            count: Photo.visible(current_user, @person).count(:all)
          }
          gon.preloads[:contacts] = {
            count: @contacts_of_contact.count(:all),
          }
          @contacts_of_contact = @contacts_of_contact.paginate(page: params[:page], per_page: (params[:limit] || 15))
          @hashes = hashes_for_people @contacts_of_contact, @aspects
          respond_with @person, layout: "with_header"
        else
          flash[:error] = I18n.t "people.show.does_not_exist"
          redirect_to people_path
        end
      end
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
 
 content_for :head do 
 if user_signed_in? && @person != current_user.person 
 end 
 end 
 content_for :page_title do 
 @person.name 
 end 
 @hashes.each do |hash| 
  person.id 
 person_image_link(person, size: :thumb_small, class: "media-object") 
 person_link(person, size: :thumb_small) 
 link_to person.diaspora_handle, local_or_remote_person_path(person), class: "black" 
 
 end 
 will_paginate @contacts_of_contact, renderer: WillPaginate::ActionView::BootstrapLinkRenderer 
 if user_signed_in? && @person 
  title 
 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  # shows the dropdown list of aspects the current user has set for the given person.
  # renders "thats you" in case the current user views himself
  def aspect_membership_dropdown
    @person = Person.find_by_guid(params[:person_id])

    # you are not a contact of yourself...
    return render :text => I18n.t('people.person.thats_you') if @person == current_user.person

    @contact = current_user.contact_for(@person) || Contact.new
    @aspect = :profile if params[:create]  # let aspect dropdown create new aspects
    size = params[:size] || "small"

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
 
 aspect_membership_dropdown(@contact, @person, 'right', nil, size) 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  private

  def find_person
    username = params[:username]
    @person = if diaspora_id?(username)
        Person.where({
          diaspora_handle: username.downcase
        }).first
      else
        Person.find_from_guid_or_username({
          id: params[:id] || params[:person_id],
          username: username
        })
      end

    # view this profile on the home pod, if you don't want to sign in...
    authenticate_user! if remote_profile_with_no_user_session?
    raise ActiveRecord::RecordNotFound if @person.nil?
    raise Diaspora::AccountClosed if @person.closed_account?
  end

  def hashes_for_people(people, aspects)
    ids = people.map{|p| p.id}
    contacts = {}
    Contact.unscoped.where(:user_id => current_user.id, :person_id => ids).each do |contact|
      contacts[contact.person_id] = contact
    end

    people.map{|p|
      {:person => p,
        :contact => contacts[p.id],
        :aspects => aspects}
    }
  end

  def search_query
    @search_query ||= params[:q] || params[:term] || ''
  end

  def diaspora_id?(query)
    !query.try(:match, /^(\w)*@([a-zA-Z0-9]|[-]|[.]|[:])*$/).nil?
  end

  def remote_profile_with_no_user_session?
    @person.try(:remote?) && !user_signed_in?
  end

  def mark_corresponding_notifications_read
    Notification.where(recipient_id: current_user.id, target_type: "Person", target_id: @person.id, unread: true).each do |n|
      n.set_read_state( true )
    end
  end

  def person_stream
    @stream ||= Stream::Person.new(current_user, @person, max_time: max_time)
  end
end
