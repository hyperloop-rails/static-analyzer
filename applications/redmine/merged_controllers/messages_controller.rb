# Redmine - project management software
# Copyright (C) 2006-2016  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class MessagesController < ApplicationController
  menu_item :boards
  default_search_scope :messages
  before_action :find_board, :only => [:new, :preview]
  before_action :find_attachments, :only => [:preview]
  before_action :find_message, :except => [:new, :preview]
  before_action :authorize, :except => [:preview, :edit, :destroy]

  helper :boards
  helper :watchers
  helper :attachments
  include AttachmentsHelper

  REPLIES_PER_PAGE = 25 unless const_defined?(:REPLIES_PER_PAGE)

  # Show a topic and its replies
  def show
    page = params[:page]
    # Find the page of the requested reply
    if params[:r] && page.nil?
      offset = @topic.children.where("#{Message.table_name}.id < ?", params[:r].to_i).count
      page = 1 + offset / REPLIES_PER_PAGE
    end

    @reply_count = @topic.children.count
    @reply_pages = Paginator.new @reply_count, REPLIES_PER_PAGE, page
    @replies =  @topic.children.
      includes(:author, :attachments, {:board => :project}).
      reorder("#{Message.table_name}.created_on ASC, #{Message.table_name}.id ASC").
      limit(@reply_pages.per_page).
      offset(@reply_pages.offset).
      to_a

    @reply = Message.new(:subject => "RE: #{@message.subject}")
    render :action => "show", :layout => false if request.xhr?
  
 board_breadcrumb(@message) 
 watcher_link(@topic, User.current) 
 link_to(
          l(:button_quote),
          {:action => 'quote', :id => @topic},
          :method => 'get',
          :class => 'icon icon-comment',
          :remote => true) if !@topic.locked? && authorize_for('messages', 'reply') 
 link_to(
          l(:button_edit),
          {:action => 'edit', :id => @topic},
          :class => 'icon icon-edit'
        ) if @message.editable_by?(User.current) 
 link_to(
          l(:button_delete),
          {:action => 'destroy', :id => @topic},
          :method => :post,
          :data => {:confirm => l(:text_are_you_sure)},
          :class => 'icon icon-del'
         ) if @message.destroyable_by?(User.current) 
 avatar(@topic.author, :size => "24") 
 @topic.subject 
 authoring @topic.created_on, @topic.author 
 textilizable(@topic, :content) 
 link_to_attachments @topic, :author => false, :thumbnails => true 
 unless @replies.empty? 
 l(:label_reply_plural) 
 @reply_count 
 @replies.each do |message| 
 "message-#{message.id}" 
 link_to(
            '',
            {:action => 'quote', :id => message},
            :remote => true,
            :method => 'get',
            :title => l(:button_quote),
            :class => 'icon icon-comment'
          ) if !@topic.locked? && authorize_for('messages', 'reply') 
 link_to(
            '',
            {:action => 'edit', :id => message},
            :title => l(:button_edit),
            :class => 'icon icon-edit'
          ) if message.editable_by?(User.current) 
 link_to(
            '',
            {:action => 'destroy', :id => message},
            :method => :post,
            :data => {:confirm => l(:text_are_you_sure)},
            :title => l(:button_delete),
            :class => 'icon icon-del'
          ) if message.destroyable_by?(User.current) 
 avatar(message.author, :size => "24") 
 link_to message.subject, { :controller => 'messages', :action => 'show', :board_id => @board, :id => @topic, :r => message, :anchor => "message-#{message.id}" } 
 authoring message.created_on, message.author 
 textilizable message, :content, :attachments => message.attachments 
 link_to_attachments message, :author => false, :thumbnails => true 
 end 
 pagination_links_full @reply_pages, @reply_count, :per_page_links => false 
 end 
 if !@topic.locked? && authorize_for('messages', 'reply') 
 toggle_link l(:button_reply), "reply", :focus => 'message_content' 
 form_for @reply, :as => :reply, :url => {:action => 'reply', :id => @topic}, :html => {:multipart => true, :id => 'message-form'} do |f| 
 render :partial => 'form', :locals => {:f => f, :replying => true} 
 submit_tag l(:button_submit) 
 preview_link({:controller => 'messages', :action => 'preview', :board_id => @board}, 'message-form') 
 end 
 end 
 html_title @topic.subject 

 error_messages_for 'message' 
 replying ||= false 
 l(:field_subject) 
 f.text_field :subject, :size => 120, :id => "message_subject" 
 unless replying 
 if @message.safe_attribute? 'sticky' 
 f.check_box :sticky 
 label_tag 'message_sticky', l(:label_board_sticky) 
 end 
 if @message.safe_attribute? 'locked' 
 f.check_box :locked 
 label_tag 'message_locked', l(:label_board_locked) 
 end 
 end 
 if !replying && !@message.new_record? && @message.safe_attribute?('board_id') 
 l(:label_board) 
 f.select :board_id, boards_options_for_select(@message.project.boards) 
 end 
 label_tag "message_content", l(:description_message_content), :class => "hidden-for-sighted" 
 f.text_area :content, :cols => 80, :rows => 15, :class => 'wiki-edit', :id => 'message_content' 
 wikitoolbar_for 'message_content' 
 l(:label_attachment_plural) 
 render :partial => 'attachments/form', :locals => {:container => @message} 

 if defined?(container) && container && container.saved_attachments 
 container.saved_attachments.each_with_index do |attachment, i| 
 i 
 text_field_tag("attachments[p#{i}][filename]", attachment.filename, :class => 'filename') +
          text_field_tag("attachments[p#{i}][description]", attachment.description, :maxlength => 255, :placeholder => l(:label_optional_description), :class => 'description') +
          link_to('&nbsp;'.html_safe, attachment_path(attachment, :attachment_id => "p#{i}", :format => 'js'), :method => 'delete', :remote => true, :class => 'remove-upload') 
 hidden_field_tag "attachments[p#{i}][token]", "#{attachment.token}" 
 end 
 end 
 file_field_tag 'attachments[dummy][file]',
      :id => nil,
      :class => 'file_selector',
      :multiple => true,
      :onchange => 'addInputFiles(this);',
      :data => {
        :max_file_size => Setting.attachment_max_size.to_i.kilobytes,
        :max_file_size_message => l(:error_attachment_too_big, :max_size => number_to_human_size(Setting.attachment_max_size.to_i.kilobytes)),
        :max_concurrent_uploads => Redmine::Configuration['max_concurrent_ajax_uploads'].to_i,
        :upload_path => uploads_path(:format => 'js'),
        :description_placeholder => l(:label_optional_description)
      } 
 l(:label_max_size) 
 number_to_human_size(Setting.attachment_max_size.to_i.kilobytes) 
 content_for :header_tags do 
 javascript_include_tag 'attachments' 
 end 

end

  # Create a new topic
  def new
    @message = Message.new
    @message.author = User.current
    @message.board = @board
    @message.safe_attributes = params[:message]
    if request.post?
      @message.save_attachments(params[:attachments])
      if @message.save
        call_hook(:controller_messages_new_after_save, { :params => params, :message => @message})
        render_attachment_warning_if_needed(@message)
        redirect_to board_message_path(@board, @message)
      end
    end
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

 link_to @board.name, :controller => 'boards', :action => 'show', :project_id => @project, :id => @board 
 l(:label_message_new) 
 form_for @message, :url => {:action => 'new'}, :html => {:multipart => true, :id => 'message-form'} do |f| 
 render :partial => 'form', :locals => {:f => f} 
 submit_tag l(:button_create) 
 preview_link({:controller => 'messages', :action => 'preview', :board_id => @board}, 'message-form') 
 end 

 error_messages_for 'message' 
 replying ||= false 
 l(:field_subject) 
 f.text_field :subject, :size => 120, :id => "message_subject" 
 unless replying 
 if @message.safe_attribute? 'sticky' 
 f.check_box :sticky 
 label_tag 'message_sticky', l(:label_board_sticky) 
 end 
 if @message.safe_attribute? 'locked' 
 f.check_box :locked 
 label_tag 'message_locked', l(:label_board_locked) 
 end 
 end 
 if !replying && !@message.new_record? && @message.safe_attribute?('board_id') 
 l(:label_board) 
 f.select :board_id, boards_options_for_select(@message.project.boards) 
 end 
 label_tag "message_content", l(:description_message_content), :class => "hidden-for-sighted" 
 f.text_area :content, :cols => 80, :rows => 15, :class => 'wiki-edit', :id => 'message_content' 
 wikitoolbar_for 'message_content' 
 l(:label_attachment_plural) 
 render :partial => 'attachments/form', :locals => {:container => @message} 

end

  # Reply to a topic
  def reply
    @reply = Message.new
    @reply.author = User.current
    @reply.board = @board
    @reply.safe_attributes = params[:reply]
    @topic.children << @reply
    if !@reply.new_record?
      call_hook(:controller_messages_reply_after_save, { :params => params, :message => @reply})
      attachments = Attachment.attach_files(@reply, params[:attachments])
      render_attachment_warning_if_needed(@reply)
    end
    redirect_to board_message_path(@board, @topic, :r => @reply)
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

end

  # Edit a message
  def edit
    (render_403; return false) unless @message.editable_by?(User.current)
    @message.safe_attributes = params[:message]
    if request.post? && @message.save
      attachments = Attachment.attach_files(@message, params[:attachments])
      render_attachment_warning_if_needed(@message)
      flash[:notice] = l(:notice_successful_update)
      @message.reload
      redirect_to board_message_path(@message.board, @message.root, :r => (@message.parent_id && @message.id))
    end
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

 board_breadcrumb(@message) 
 avatar(@topic.author, :size => "24") 
 @topic.subject 
 form_for @message, {
               :as => :message,
               :url => {:action => 'edit'},
               :html => {:multipart => true,
                         :id => 'message-form',
                         :method => :post}
          } do |f| 
 render :partial => 'form',
             :locals => {:f => f, :replying => !@message.parent.nil?} 
 submit_tag l(:button_save) 
 preview_link({:controller => 'messages', :action => 'preview', :board_id => @board, :id => @message}, 'message-form') 
 end 

 error_messages_for 'message' 
 replying ||= false 
 l(:field_subject) 
 f.text_field :subject, :size => 120, :id => "message_subject" 
 unless replying 
 if @message.safe_attribute? 'sticky' 
 f.check_box :sticky 
 label_tag 'message_sticky', l(:label_board_sticky) 
 end 
 if @message.safe_attribute? 'locked' 
 f.check_box :locked 
 label_tag 'message_locked', l(:label_board_locked) 
 end 
 end 
 if !replying && !@message.new_record? && @message.safe_attribute?('board_id') 
 l(:label_board) 
 f.select :board_id, boards_options_for_select(@message.project.boards) 
 end 
 label_tag "message_content", l(:description_message_content), :class => "hidden-for-sighted" 
 f.text_area :content, :cols => 80, :rows => 15, :class => 'wiki-edit', :id => 'message_content' 
 wikitoolbar_for 'message_content' 
 l(:label_attachment_plural) 
 render :partial => 'attachments/form', :locals => {:container => @message} 

end

  # Delete a messages
  def destroy
    (render_403; return false) unless @message.destroyable_by?(User.current)
    r = @message.to_param
    @message.destroy
    if @message.parent
      redirect_to board_message_path(@board, @message.parent, :r => r)
    else
      redirect_to project_board_path(@project, @board)
    end
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

end

  def quote
    @subject = @message.subject
    @subject = "RE: #{@subject}" unless @subject.starts_with?('RE:')

    @content = "#{ll(Setting.default_language, :text_user_wrote, @message.author)}\n> "
    @content << @message.content.to_s.strip.gsub(%r{<pre>(.*?)</pre>}m, '[...]').gsub(/(\r?\n|\r\n?)/, "\n> ") + "\n\n"
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

end

  def preview
    message = @board.messages.find_by_id(params[:id])
    @text = (params[:message] || params[:reply])[:content]
    @previewed = message
    render :partial => 'common/preview'
  
 current_language 
 html_title 
 Redmine::Info.app_name 
 csrf_meta_tag 
 favicon 
 stylesheet_link_tag 'jquery/jquery-ui-1.11.0', 'application', 'responsive', :media => 'all' 
 stylesheet_link_tag 'rtl', :media => 'all' if l(:direction) == 'rtl' 
 javascript_heads 
 heads_for_theme 
 call_hook :view_layouts_base_html_head 
 yield :header_tags 
 body_css_classes 
 call_hook :view_layouts_base_body_top 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 label_tag 'flyout-search', '&#9906;'.html_safe, :class => 'search-magnifier search-magnifier--flyout' 
 text_field_tag 'q', @question, :id => 'flyout-search', :class => 'small js-search-input', :placeholder => l(:label_search) 
 end 
 end 
 if User.current.logged? 
 if !Setting.gravatar_enabled? 
 end 
 if Setting.gravatar_enabled? 
 link_to(avatar(User.current, :size => "80"), user_path(User.current)) 
 end 
 link_to_user(User.current, :format => :username) 
 end 
 if display_main_menu?(@project) 
 l(:label_project) 
 end 
 l(:label_general) 
 l(:label_profile) 
 render_menu :account_menu 
 content_tag('div', "#{l(:label_logged_as)} #{link_to_user(User.current, :format => :username)}".html_safe, :id => 'loggedas') if User.current.logged? 
 render_menu :top_menu if User.current.logged? || !Setting.login_required? 
 if User.current.logged? || !Setting.login_required? 
 form_tag({:controller => 'search', :action => 'index', :id => @project}, :method => :get ) do 
 hidden_field_tag(controller.default_search_scope, 1, :id => nil) if controller.default_search_scope 
 link_to l(:label_search), {:controller => 'search', :action => 'index', :id => @project}, :accesskey => accesskey(:search) 
 text_field_tag 'q', @question, :size => 20, :class => 'small', :accesskey => accesskey(:quick_search) 
 end 
 render_project_jump_box 
 end 
 page_header_title 
 if display_main_menu?(@project) 
 render_main_menu(@project) 
 end 
 sidebar_content? ? '' : 'nosidebar' 
 yield :sidebar 
 view_layouts_base_sidebar_hook_response 
 render_flash_messages 
 yield 
 call_hook :view_layouts_base_content 
 l(:label_loading) 
 link_to Redmine::Info.app_name, Redmine::Info.url 
 call_hook :view_layouts_base_body_bottom 

 l(:label_preview) 
 textilizable @text, :attachments => @attachments, :object => @previewed 

end

private
  def find_message
    return unless find_board
    @message = @board.messages.includes(:parent).find(params[:id])
    @topic = @message.root
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_board
    @board = Board.includes(:project).find(params[:board_id])
    @project = @board.project
  rescue ActiveRecord::RecordNotFound
    render_404
    nil
  end
end
