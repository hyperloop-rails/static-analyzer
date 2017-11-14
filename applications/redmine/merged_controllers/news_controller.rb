
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

l(:label_news)
 labelled_form_for @news, :html => { :id => 'news-form', :multipart => true, :method => :put } do |f| 
 render :partial => 'form', :locals => { :f => f } 
 submit_tag l(:button_save) 
 preview_link preview_news_path(:project_id => @project, :id => @news), 'news-form' 
 end 
 content_for :header_tags do 
 stylesheet_link_tag 'scm' 
 end 

 error_messages_for @news 
 f.text_field :title, :required => true, :size => 60 
 f.text_area :summary, :cols => 60, :rows => 2 
 f.text_area :description, :required => true, :cols => 60, :rows => 15, :class => 'wiki-edit' 
 l(:label_attachment_plural) 
 render :partial => 'attachments/form', :locals => {:container => @news} 
 wikitoolbar_for 'news_description' 

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

class NewsController < ApplicationController
  default_search_scope :news
  model_object News
  before_action :find_model_object, :except => [:new, :create, :index]
  before_action :find_project_from_association, :except => [:new, :create, :index]
  before_action :find_project_by_project_id, :only => [:new, :create]
  before_action :authorize, :except => [:index]
  before_action :find_optional_project, :only => :index
  accept_rss_auth :index
  accept_api_auth :index

  helper :watchers
  helper :attachments

  def index
    case params[:format]
    when 'xml', 'json'
      @offset, @limit = api_offset_and_limit
    else
      @limit =  10
    end

    scope = @project ? @project.news.visible : News.visible

    @news_count = scope.count
    @news_pages = Paginator.new @news_count, @limit, params['page']
    @offset ||= @news_pages.offset
    @newss = scope.includes([:author, :project]).
                      order("#{News.table_name}.created_on DESC").
                      limit(@limit).
                      offset(@offset).
                      to_a
    respond_to do |format|
      format.html {
        @news = News.new # for adding news inline
        render :layout => false if request.xhr?
      }
      format.api
      format.atom { render_feed(@newss, :title => (@project ? @project.name : Setting.app_title) + ": #{l(:label_news_plural)}") }
    end
  
 link_to(l(:label_news_new),
            new_project_news_path(@project),
            :class => 'icon icon-add',
            :onclick => 'showAndScrollTo("add-news", "news_title"); return false;') if @project && User.current.allowed_to?(:manage_news, @project) 
 watcher_link(@project.enabled_module('news'), User.current) if @project && User.current.logged? 
l(:label_news_new)
 labelled_form_for @news, :url => project_news_index_path(@project),
                                           :html => { :id => 'news-form', :multipart => true } do |f| 
 render :partial => 'news/form', :locals => { :f => f } 
 submit_tag l(:button_create) 
 preview_link preview_news_path(:project_id => @project), 'news-form' 
 link_to l(:button_cancel), "#", :onclick => '$("#add-news").hide()' 
 end if @project 
l(:label_news_plural)
 if @newss.empty? 
 l(:label_no_data) 
 else 
 @newss.each do |news| 
 avatar(news.author, :size => "24") 
 link_to_project(news.project) + ': ' unless news.project == @project 
 link_to h(news.title), news_path(news) 
 "(#{l(:label_x_comments, :count => news.comments_count)})" if news.comments_count > 0 
 authoring news.created_on, news.author 
 textilizable(news, :description) 
 end 
 end 
 pagination_links_full @news_pages 
 other_formats_links do |f| 
 f.link_to 'Atom', :url => {:project_id => @project, :key => User.current.rss_key} 
 end 
 content_for :header_tags do 
 auto_discovery_link_tag(:atom, _project_news_path(@project, :key => User.current.rss_key, :format => 'atom')) 
 stylesheet_link_tag 'scm' 
 end 
 html_title(l(:label_news_plural)) 

 error_messages_for @news 
 f.text_field :title, :required => true, :size => 60 
 f.text_area :summary, :cols => 60, :rows => 2 
 f.text_area :description, :required => true, :cols => 60, :rows => 15, :class => 'wiki-edit' 
 l(:label_attachment_plural) 
 render :partial => 'attachments/form', :locals => {:container => @news} 
 wikitoolbar_for 'news_description' 

end

  def show
    @comments = @news.comments.to_a
    @comments.reverse! if User.current.wants_comments_in_reverse_order?
  
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

 watcher_link(@news, User.current) 
 link_to(l(:button_edit),
      edit_news_path(@news),
      :class => 'icon icon-edit',
      :accesskey => accesskey(:edit),
      :onclick => '$("#edit-news").show(); return false;') if User.current.allowed_to?(:manage_news, @project) 
 delete_link news_path(@news) if User.current.allowed_to?(:manage_news, @project) 
 avatar(@news.author, :size => "24") 
h @news.title 
 if authorize_for('news', 'edit') 
 labelled_form_for :news, @news, :url => news_path(@news),
                                           :html => { :id => 'news-form', :multipart => true, :method => :put } do |f| 
 render :partial => 'form', :locals => { :f => f } 
 submit_tag l(:button_save) 
 preview_link preview_news_path(:project_id => @project, :id => @news), 'news-form' 
 link_to l(:button_cancel), "#", :onclick => '$("#edit-news").hide(); return false;' 
 end 
 end 
 unless @news.summary.blank? 
 @news.summary 
 end 
 authoring @news.created_on, @news.author 
 textilizable(@news, :description) 
 link_to_attachments @news 
 l(:label_comment_plural) 
 @comments.each do |comment| 
 next if comment.new_record? 
 link_to_if_authorized l(:button_delete), {:controller => 'comments', :action => 'destroy', :id => @news, :comment_id => comment},
                              :data => {:confirm => l(:text_are_you_sure)}, :method => :delete,
                              :title => l(:button_delete),
                              :class => 'icon-only icon-del' 
 avatar(comment.author, :size => "24") 
 authoring comment.created_on, comment.author 
 textilizable(comment.comments) 
 end if @comments.any? 
 if @news.commentable? 
 toggle_link l(:label_comment_add), "add_comment_form", :focus => "comment_comments" 
 form_tag({:controller => 'comments', :action => 'create', :id => @news}, :id => "add_comment_form", :style => "display:none;") do 
 text_area 'comment', 'comments', :cols => 80, :rows => 15, :class => 'wiki-edit' 
 wikitoolbar_for 'comment_comments' 
 submit_tag l(:button_add) 
 end 
 end 
 html_title @news.title 
 content_for :header_tags do 
 stylesheet_link_tag 'scm' 
 end 

 error_messages_for @news 
 f.text_field :title, :required => true, :size => 60 
 f.text_area :summary, :cols => 60, :rows => 2 
 f.text_area :description, :required => true, :cols => 60, :rows => 15, :class => 'wiki-edit' 
 l(:label_attachment_plural) 
 render :partial => 'attachments/form', :locals => {:container => @news} 
 wikitoolbar_for 'news_description' 

end

  def new
    @news = News.new(:project => @project, :author => User.current)
  
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

l(:label_news_new)
 labelled_form_for @news, :url => project_news_index_path(@project),
                                           :html => { :id => 'news-form', :multipart => true } do |f| 
 render :partial => 'news/form', :locals => { :f => f } 
 submit_tag l(:button_create) 
 preview_link preview_news_path(:project_id => @project), 'news-form' 
 end 

 error_messages_for @news 
 f.text_field :title, :required => true, :size => 60 
 f.text_area :summary, :cols => 60, :rows => 2 
 f.text_area :description, :required => true, :cols => 60, :rows => 15, :class => 'wiki-edit' 
 l(:label_attachment_plural) 
 render :partial => 'attachments/form', :locals => {:container => @news} 
 wikitoolbar_for 'news_description' 

end

  def create
    @news = News.new(:project => @project, :author => User.current)
    @news.safe_attributes = params[:news]
    @news.save_attachments(params[:attachments])
    if @news.save
      render_attachment_warning_if_needed(@news)
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_news_index_path(@project)
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

l(:label_news_new)
 labelled_form_for @news, :url => project_news_index_path(@project),
                                           :html => { :id => 'news-form', :multipart => true } do |f| 
 render :partial => 'news/form', :locals => { :f => f } 
 submit_tag l(:button_create) 
 preview_link preview_news_path(:project_id => @project), 'news-form' 
 end 

 error_messages_for @news 
 f.text_field :title, :required => true, :size => 60 
 f.text_area :summary, :cols => 60, :rows => 2 
 f.text_area :description, :required => true, :cols => 60, :rows => 15, :class => 'wiki-edit' 
 l(:label_attachment_plural) 
 render :partial => 'attachments/form', :locals => {:container => @news} 
 wikitoolbar_for 'news_description' 

end

  def edit
  end

  def update
    @news.safe_attributes = params[:news]
    @news.save_attachments(params[:attachments])
    if @news.save
      render_attachment_warning_if_needed(@news)
      flash[:notice] = l(:notice_successful_update)
      redirect_to news_path(@news)
    else
      render :action => 'edit'
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

l(:label_news)
 labelled_form_for @news, :html => { :id => 'news-form', :multipart => true, :method => :put } do |f| 
 render :partial => 'form', :locals => { :f => f } 
 submit_tag l(:button_save) 
 preview_link preview_news_path(:project_id => @project, :id => @news), 'news-form' 
 end 
 content_for :header_tags do 
 stylesheet_link_tag 'scm' 
 end 

 error_messages_for @news 
 f.text_field :title, :required => true, :size => 60 
 f.text_area :summary, :cols => 60, :rows => 2 
 f.text_area :description, :required => true, :cols => 60, :rows => 15, :class => 'wiki-edit' 
 l(:label_attachment_plural) 
 render :partial => 'attachments/form', :locals => {:container => @news} 
 wikitoolbar_for 'news_description' 

end

  def destroy
    @news.destroy
    redirect_to project_news_index_path(@project)
  
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

  def find_optional_project
    return true unless params[:project_id]
    @project = Project.find(params[:project_id])
    authorize
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
