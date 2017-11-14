class ConversationsController < ApplicationController
  before_action :authenticate_user!

  layout ->(c) { request.format == :mobile ? "application" : "with_header" }
  respond_to :html, :mobile, :json, :js

  def index
    @visibilities = ConversationVisibility.includes(:conversation)
                                          .order("conversations.updated_at DESC")
                                          .where(person_id: current_user.person_id)
                                          .paginate(page: params[:page], per_page: 15)

    if params[:conversation_id]
      @conversation = Conversation.joins(:conversation_visibilities)
                                  .where(conversation_visibilities: {
                                           person_id:       current_user.person_id,
                                           conversation_id: params[:conversation_id]
                                         }).first

      if @conversation
        @first_unread_message_id = @conversation.first_unread_message(current_user).try(:id)
        @conversation.set_read(current_user)
      end
    end

    gon.contacts = contacts_data

    respond_with do |format|
      format.html
      format.json { render json: @visibilities.map(&:conversation), status: 200 }
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
 
 t(".inbox") 
 link_to t(".new_conversation"), new_conversation_path, class: "btn btn-default pull-right" 
 flash.each do |name, msg| 
 msg 
 msg 
 end 
 if @visibilities.count > 0 
  conversation = visibility.conversation 
 conversation_path(conversation) 
 other_participants = conversation.ordered_participants - [current_user.person] 
 if other_participants.first.present? 
 person_image_tag(other_participants.first) 
 if other_participants.count > 1 
 other_participants.count - 1 
 end 
 end 
 conversation.messages.size 
 if visibility.unread > 0 
 visibility.unread 
 end 
 direction_for(conversation.subject) 
 conversation.subject 
 timeago(conversation.updated_at) 
 if conversation.last_author.present? 
 conversation.last_author.name 
 end 
 if conversation.messages.present? 
 conversation.messages.last.text 
 end 
 if other_participants.count > 1 
 other_participants.drop(1).take(15).each do |participant| 
 person_image_tag(participant) 
 end 
 end 
 
 else 
 t(".no_messages") 
 end 
 will_paginate @visibilities, previous_label: "&laquo;", next_label: "&raquo;", inner_window: 1, outer_window: 0,      renderer: WillPaginate::ActionView::BootstrapLinkRenderer 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def create
    contact_ids = params[:contact_ids]

    # Can't split nil
    if contact_ids
      contact_ids = contact_ids.split(',') if contact_ids.is_a? String
      person_ids = current_user.contacts.where(id: contact_ids).pluck(:person_id)
    end

    opts = params.require(:conversation).permit(:subject)
    opts[:participant_ids] = person_ids
    opts[:message] = { text: params[:conversation][:text] }
    @conversation = current_user.build_conversation(opts)

    @response = {}
    if person_ids.present? && @conversation.save
      Postzord::Dispatcher.build(current_user, @conversation).post
      @response[:success] = true
      @response[:message] = I18n.t('conversations.create.sent')
      @response[:conversation_id] = @conversation.id
    else
      @response[:success] = false
      @response[:message] = I18n.t('conversations.create.fail')
      if person_ids.blank?
        @response[:message] = I18n.t('conversations.create.no_contact')
      end
    end
    respond_to do |format|
      format.js
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
 
 raw @response.to_json 
 if session[:mobile_view] 
 conversations_path(conversation_id: @conversation.id) 
 else 
 conversations_path(conversation_id: @conversation.id) 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def show
    respond_to do |format|
      format.html do
        redirect_to conversations_path(:conversation_id => params[:id])
        return
      end

      if @conversation = current_user.conversations.where(id: params[:id]).first
        @first_unread_message_id = @conversation.first_unread_message(current_user).try(:id)
        @conversation.set_read(current_user)

        format.js
        format.json { render :json => @conversation, :status => 200 }
      else
        redirect_to conversations_path
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
 
  escape_javascript(render('conversations/show', :conversation => @conversation)) 
 @conversation.id 
 
 @conversation.id 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def new
    if !params[:modal] && !session[:mobile_view] && request.format.html?
      redirect_to conversations_path
      return
    end

    @contacts_json = contacts_data.to_json
    @contact_ids = ""

    if params[:contact_id]
      @contact_ids = current_user.contacts.find(params[:contact_id]).id
    elsif params[:aspect_id]
      @contact_ids = current_user.aspects.find(params[:aspect_id]).contacts.map{|c| c.id}.join(',')
    end
    if session[:mobile_view] == true && request.format.html?
      render :layout => true
    else
      render :layout => false
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
 
  render 'conversations/new' 
 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  private

  def contacts_data
    current_user.contacts.sharing.joins(person: :profile)
      .pluck(*%w(contacts.id profiles.first_name profiles.last_name people.diaspora_handle))
      .map {|contact_id, *name_attrs|
        {value: contact_id, name: ERB::Util.h(Person.name_from_attrs(*name_attrs)) }
      }
  end
end
