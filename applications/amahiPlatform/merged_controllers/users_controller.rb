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

class UsersController < ApplicationController

	before_filter :admin_required
	before_filter :no_subtabs

	helper_method :can_i_toggle_admin?

	def index
		@page_title = t('users')
		@users = User.all_users
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @users.any?
 
 ::Temple::Utils.escape_html((t('username'))) 
 ::Temple::Utils.escape_html((t('full_name'))) 
 ::Temple::Utils.escape_html((render @users)) 
 else
 
 ::Temple::Utils.escape_html((t('there_are_no_users'))) 
 end 
 ::Temple::Utils.escape_html((button_tag t('new_user'), :type => 'button', :class => 'open-area btnn btn-create btn btn-info pull-left', :id => "new-user-to-step1",  :data => { :related => "#new-user-step1" })) 
 ::Temple::Utils.escape_html(( @user = @user || User.new

_slim_controls1 = form_for @user, :url => users_engine.users_path,
:remote => true, \
:html => { \
:data => { \
:ok_icon_path => theme_image_path('ok.png'), \
:error_icon_path => theme_image_path('stop.png') \
}, \
:class => 'user create-form form-horizontal', \
:id => 'new-user-form' \
} do |f|

 
 ::Temple::Utils.escape_html((t('create_a_new_user'))) 
 ::Temple::Utils.escape_html((f.text_field :login, :size => 16, :maxlength => 20, :class=>'form-control',:placeholder => t('username'))) 
 ::Temple::Utils.escape_html((f.text_field :name, :size => 16, :maxlength => 64, :class=>'form-control', :placeholder => t('full_name'))) 
 ::Temple::Utils.escape_html((f.password_field :password, :size => 16, :maxlength => 24, :class=>'form-control',:placeholder => t('password'))) 
 ::Temple::Utils.escape_html((f.password_field :password_confirmation, :size => 16, :maxlength => 24, :class=>'form-control', :placeholder => t('confirm'))) 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((button_tag t('create'), :type => 'submit', :id => 'user_create_button', :class => 'btnn btn-create btn btn-info')) 
 ::Temple::Utils.escape_html((link_to t('cancel'), '#', :class => 'close-area cancel-link btn btn-primary left-margin-10' , :data => {:related => '#new-user-to-step1'})) 
 end 
 ::Temple::Utils.escape_html((_slim_controls1)) 
)) 

end

	end

	def create
		sleep 2 if development?
		@user = User.new(params[:user])
		@user.save
		@users = User.all_users unless @user.errors.any?
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
self.formats = [:html]

if @user.errors.any?
  json.status :not_accepted
  json.content render(:partial => 'form', :object => @user)
else
  @user = nil
  json.status :ok
  json.content render(:template => 'users/index')
end

end

	end

	def update
		sleep 2 if development?
		user = User.find params[:id]
		name = user.name
		if can_i_edit_details?(user)
			if(params[:name].strip.length !=0)
				user.name = params[:name]
				user.save!
				name = user.name
				errors = user.errors.any? ? user.error.full_messages.join(', ') : false
			else
				errors = t('the_name_cannot_be_blank')
			end
		else
			errors = t('dont_have_permissions')
		end
		render :json => { :status => errors ? :not_acceptable : :ok , :message => errors ? errors : t('name_changed_successfully') , :name=> name, :id=>params[:id] }
	end

	def update_pubkey
		sleep 2 if development?
		@user = User.find(params[:id])
		# sleep a little to see the spinner working well
		unless @user
			render :json => { :status => :not_acceptable }
		else
			key = params["public_key_#{params[:id]}"]
			key = nil if key.blank?
			@user.public_key=key
			@user.save
			render :json => { :status => @user.errors.empty? ? :ok : { :messages => @user.errors.full_messages } }
		end
	end

	def destroy
		sleep 2 if development?
		@user = User.find(params[:id])
		id = nil
		if @user && @user != current_user && !@user.admin?
			@user.destroy
			id = @user.id unless @user.errors.any?
			render :json => { :status => id==nil ? t('error_occured') : :ok, :id => id }
		else
		render :json => { status: 'not_acceptable' , id: id }
		end
	end

	def toggle_admin
		sleep 2 if development?
		user = User.find params[:id]
		if can_i_toggle_admin?(user)
			user.admin = !user.admin
			user.save!
			@saved = true
		end
		render :json => { :status => @saved ? :ok : :not_acceptable }
	end

	def update_password
		sleep 2 if development?
		@user = User.find(params[:id])
		if(params[:user][:password].blank? || params[:user][:password_confirmation].blank?)
			errors = true
			error = t("password_cannot_be_blank")
		else
			@user.update_attributes(params[:user])
			errors = @user.errors.any?
			error = @user.errors.full_messages.join(', ')
		end
		render :json => { :status => errors ? :not_acceptable : :ok, :message => errors ?  error : t('password_changed_successfully') }
	end

	def update_name
		@user = User.find(params[:id])
		@user.update_attributes(params[:user])
		render :json => { :status => @user.errors.any? ? :not_acceptable : :ok }
	end

	def settings
		unless @advanced
			redirect_to users_engine_path
		end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

	end

	protected

	def can_i_toggle_admin?(user)
		current_user != user and !user.needs_auth?
	end

	def can_i_edit_details?(user)
		(current_user == user || current_user.admin?)
	end

end
