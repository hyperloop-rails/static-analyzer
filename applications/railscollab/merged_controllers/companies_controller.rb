#==
# RailsCollab
# Copyright (C) 2007 - 2011 James S Urquhart
# Portions Copyright (C) René Scheibe
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++

class CompaniesController < ApplicationController

  layout 'administration'

  before_filter :process_session
  before_filter :obtain_company, :except => [:index, :create, :new]
  after_filter  :user_track, :only => [:card]
  after_filter  :reload_owner

  def show
    authorize! :show, @company
    
    respond_to do |format|
      format.html { }
      
      format.xml  {
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
  card.logo_url 
 h card.name 
 h card.name 
 t('email_address') 
 card.email 
 card.email 
 t('phone_number') 
 (not (card.phone_number.nil? or card.phone_number.empty?)) ? h(card.phone_number) : "N/A" 
 t('fax_number') 
 (not (card.fax_number.nil? or card.fax_number.empty?)) ? h(card.fax_number) : "N/A" 
 if card.homepage.nil? or card.homepage.empty? 
 t('homepage') 
 "N/A" 
 else 
 t('homepage') 
 h card.homepage 
 h card.homepage 
 end 
 if !card.address.nil? or !(card.city.nil? and card.state.nil?) 
 t('address') 
 if !card.address.nil? and !card.address.empty? 
 h card.address 
 end 
 if !card.address2.nil? and !card.address2.empty? 
 h card.address2 
 end 
 if !card.city.nil? and !card.city.empty? and !card.state.nil? and !card.state.empty? 
 h card.city 
 h card.state 
 if !card.zipcode.nil? and !card.zipcode.empty? 
 h card.zipcode 
 end 
 end 
 if !card.country.nil? and !card.country.empty? 
 h card.country 
 end 
 end 
 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end
 
      }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
  card.logo_url 
 h card.name 
 h card.name 
 t('email_address') 
 card.email 
 card.email 
 t('phone_number') 
 (not (card.phone_number.nil? or card.phone_number.empty?)) ? h(card.phone_number) : "N/A" 
 t('fax_number') 
 (not (card.fax_number.nil? or card.fax_number.empty?)) ? h(card.fax_number) : "N/A" 
 if card.homepage.nil? or card.homepage.empty? 
 t('homepage') 
 "N/A" 
 else 
 t('homepage') 
 h card.homepage 
 h card.homepage 
 end 
 if !card.address.nil? or !(card.city.nil? and card.state.nil?) 
 t('address') 
 if !card.address.nil? and !card.address.empty? 
 h card.address 
 end 
 if !card.address2.nil? and !card.address2.empty? 
 h card.address2 
 end 
 if !card.city.nil? and !card.city.empty? and !card.state.nil? and !card.state.empty? 
 h card.city 
 h card.state 
 if !card.zipcode.nil? and !card.zipcode.empty? 
 h card.zipcode 
 end 
 end 
 if !card.country.nil? and !card.country.empty? 
 h card.country 
 end 
 end 
 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end

  end

  def index
    company = Company.owner
  	clients = Company.owner.clients(true)
  	@companies = [company] + clients
    respond_to do |format|
      format.html
      format.xml  {
        if @logged_user.is_admin
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 

  @page_actions = []
  
  if can? :create_company, current_user
  	@page_actions << {:title => :add_client, :url => new_company_path}
  end
  
  if can? :create_user, current_user
  	@page_actions << {:title => :add_user, :url => new_user_path}
  end

  company = people_list; company_card = company 
 h company.name 
 link_to company do 
 company_card.logo_url 
 h company_card.name 
 end 
 link_to (h company_card.name), company 
 if company_card.email? 
 h company_card.email 
 h company_card.email 
 end 
 if company_card.homepage? 
 link_to h(company_card.homepage), company_card.homepage 
 end 
 if company_card.fax_number? 
 t('fax') 
 h(company_card.fax_number) 
 end 
 if company_card.phone_number? 
 t('home') 
 h(company_card.phone_number) 
 end 
 if company_card.address? 
 h company_card.address 
 end 
 if company_card.address2? 
 h company_card.address2 
 end 
 if company_card.city? and company_card.state? 
 h company_card.city 
 h company_card.state 
 if company_card.zipcode? 
 h company_card.zipcode 
 end 
 if company_card.country? 
 h company_card.country 
 end 
 end 
 if can? :edit, company_card 
 action_list actions_for_company(company) 
 end 
 num_users = 1 
 users = @active_project.nil? ? company.users : company.users_on_project(@active_project) 
 (users.sort{ |x,y| x.display_name <=> y.display_name }).each do |user| 
 user_card = user 
 link_to user do 
 user_card.avatar_url 
 h user_card.display_name 
 end 
 link_to (h user_card.display_name), user 
 if user_card.title? 
 h user_card.title 
 end 
 h user_card.email 
 h user_card.email 
 user_card.im_values.each do |im_value| 
 next if im_value.value.blank? 
 im_value.im_type.icon_url 
 im_value.im_type.name 
 h im_value.value 
 end 
 if user_card.office_number? 
 t('office') 
 h(user_card.office_number) 
 end 
 if user_card.fax_number? 
 t('fax') 
 h(user_card.fax_number) 
 end 
 if user_card.mobile_number? 
 t('mobile') 
 h(user_card.mobile_number) 
 end 
 if user_card.home_number? 
 t('home') 
 h(user_card.home_number) 
 end 
 if user_card.owner_of_owner? 
 t('owner') 
 end 
 if can?(:update_profile, user_card) 
 action_list actions_for_user(user_card) 
 end 
 num_users += 1 
 if num_users % 3 == 0 
 end 
 end 
 unless num_users % 3 == 0 
 end 
 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end

        else
          return error_status(true, :insufficient_permissions)
        end
      }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 

  @page_actions = []
  
  if can? :create_company, current_user
  	@page_actions << {:title => :add_client, :url => new_company_path}
  end
  
  if can? :create_user, current_user
  	@page_actions << {:title => :add_user, :url => new_user_path}
  end

  company = people_list; company_card = company 
 h company.name 
 link_to company do 
 company_card.logo_url 
 h company_card.name 
 end 
 link_to (h company_card.name), company 
 if company_card.email? 
 h company_card.email 
 h company_card.email 
 end 
 if company_card.homepage? 
 link_to h(company_card.homepage), company_card.homepage 
 end 
 if company_card.fax_number? 
 t('fax') 
 h(company_card.fax_number) 
 end 
 if company_card.phone_number? 
 t('home') 
 h(company_card.phone_number) 
 end 
 if company_card.address? 
 h company_card.address 
 end 
 if company_card.address2? 
 h company_card.address2 
 end 
 if company_card.city? and company_card.state? 
 h company_card.city 
 h company_card.state 
 if company_card.zipcode? 
 h company_card.zipcode 
 end 
 if company_card.country? 
 h company_card.country 
 end 
 end 
 if can? :edit, company_card 
 action_list actions_for_company(company) 
 end 
 num_users = 1 
 users = @active_project.nil? ? company.users : company.users_on_project(@active_project) 
 (users.sort{ |x,y| x.display_name <=> y.display_name }).each do |user| 
 user_card = user 
 link_to user do 
 user_card.avatar_url 
 h user_card.display_name 
 end 
 link_to (h user_card.display_name), user 
 if user_card.title? 
 h user_card.title 
 end 
 h user_card.email 
 h user_card.email 
 user_card.im_values.each do |im_value| 
 next if im_value.value.blank? 
 im_value.im_type.icon_url 
 im_value.im_type.name 
 h im_value.value 
 end 
 if user_card.office_number? 
 t('office') 
 h(user_card.office_number) 
 end 
 if user_card.fax_number? 
 t('fax') 
 h(user_card.fax_number) 
 end 
 if user_card.mobile_number? 
 t('mobile') 
 h(user_card.mobile_number) 
 end 
 if user_card.home_number? 
 t('home') 
 h(user_card.home_number) 
 end 
 if user_card.owner_of_owner? 
 t('owner') 
 end 
 if can?(:update_profile, user_card) 
 action_list actions_for_user(user_card) 
 end 
 num_users += 1 
 if num_users % 3 == 0 
 end 
 end 
 unless num_users % 3 == 0 
 end 
 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end

  end

  def new
    authorize! :create_company, current_user
    
    @company = Company.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
 form_tag companies_path 
  error_messages_for :company 
 t('name') 
 text_field 'company', 'name', :id => 'clientFormName' 
 t('timezone') 
 time_zone_select 'company', 'time_zone', nil, {}, {:id => 'clientFormTimezone', :class => 'long'} 
 t('contact_online') 
 t('email_address') 
 text_field 'company', 'email', :id => 'clientFormEmail' 
 t('homepage') 
 text_field 'company', 'homepage', :id => 'clientFormHomepage' 
 t('phone_numbers') 
 t('phone_number') 
 text_field 'company', 'phone_number', :id => 'clientFormPhoneNumber' 
 t('fax_number') 
 text_field 'company', 'fax_number', :id => 'clientFormFaxNumber' 
 t('address') 
 t('address') 
 text_field 'company', 'address', :id => 'clientFormAddress' 
 I18n.t('address_2') 
 text_field 'company', 'address2', :id => 'clientFormAddress2' 
 t('city') 
 text_field 'company', 'city', :id => 'clientFormCity' 
 t('state') 
 text_field 'company', 'state', :id => 'clientFormState' 
 t('zipcode') 
 text_field 'company', 'zipcode', :id => 'clientFormZipcode' 
 t('country') 
 text_field 'company', 'country', :id => 'clientFormCountry', :limit => 100 
 
 t('add_client') 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end

  end

  def create
    authorize! :create_company, current_user

    @company = Company.new

    @company.attributes = params[:company]
    @company.client_of = Company.owner
    @company.created_by = @logged_user

    respond_to do |format|
      if @company.save
        format.html {
          error_status(false, :success_added_client)
          redirect_back_or_default :controller => 'administration', :action => 'people'
        }
        
        format.xml  { render :xml => @company.to_xml(:root => 'company'), :status => :created, :location => @company }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
 form_tag companies_path 
  error_messages_for :company 
 t('name') 
 text_field 'company', 'name', :id => 'clientFormName' 
 t('timezone') 
 time_zone_select 'company', 'time_zone', nil, {}, {:id => 'clientFormTimezone', :class => 'long'} 
 t('contact_online') 
 t('email_address') 
 text_field 'company', 'email', :id => 'clientFormEmail' 
 t('homepage') 
 text_field 'company', 'homepage', :id => 'clientFormHomepage' 
 t('phone_numbers') 
 t('phone_number') 
 text_field 'company', 'phone_number', :id => 'clientFormPhoneNumber' 
 t('fax_number') 
 text_field 'company', 'fax_number', :id => 'clientFormFaxNumber' 
 t('address') 
 t('address') 
 text_field 'company', 'address', :id => 'clientFormAddress' 
 I18n.t('address_2') 
 text_field 'company', 'address2', :id => 'clientFormAddress2' 
 t('city') 
 text_field 'company', 'city', :id => 'clientFormCity' 
 t('state') 
 text_field 'company', 'state', :id => 'clientFormState' 
 t('zipcode') 
 text_field 'company', 'zipcode', :id => 'clientFormZipcode' 
 t('country') 
 text_field 'company', 'country', :id => 'clientFormCountry', :limit => 100 
 
 t('add_client') 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end
 }
        
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    authorize! :edit, @company
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
 form_tag company_path(:id => @company.id), :method => :put 
  error_messages_for :company 
 t('name') 
 text_field 'company', 'name', :id => 'clientFormName' 
 t('timezone') 
 time_zone_select 'company', 'time_zone', nil, {}, {:id => 'clientFormTimezone', :class => 'long'} 
 t('contact_online') 
 t('email_address') 
 text_field 'company', 'email', :id => 'clientFormEmail' 
 t('homepage') 
 text_field 'company', 'homepage', :id => 'clientFormHomepage' 
 t('phone_numbers') 
 t('phone_number') 
 text_field 'company', 'phone_number', :id => 'clientFormPhoneNumber' 
 t('fax_number') 
 text_field 'company', 'fax_number', :id => 'clientFormFaxNumber' 
 t('address') 
 t('address') 
 text_field 'company', 'address', :id => 'clientFormAddress' 
 I18n.t('address_2') 
 text_field 'company', 'address2', :id => 'clientFormAddress2' 
 t('city') 
 text_field 'company', 'city', :id => 'clientFormCity' 
 t('state') 
 text_field 'company', 'state', :id => 'clientFormState' 
 t('zipcode') 
 text_field 'company', 'zipcode', :id => 'clientFormZipcode' 
 t('country') 
 text_field 'company', 'country', :id => 'clientFormCountry', :limit => 100 
 
 t('edit_company') 
 form_tag(logo_company_path(:id => @company.id), :method => :put, :multipart => true) 
 t('current_logo') 
 if @company.has_logo? 
 @company.logo_url 
 h @company.name 
 link_to t('delete_current_logo'), logo_company_path(:id => @company.id), {:onclick => t('current_logo_confirm_delete'), :method => :delete} 
 else 
 t('logo_not_uploaded') 
 end 
 t('new_logo') 
 if @company.has_logo? 
 t('logo_replace_info') 
 end 
 t('update_logo') 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end

  end
  
  def update
    authorize! :edit, @company

    @company.attributes = params[:company]
    @company.updated_by = @logged_user

    respond_to do |format|
      if @company.save
        format.html {
          error_status(false, :success_edited_client)
          redirect_back_or_default :controller => 'administration', :action => 'people'
        }
        
        format.xml  { head :ok }
      else
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
 form_tag company_path(:id => @company.id), :method => :put 
  error_messages_for :company 
 t('name') 
 text_field 'company', 'name', :id => 'clientFormName' 
 t('timezone') 
 time_zone_select 'company', 'time_zone', nil, {}, {:id => 'clientFormTimezone', :class => 'long'} 
 t('contact_online') 
 t('email_address') 
 text_field 'company', 'email', :id => 'clientFormEmail' 
 t('homepage') 
 text_field 'company', 'homepage', :id => 'clientFormHomepage' 
 t('phone_numbers') 
 t('phone_number') 
 text_field 'company', 'phone_number', :id => 'clientFormPhoneNumber' 
 t('fax_number') 
 text_field 'company', 'fax_number', :id => 'clientFormFaxNumber' 
 t('address') 
 t('address') 
 text_field 'company', 'address', :id => 'clientFormAddress' 
 I18n.t('address_2') 
 text_field 'company', 'address2', :id => 'clientFormAddress2' 
 t('city') 
 text_field 'company', 'city', :id => 'clientFormCity' 
 t('state') 
 text_field 'company', 'state', :id => 'clientFormState' 
 t('zipcode') 
 text_field 'company', 'zipcode', :id => 'clientFormZipcode' 
 t('country') 
 text_field 'company', 'country', :id => 'clientFormCountry', :limit => 100 
 
 t('edit_company') 
 form_tag(logo_company_path(:id => @company.id), :method => :put, :multipart => true) 
 t('current_logo') 
 if @company.has_logo? 
 @company.logo_url 
 h @company.name 
 link_to t('delete_current_logo'), logo_company_path(:id => @company.id), {:onclick => t('current_logo_confirm_delete'), :method => :delete} 
 else 
 t('logo_not_uploaded') 
 end 
 t('new_logo') 
 if @company.has_logo? 
 t('logo_replace_info') 
 end 
 t('update_logo') 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end
 }
        
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def hide_welcome_info
    error_status(true, :invalid_company) unless @company.is_owner?
    authorize! :edit, @company

    @company.hide_welcome_info = true
    saved = @company.save
    
    respond_to do |format|
      format.html {
        redirect_back_or_default :controller => 'dashboard'
      }
    end
  end

  def destroy
    authorize! :delete, @company

    estatus = :success_deleted_client
  	begin
      @company.destroy
  	rescue
      estatus = :error_deleting_client
  	end

    respond_to do |format|
      format.html {
        error_status(false, estatus)
        redirect_back_or_default :controller => 'administration', :action => 'people'
      }
      
      format.xml  { head :ok }
    end
  end

  def permissions
    authorize! :manage, @company

  	@projects = Project.all(:order => 'name')
  	if @projects.empty?
      error_status(true, :no_projects)
      redirect_back_or_default :controller => 'administration', :action => 'people'
      return
  	end

    case request.request_method_symbol
    when :put
      project_list = params[:project]
      project_list ||= []
      project_ids = project_list.collect{ |ids| ids.to_i }

      # Add and remove project associations
      @projects.each do |project|
        next unless @logged_user.member_of(project)

        if project_ids.include?(project.id)
          begin
            project.companies.find(@company.id)
          rescue ActiveRecord::RecordNotFound
            project.companies << @company
          end
        else
          project.companies.delete(@company)
        end
      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 form_authenticity_token 
 "#{h(page_title)} @ #{h(Company.owner.name)}" 
 stylesheet_link_tag 'project_website' 
 additional_stylesheets.each do |ss| 
 stylesheet_link_tag ss 
 end unless additional_stylesheets.nil? 
 javascript_include_tag 'jquery.js' 
 javascript_include_tag 'jquery-ui.js' 
 javascript_include_tag 'jrails.js' 
 javascript_include_tag 'application.js' 
 link_to t('administration'), :controller => 'administration' 
  if user.is_anonymous? 
 t('welcome_anonymous') 
 link_to(t('login'), logout_path) 
 else 
 t('welcome_back', :user => h(user.display_name)).html_safe 
 link_to t('logout'), logout_path, :confirm => t('are_you_sure_logout') 
 end 
 @running_times.empty? ? 'none' : 'block' 
 t('running_times', :count => @running_times.size) 
 render_icon 'bullet_drop_down', '', :id => 'running_times', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 unless user.is_anonymous? 
 link_to t('account'), @logged_user 
 render_icon 'bullet_drop_down', '', :id => 'account_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless projects.blank? 
 link_to t('projects'), :controller => 'dashboard', :action => 'my_projects' 
 render_icon 'bullet_drop_down', '', :id => 'projects_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 if user.is_admin 
 link_to t('administration'), :controller => 'administration' 
 render_icon 'bullet_drop_down', '', :id => 'administration_more', :class => 'PopupMenuWidgetAttachTo', :title => 'Enable javascript' 
 end 
 unless user.is_anonymous? 
 t('account') 
 link_to t('edit_profile'), edit_user_path(:id => user.id) 
 link_to t('update_avatar'), avatar_user_path(:id => user.id) 
 t('userbox_more') 
 link_to t('my_projects'), :controller => 'dashboard', :action => 'my_projects' 
 link_to t('my_tasks'), :controller => 'dashboard', :action => 'my_tasks' 
 end 
 unless projects.blank? 
 t('projects') 
 projects.each do |project| 
 link_to h(project.name), project_path(:id => project.id) 
 end 
 end 
 if user.is_admin 
 t('administration') 
 link_to t('company'), Company.owner 
 link_to t('members'), companies_path 
 link_to t('projects'), projects_path 
 end 
  listed.id 
 link_to h(listed.name), listed.object_url 
 link_to render_icon('stop', t('stop_time')), stop_time_path(:active_project => listed.project_id , :id => listed.id), :class => 'blank stopTime' 
 
 
  unless tabs.nil? 
 current_tab = self.current_tab 
 tabs.each do |item| 
 "item_#{item[:id]}" 
 'class="active"'.html_safe if item[:id] == current_tab 
 item[:url] 
 t(item[:id]) 
 end 
 end 
 
  unless crumbs.nil? 
 crumbs.each do |crumb| 
 if crumb[:url] 
 crumb[:url] 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 else 
 crumb[:title].is_a?(Symbol) ? t(crumb[:title]) : h(crumb[:title]) 
 end 
 end 
 end 
 
 if flash[:message] 
 flash[:error] ? 'error' : 'success' 
 flash[:error] ? 'flash_error' : 'flash_success' 
 h flash[:message] 
 end 
 h page_title 
 @content_for_sidebar.nil? ? '' : 'class=\'sidebar\'' 
  page_actions.each do |action| 
 action[:url] 
 action[:ajax] ? 'class="ajax_action"' : 'class="action"' 
 action[:title] 
 t(action[:title]) 
 end 
 
 if @projects.length > 0 
 t('hint') 
 t('hint_permissions_info') 
 form_tag permissions_company_path(:id => @company.id), :method => :put 
 @projects.each do |project| 
 check_box_tag "project[]", project.id.to_s, @company.is_part_of(project), {:id => "projectPermissionsCheckbox#{project.id}", :disabled => !@logged_user.member_of(project)} 
 "projectPermissionsCheckbox#{project.id}" 
 if !project.is_active? 
 t('project_completed_on', :date => format_usertime(project.completed_on, :project_created_format), :user => h(project.completed_by.display_name)) 
 h project.name 
 else 
 h project.name 
 end 
 end 
 t('update_permissions') 
 end 
 unless @content_for_sidebar.nil? 
 render :partial => @content_for_sidebar 
 end 
  if not Company.owner.homepage.nil? 
 Company.owner.homepage 
 Company.owner.name 
 else 
 Company.owner.name 
 end 
 product_signature 
 

end

  end

  def logo
    authorize! :edit, @company
    
    case request.request_method_symbol
    when :put
      company_attribs = params[:company]

      new_logo = company_attribs[:logo]
      @company.errors.add(:logo, 'Required') if new_logo.nil?
      @company.logo = new_logo

      return unless @company.errors.empty?

      if @company.save
        error_status(false, :success_updated_logo)
      else
        error_status(true, :error_uploading_logo)
      end
      
      redirect_to edit_company_path(:id => @company.id)
      
    when :delete
      @company.logo = nil
      @company.save

      error_status(false, :success_deleted_logo)
      redirect_to edit_company_path(:id => @company.id)
    end
  end

  private

  def obtain_company
    begin
      @company = Company.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error_status(true, :invalid_company)
      redirect_back_or_default :controller => 'dashboard'
      return false
    end

    true
  end
end
