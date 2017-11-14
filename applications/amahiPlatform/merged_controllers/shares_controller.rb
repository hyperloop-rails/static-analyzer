# Amahi Home Server
# Copyright (C) 2007-2013 Amahi
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License v3
# (29 June 2007), as published in the COPYING file.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# file COPYING for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the Amahi
# team at http://www.amahi.org/ under "Contact Us."

require "open3"

class SharesController < ApplicationController

	before_filter :admin_required

	before_filter :get_share

	def index
		@page_title = t('shares')
		get_shares
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @shares.any?
 
 ::Temple::Utils.escape_html((t('share'))) 
 ::Temple::Utils.escape_html((t('location'))) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((share.id)) 
 ::Temple::Utils.escape_html((link_to share.name, '#')) 
 ::Temple::Utils.escape_html((link_to path2location(share.name), path2uri(share.name))) 
 ::Temple::Utils.escape_html((t('edit_share'))) 
 ::Temple::Utils.escape_html((share.name)) 
 ::Temple::Utils.escape_html(("#{t('created')} #{formatted_date(share.created_at)}")) 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((link_to t('delete') + ' ' + share.name,
share_path(share),
:method => :delete,
:data => {:confirm => confirm_share_destroy_message(share.name)},
:remote => true,
:class => 'btn-delete remote-btn navbar-right btn btn-primary btn-sm')) 
 ::Temple::Utils.escape_html((t('access'))) 
 ::Temple::Utils.escape_html(( share = access

 
 ::Temple::Utils.escape_html((simple_remote_checkbox :id => "share_everyone_#{share.id}",
:css_class => 'share_everyone_checkbox',
:url => toggle_everyone_share_path(:id => share.id),
:label => t('all_users'),
:checked => share.everyone,
:no_spinner => true)) 
 if share.everyone
 
 ::Temple::Utils.escape_html((simple_remote_checkbox :id => "share_readonly_#{share.id}",
:css_class => 'share_readonly_checkbox',
:url => toggle_readonly_share_path(:id => share.id),
:label => t('writeable'),
:checked => !share.rdonly,
:no_spinner => true)) 
 end 
 ::Temple::Utils.escape_html((spinner)) 
 unless share.everyone or User.count < 1
 
 ::Temple::Utils.escape_html((t('users'))) 
 ::Temple::Utils.escape_html((t('access'))) 
 ::Temple::Utils.escape_html((t('writeable'))) 
 User.all.each do |user|
 
 ::Temple::Utils.escape_html((user.name)) 
 ::Temple::Utils.escape_html((simple_remote_checkbox :id => "share_access_for_user#{user.id}",
:css_class => 'share_access_checkbox',
:url => toggle_access_share_path(:id => share.id, :user_id => user.id),
:label => "",
:checked => share.users_with_share_access.include?(user),
:no_spinner => true)) 
 ::Temple::Utils.escape_html((simple_remote_checkbox :id => "share_write_for_user#{user.id}",
:css_class => 'share_write_checkbox',
:url => toggle_write_share_path(:id => share.id, :user_id => user.id),
:label => "",
:checked => share.users_with_write_access.include?(user),
:no_spinner => true,
:disabled => !share.users_with_share_access.include?(user))) 
 end 
 ::Temple::Utils.escape_html((t('anonymous_guests'))) 
 ::Temple::Utils.escape_html((simple_remote_checkbox :id => "share_guest_access_#{share.id}",
:css_class => 'share_guest_access_checkbox',
:url => toggle_guest_access_share_path(:id => share.id),
:label => "",
:checked => share.guest_access,
:no_spinner => true)) 
 ::Temple::Utils.escape_html((simple_remote_checkbox :id => "share_guest_writeable_#{share.id}",
:css_class => 'share_guest_writeable_checkbox',
:url => toggle_guest_writeable_share_path(:id => share.id),
:label => "",
:checked => share.guest_writeable,
:no_spinner => true,
:disabled => !share.guest_access)) 
 end 
)) 
 ::Temple::Utils.escape_html((t('visibility'))) 
 ::Temple::Utils.escape_html((simple_remote_checkbox :id => "share_visible_#{share.id}",
:css_class => 'share_visible_checkbox',
:url => toggle_visible_share_path(:id => share.id),
:label => "#{t('visible')}",
:checked => share.visible)) 
 ::Temple::Utils.escape_html((t('permissions'))) 
 ::Temple::Utils.escape_html(( share = permissions

 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((link_to content_tag('span', '', :class => 'tools'), clear_permissions_share_path(share), :remote => true, :method => 'put',
:class => 'clear-permissions remote-btn glyphicon glyphicon-wrench',
:title => t('this_will_clear_permissions_wide', :share => share.name),
:data => { :confirm => t('this_will_clear_permissions_wide', :share => share.name), :success => t('permissions_cleared'), :error => t('permissions_clearning_error') })) 
)) 
 if advanced?
 
 ::Temple::Utils.escape_html((t('tags'))) 
 ::Temple::Utils.escape_html(( share = tags

 
 ::Temple::Utils.escape_html((tags_to_str(share.tags))) 
 ::Temple::Utils.escape_html((spinner)) 
 [t('music'), t('pictures'), t('videos'), t('docs'), t('tv'), t('movies')].each_with_index do |tag, i|
 
 ::Temple::Utils.escape_html((simple_remote_checkbox :id => "share_visible_#{share.id}_#{i}",
:css_class => 'share_tags_checkbox',
:url => update_tags_share_path(:id => share.id, :name => tag),
:label => tag,
:checked => share.tags.include?(tag.downcase))) 
 end 
)) 
 end 
 ::Temple::Utils.escape_html((t('location'))) 
 ::Temple::Utils.escape_html((share.path)) 
 ::Temple::Utils.escape_html((t('size'))) 
 ::Temple::Utils.escape_html((link_to  content_tag(:span, t('get_the_size') ) ,
shares_engine.update_size_path(share),
:method => :put,
:remote => true,
:class  =>"update-size-area focus remote-bt size#{share.id} remote-check")) 
 ::Temple::Utils.escape_html((spinner)) 
 if advanced?
 
 ::Temple::Utils.escape_html((t('extra_parameters'))) 
 ::Temple::Utils.escape_html((share.extras.blank? ? t('add_extra_parameters') : share.extras)) 
 end 
)) 
 else
 
 ::Temple::Utils.escape_html((t('there_are_no_shares_created'))) 
 end 
 ::Temple::Utils.escape_html((button_tag t('new_share'), :type => 'button', :class => 'open-area btnn btn-create btn btn-info pull-left', :id => "new-share-to-step1",  :data => { :related => "#new-share-step1" })) 
 ::Temple::Utils.escape_html(( @share = @share || Share.new

_slim_controls1 = form_for @share, :remote => true, :html => { :class => 'share create-form form-horizontal', :id => 'new-share-form' } do |f|

 
 ::Temple::Utils.escape_html((t('create_a_new_share'))) 
 ::Temple::Utils.escape_html((f.text_field :name, :size => 16, :maxlength => 20, :class=>'form-control', :placeholder => "Name")) 
 ::Temple::Utils.escape_html((f.check_box :visible, { :checked => true,:class => 'right-margin-10' })) 
 ::Temple::Utils.escape_html((label(:visible, t('visible')))) 
 ::Temple::Utils.escape_html((f.check_box :rdonly, {:class => 'right-margin-10'})) 
 ::Temple::Utils.escape_html((label(:rdonly, t('read_only')))) 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((button_tag t('create'), :type => 'submit', :id => 'share_create_button', :class => 'btnn btn-create btn-info btn btn-sm')) 
 ::Temple::Utils.escape_html((link_to t('cancel'), '#', :class => 'close-area cancel-link btn btn-primary btn-sm left-margin-10', :data => {:related => '#new-share-to-step1'})) 
 end 
 ::Temple::Utils.escape_html((_slim_controls1)) 
)) 
 _slim_controls1 = content_for(:js_templates) do
 
 ::Temple::Utils.escape_html((render '/js_templates/shares/tags_form')) 
 ::Temple::Utils.escape_html((render '/js_templates/shares/path_form')) 
 ::Temple::Utils.escape_html((render '/js_templates/shares/extras_form')) 
 end 
 ::Temple::Utils.escape_html((_slim_controls1)) 

end

	end

	def create
		sleep 2 if development?
		params[:share][:path] = Share.default_full_path(params[:share][:name])
		@share = Share.new(params[:share])
		@share.save
		get_shares unless @share.errors.any?
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
self.formats = [:html]

if @share.errors.any?
  json.status :not_accepted
  json.content render(:partial => 'shares/form', :object => @share)
else
  @share = nil
  json.status :ok
  json.content render(:template => 'shares/index')
end

end

	end

	def destroy
		sleep 2 if development?
		@share.destroy
		render :json => { :status=> :ok,:id => @share.id }
	end

	def settings
		unless @advanced
			redirect_to shares_engine_path
		else
			@page_title = t('shares')
			@workgroup = Setting.find_or_create_by(Setting::GENERAL, 'workgroup', 'WORKGROUP')
		end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ::Temple::Utils.escape_html((@workgroup.try(:id))) 
 ::Temple::Utils.escape_html((t('shares_global_settings'))) 
 if @workgroup
 
 ::Temple::Utils.escape_html((t("workgroup_name"))) 
 ::Temple::Utils.escape_html((@workgroup.try(:value))) 
 ::Temple::Utils.escape_html((simple_remote_text    :id => "#{@workgroup.try(:id)}",
:input_id =>"text_workgroup_#{@workgroup.try(:id)}",
:form_id => "form_workgroup_#{@workgroup.try(:id)}",
:button_id => "change_workgroup_name_#{@workgroup.try(:id)}",
:url => "/shares/#{@workgroup.try(:id)}/update_workgroup",
:label => t("change"),
:value => "#{@workgroup.try(:value)}",
:name => "share[value]",
:method => :put,
:remote => true,
:form_css_class => "edit_workgroup_form form_hidden",
:cancel_class => "workgroup_cancel_link btn btn-primary btn-sm left-margin-10 ")) 
 end 
 ::Temple::Utils.escape_html((render '/js_templates/shares/path_form')) 

end

	end

	def toggle_visible
		sleep 2 if development?
		@saved = @share.toggle_visible! if @share
		render :json => { :status => @saved ? :ok : :not_acceptable }
	end

	def toggle_everyone
		sleep 2 if development?
		@saved = @share.toggle_everyone! if @share
		render_share_access
	end

	def toggle_readonly
		sleep 2 if development?
		@saved = @share.toggle_readonly! if @share
		render :json => { :status => @saved ? :ok : :not_acceptable }
	end

	def toggle_access
		sleep 2 if development?
		@saved = @share.toggle_access!(params[:user_id]) if @share
		render_share_access
	end

	def toggle_write
		sleep 2 if development?
		@saved = @share.toggle_write!(params[:user_id]) if @share
		render :json => { :status => @saved ? :ok : :not_acceptable }
	end

	def toggle_guest_access
		sleep 2 if development?
		@saved = @share.toggle_guest_access! if @share
		render_share_access
	end

	def toggle_guest_writeable
		sleep 2 if development?
		@saved = @share.toggle_guest_writeable! if @share
		render :json => { :status => @saved ? :ok : :not_acceptable }
	end

	def update_tags
		sleep 2 if development?
		@saved = @share.update_tags!(params)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
self.formats = [:html]
json.status @saved ? :ok : :not_accepted
json.content render(:partial => 'tags', :object => @share)

end

	end

	def update_path
		sleep 2 if development?
		@saved = @share.update_tags!(params)
		render :json => { :status => @saved ? :ok : :not_acceptable }
	end

	def update_workgroup
		sleep 2 if development?
		@workgroup = Setting.find(params[:id]) if params[:id]
		if @workgroup && @workgroup.name.eql?("workgroup")
			params[:share][:value].strip!
			@saved = @workgroup.update_attributes(params[:share])
			@errors = @workgroup.errors.full_messages.join(', ') unless @saved
			name = @workgroup.value
			Share.push_shares
		end
		render :json => { :status => @saved ? :ok : :not_acceptable, :message => @saved ? t('workgroup_changed_successfully') : t('error_occured'), :name => name }
	end

	def update_extras
		sleep 2 if development?
		params[:share] = sanitize_text(params[:share])
		@saved = @share.update_extras!(params)
		render :json => { :status => @saved ? :ok : :not_acceptable }
	end

	def clear_permissions
		@share = Share.find(params[:id]) if params[:id]
		sleep 2 if development?
		if @share
			@cleared = @share.clear_permissions
			render :json => { :status => :ok }
		else
			render :json => { :status => :not_acceptable }
		end
	end

	def update_size
		sleep 1 if development?
		begin
			std_out, status = Open3.capture2e("du -sbL #{@share.path}")
			size = std_out.split(' ').first
			is_integer = Integer(size) != nil rescue false
			if is_integer and status
				helper = Object.new.extend(ActionView::Helpers::NumberHelper)
				size = helper.number_to_human_size(size)
			else
				size = std_out
			end
		rescue Exception => e
			size = e.to_s
		end
		render :json => { status: :ok, size: size, id: @share.id }
	end

	protected

	def render_share_access
		render :json => render_to_string('shares/_access') and return
	end

	def get_share
		@share = Share.find(params[:id]) if params[:id]
	rescue
	end

	def get_shares
		@shares = Share.all
	end

end
