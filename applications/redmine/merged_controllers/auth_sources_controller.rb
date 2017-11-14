
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_auth_source_plural), auth_sources_path], @auth_source.name 
 labelled_form_for @auth_source, :as => :auth_source, :url => auth_source_path(@auth_source), :html => {:id => 'auth_source_form'} do |f| 
 render :partial => auth_source_partial_name(@auth_source), :locals => { :f => f } 
 submit_tag l(:button_save) 
 end 


 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_auth_source_plural), auth_sources_path], "#{l(:label_auth_source_new)} (#{@auth_source.auth_method_name})" 
 labelled_form_for @auth_source, :as => :auth_source, :url => auth_sources_path, :html => {:id => 'auth_source_form'} do |f| 
 hidden_field_tag 'type', @auth_source.type 
 render :partial => auth_source_partial_name(@auth_source), :locals => { :f => f } 
 submit_tag l(:button_create) 
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

class AuthSourcesController < ApplicationController
  layout 'admin'
  menu_item :ldap_authentication

  before_action :require_admin
  before_action :build_new_auth_source, :only => [:new, :create]
  before_action :find_auth_source, :only => [:edit, :update, :test_connection, :destroy]
  require_sudo_mode :update, :destroy

  def index
    @auth_source_pages, @auth_sources = paginate AuthSource, :per_page => 25
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 link_to l(:label_auth_source_new), {:action => 'new'}, :class => 'icon icon-add' 
 title l(:label_auth_source_plural) 
l(:field_name)
l(:field_type)
l(:field_host)
l(:label_user_plural)
 for source in @auth_sources 
 source.id 
 cycle("odd", "even") 
 link_to(source.name, :action => 'edit', :id => source)
 source.auth_method_name 
 source.host 
 source.users.count 
 link_to l(:button_test), try_connection_auth_source_path(source), :class => 'icon icon-test' 
 delete_link auth_source_path(source) 
 end 
 pagination_links_full @auth_source_pages 

end

  def new
  end

  def create
    if @auth_source.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to auth_sources_path
    else
      render :action => 'new'
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_auth_source_plural), auth_sources_path], "#{l(:label_auth_source_new)} (#{@auth_source.auth_method_name})" 
 labelled_form_for @auth_source, :as => :auth_source, :url => auth_sources_path, :html => {:id => 'auth_source_form'} do |f| 
 hidden_field_tag 'type', @auth_source.type 
 render :partial => auth_source_partial_name(@auth_source), :locals => { :f => f } 
 submit_tag l(:button_create) 
 end 

end

  def edit
  end

  def update
    @auth_source.safe_attributes = params[:auth_source]
    if @auth_source.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to auth_sources_path
    else
      render :action => 'edit'
    end
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

 title [l(:label_auth_source_plural), auth_sources_path], @auth_source.name 
 labelled_form_for @auth_source, :as => :auth_source, :url => auth_source_path(@auth_source), :html => {:id => 'auth_source_form'} do |f| 
 render :partial => auth_source_partial_name(@auth_source), :locals => { :f => f } 
 submit_tag l(:button_save) 
 end 

end

  def test_connection
    begin
      @auth_source.test_connection
      flash[:notice] = l(:notice_successful_connection)
    rescue Exception => e
      flash[:error] = l(:error_unable_to_connect, e.message)
    end
    redirect_to auth_sources_path
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

end

  def destroy
    unless @auth_source.users.exists?
      @auth_source.destroy
      flash[:notice] = l(:notice_successful_delete)
    end
    redirect_to auth_sources_path
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

end

  def autocomplete_for_new_user
    results = AuthSource.search(params[:term])

    render :json => results.map {|result| {
      'value' => result[:login],
      'label' => "#{result[:login]} (#{result[:firstname]} #{result[:lastname]})",
      'login' => result[:login].to_s,
      'firstname' => result[:firstname].to_s,
      'lastname' => result[:lastname].to_s,
      'mail' => result[:mail].to_s,
      'auth_source_id' => result[:auth_source_id].to_s
    }}
  
 unless controller_name == 'admin' && action_name == 'index' 
 content_for :sidebar do 
l(:label_administration)
 render :partial => 'admin/menu' 
 end 
 end 
 render :file => "layouts/base" 

end

  private

  def build_new_auth_source
    @auth_source = AuthSource.new_subclass_instance(params[:type] || 'AuthSourceLdap')
    if @auth_source
      @auth_source.safe_attributes = params[:auth_source]
    else
      render_404
    end
  end

  def find_auth_source
    @auth_source = AuthSource.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
