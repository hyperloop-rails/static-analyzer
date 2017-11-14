
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

 l(:label_board) 
 labelled_form_for @board, :url => project_board_path(@project, @board) do |f| 
 render :partial => 'form', :locals => {:f => f} 
 submit_tag l(:button_save) 
 end 

 error_messages_for @board 
 f.text_field :name, :required => true 
 f.text_field :description, :required => true, :size => 80 
 if @board.valid_parents.any? 
 f.select :parent_id, boards_options_for_select(@board.valid_parents), :include_blank => true, :label => :field_board_parent 
 end 

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

class BoardsController < ApplicationController
  default_search_scope :messages
  before_action :find_project_by_project_id, :find_board_if_available, :authorize
  accept_rss_auth :index, :show

  helper :sort
  include SortHelper
  helper :watchers

  def index
    @boards = @project.boards.preload(:project, :last_message => :author).to_a
    # show the board if there is only one
    if @boards.size == 1
      @board = @boards.first
      show
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

 l(:label_board_plural) 
 l(:label_board) 
 l(:label_topic_plural) 
 l(:label_message_plural) 
 l(:label_message_last) 
 Board.board_tree(@boards) do |board, level| 
 cycle 'odd', 'even' 
 level * 18 
 link_to board.name, project_board_path(board.project, board), :class => "board" 
h board.description 
 board.topics_count 
 board.messages_count 
 if board.last_message 
 authoring board.last_message.created_on, board.last_message.author 
 link_to_message board.last_message 
 end 
 end 
 other_formats_links do |f| 
 f.link_to 'Atom', :url => {:controller => 'activities', :action => 'index', :id => @project, :show_messages => 1, :key => User.current.rss_key} 
 end 
 content_for :header_tags do 
 auto_discovery_link_tag(:atom, {:controller => 'activities', :action => 'index', :id => @project, :format => 'atom', :show_messages => 1, :key => User.current.rss_key}) 
 end 
 html_title l(:label_board_plural) 

end

  def show
    respond_to do |format|
      format.html {
        sort_init 'updated_on', 'desc'
        sort_update 'created_on' => "#{Message.table_name}.id",
                    'replies' => "#{Message.table_name}.replies_count",
                    'updated_on' => "COALESCE(#{Message.table_name}.last_reply_id, #{Message.table_name}.id)"

        @topic_count = @board.topics.count
        @topic_pages = Paginator.new @topic_count, per_page_option, params['page']
        @topics =  @board.topics.
          reorder(:sticky => :desc).
          limit(@topic_pages.per_page).
          offset(@topic_pages.offset).
          order(sort_clause).
          preload(:author, {:last_reply => :author}).
          to_a
        @message = Message.new(:board => @board)
        render :action => 'show', :layout => !request.xhr?
      }
      format.atom {
        @messages = @board.messages.
          reorder(:id => :desc).
          includes(:author, :board).
          limit(Setting.feeds_limit.to_i).
          to_a
        render_feed(@messages, :title => "#{@project}: #{@board}")
      }
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

 board_breadcrumb(@board) 
 link_to l(:label_message_new),
            new_board_message_path(@board),
            :class => 'icon icon-add',
            :onclick => 'showAndScrollTo("add-message", "message_subject"); return false;' if User.current.allowed_to?(:add_messages, @board.project) 
 watcher_link(@board, User.current) 
 if User.current.allowed_to?(:add_messages, @board.project) 
 link_to @board.name, project_board_path(@project, @board) 
 l(:label_message_new) 
 form_for @message, :url => new_board_message_path(@board), :html => {:multipart => true, :id => 'message-form'} do |f| 
 render :partial => 'messages/form', :locals => {:f => f} 
 submit_tag l(:button_create) 
 preview_link(preview_board_message_path(@board), 'message-form') 
 link_to l(:button_cancel), "#", :onclick => '$("#add-message").hide(); return false;' 
 end 
 end 
 @board.name 
 @board.description 
 if @topics.any? 
 l(:field_subject) 
 l(:field_author) 
 sort_header_tag('created_on', :caption => l(:field_created_on)) 
 sort_header_tag('replies', :caption => l(:label_reply_plural)) 
 sort_header_tag('updated_on', :caption => l(:label_message_last)) 
 @topics.each do |topic| 
 topic.id 
 cycle 'odd', 'even' 
 topic.sticky? ? 'sticky' : '' 
 topic.locked? ? 'locked' : '' 
 link_to topic.subject, board_message_path(@board, topic) 
 link_to_user(topic.author) 
 format_time(topic.created_on) 
 topic.replies_count 
 if topic.last_reply 
 authoring topic.last_reply.created_on, topic.last_reply.author 
 link_to_message topic.last_reply 
 end 
 end 
 pagination_links_full @topic_pages, @topic_count 
 else 
 l(:label_no_data) 
 end 
 other_formats_links do |f| 
 f.link_to 'Atom', :url => {:key => User.current.rss_key} 
 end 
 html_title @board.name 
 content_for :header_tags do 
 auto_discovery_link_tag(:atom, {:format => 'atom', :key => User.current.rss_key}, :title => "#{@project}: #{@board}") 
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

  def new
    @board = @project.boards.build
    @board.safe_attributes = params[:board]
  
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

 l(:label_board_new) 
 labelled_form_for @board, :url => project_boards_path(@project) do |f| 
 render :partial => 'form', :locals => {:f => f} 
 submit_tag l(:button_create) 
 end 

 error_messages_for @board 
 f.text_field :name, :required => true 
 f.text_field :description, :required => true, :size => 80 
 if @board.valid_parents.any? 
 f.select :parent_id, boards_options_for_select(@board.valid_parents), :include_blank => true, :label => :field_board_parent 
 end 

end

  def create
    @board = @project.boards.build
    @board.safe_attributes = params[:board]
    if @board.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to_settings_in_projects
    else
      render :action => 'new'
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

 l(:label_board_new) 
 labelled_form_for @board, :url => project_boards_path(@project) do |f| 
 render :partial => 'form', :locals => {:f => f} 
 submit_tag l(:button_create) 
 end 

 error_messages_for @board 
 f.text_field :name, :required => true 
 f.text_field :description, :required => true, :size => 80 
 if @board.valid_parents.any? 
 f.select :parent_id, boards_options_for_select(@board.valid_parents), :include_blank => true, :label => :field_board_parent 
 end 

end

  def edit
  end

  def update
    @board.safe_attributes = params[:board]
    if @board.save
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_update)
          redirect_to_settings_in_projects
        }
        format.js { head 200 }
      end
    else
      respond_to do |format|
        format.html { render :action => 'edit' }
        format.js { head 422 }
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

 l(:label_board) 
 labelled_form_for @board, :url => project_board_path(@project, @board) do |f| 
 render :partial => 'form', :locals => {:f => f} 
 submit_tag l(:button_save) 
 end 

 error_messages_for @board 
 f.text_field :name, :required => true 
 f.text_field :description, :required => true, :size => 80 
 if @board.valid_parents.any? 
 f.select :parent_id, boards_options_for_select(@board.valid_parents), :include_blank => true, :label => :field_board_parent 
 end 

end

  def destroy
    @board.destroy
    redirect_to_settings_in_projects
  
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

private
  def redirect_to_settings_in_projects
    redirect_to settings_project_path(@project, :tab => 'boards')
  end

  def find_board_if_available
    @board = @project.boards.find(params[:id]) if params[:id]
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
