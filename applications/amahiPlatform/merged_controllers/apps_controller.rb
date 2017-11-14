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

class AppsController < ApplicationController

	before_filter :admin_required

	# make the JSON calls much more efficient by not invoking these filters
	skip_filter :before_filter_hook, except: [:index, :installed]
	skip_filter :prepare_plugins, except: [:index, :installed]

	def index
		set_title t('apps')
		@apps = App.available
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ::Temple::Utils.escape_html((link_to 'Get apps', 'https://www.amahi.org/apps', :title => 'Amahi App Store', :target => '_blank', :id => 'btn-get-apps')) 
 ::Temple::Utils.escape_html((link_to 'Install here!', apps_engine.root_path, :title => 'Refresh', :id => 'btn-install-apps')) 
 if @apps.any?
 
 ::Temple::Utils.escape_html((t('application'))) 
 ::Temple::Utils.escape_html((t('description'))) 
 ::Temple::Utils.escape_html(( app = app_available

_slim_controls1 = content_tag 'div', :class => 'app', :id => "app_whole_#{app.identifier}", :data => { :progress_path => apps_engine.install_progress_path(app.identifier) } do

 
 ::Temple::Utils.escape_html((app.identifier)) 
 ::Temple::Utils.escape_html((link_to name_with_warning(app), '#')) 
 ::Temple::Utils.escape_html((app.identifier)) 
 ::Temple::Utils.escape_html((short_desc(app))) 
 ::Temple::Utils.escape_html((app.identifier)) 
 ::Temple::Utils.escape_html((display_style)) 
 ::Temple::Utils.escape_html((app.name)) 
 ::Temple::Utils.escape_html((t('available_for_installation'))) 
 ::Temple::Utils.escape_html((app.webapp ? link_to(image_for_app(app), app.remote_url, :target => '_blank') : image_for_app(app))) 
 ::Temple::Utils.escape_html((app.description.try(:html_safe) || t('no_description_supplied'))) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((link_to(t("install"), apps_engine.install_path(:id => app.identifier), :method => :post, :remote => true, :class => 'install-app-in-background btnn btn btn-info btn-sm '))) 
)) 
 ::Temple::Utils.escape_html((t('version'))) 
 ::Temple::Utils.escape_html((app.version)) 
 ::Temple::Utils.escape_html((link_to '', app.app_url, :target => '_blank', :class=>'glyphicon glyphicon-plus-sign')) 
 if app.forum_url.present?
 
 ::Temple::Utils.escape_html((link_to "#{t('discussion_forum_for')} #{app.name}", app.forum_url, :target => '_blank')) 
 end 
 unless app.live?
 
 ::Temple::Utils.escape_html((t('warning_this_application_is_in_testing'))) 
 end 
 ::Temple::Utils.escape_html((app.identifier)) 
 ::Temple::Utils.escape_html((app.name)) 
 ::Temple::Utils.escape_html((t('is_now_uninstalled'))) 
 end 
 ::Temple::Utils.escape_html((_slim_controls1)) 
)) 
 else
 
 ::Temple::Utils.escape_html((t('there_are_no_applications_available'))) 
 ::Temple::Utils.escape_html((t('this_could_be_due_to_lack_of_network_connectivity'))) 
 end 

end

	end

	def installed
		set_title t('apps')
		@apps = App.latest_first
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ::Temple::Utils.escape_html((link_to 'Get apps', 'https://www.amahi.org/apps', :title => 'Amahi App Store', :target => '_blank', :id => 'btn-get-apps')) 
 ::Temple::Utils.escape_html((link_to 'Install here!', apps_engine.root_path, :title => 'Refresh', :id => 'btn-install-apps')) 
 if @apps.any?
 
 ::Temple::Utils.escape_html((t('application'))) 
 ::Temple::Utils.escape_html((t('description'))) 
 ::Temple::Utils.escape_html(( app = app_installed

_slim_controls1 = content_tag 'div', :class => 'app', :id => "app_whole_#{app.identifier}", :data => { :progress_path => apps_engine.uninstall_progress_path(app.identifier) } do

 
 ::Temple::Utils.escape_html((app.identifier)) 
 ::Temple::Utils.escape_html((link_to name_with_warning(app), '#')) 
 ::Temple::Utils.escape_html((app.identifier)) 
 ::Temple::Utils.escape_html((short_desc(app))) 
 ::Temple::Utils.escape_html((app.identifier)) 
 ::Temple::Utils.escape_html((display_style)) 
 ::Temple::Utils.escape_html((app.name)) 
 ::Temple::Utils.escape_html((t('installed_paren'))) 
 ::Temple::Utils.escape_html((app.webapp ? link_to(image_for_app(app), app.remote_url, :target => '_blank') : image_for_app(app))) 
 ::Temple::Utils.escape_html((app.description.try(:html_safe) || t('no_description_supplied'))) 
 ::Temple::Utils.escape_html(( if app.initial_user and ! app.initial_user.blank?
 
 ::Temple::Utils.escape_html((t('initial_user_info'))) 
 ::Temple::Utils.escape_html((theme_image_tag('more.png', :title => t('more')))) 
 ::Temple::Utils.escape_html((t('initial_user'))) 
 ::Temple::Utils.escape_html((app.initial_user || "(blank)")) 
 ::Temple::Utils.escape_html((t('initial_password'))) 
 ::Temple::Utils.escape_html((app.initial_password || "(blank)")) 
 end; if app.special_instructions and ! app.special_instructions.blank?
 
 ::Temple::Utils.escape_html((t('special_instructions'))) 
 ::Temple::Utils.escape_html((app.special_instructions.html_safe)) 
 end; if app.webapp
 
 ::Temple::Utils.escape_html((link_to(app.full_url, app.full_url, :target => '_blank'))) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((simple_remote_checkbox :id => "in_dashboard_#{app.id}",
:css_class => 'in_dashboard_checkbox',
:url => apps_engine.toggle_in_dashboard_path(:id => app.identifier),
:label => "&nbsp; List in dashboard &nbsp;",
:checked => app.show_in_dashboard)) 
)) 
 end; if app.plugin
 
 ::Temple::Utils.escape_html((link_to(app.plugin.name, app.plugin.path, :target => '_blank'))) 
 ::Temple::Utils.escape_html((spinner)) 
 end; if app.theme
 
 ::Temple::Utils.escape_html((link_to(t('manage_themes'), settings_engine.themes_path,:class=>"btn btn-info btn-sm"))) 
 end 
 unless app.has_dependents?
 
 ::Temple::Utils.escape_html((link_to("#{t('uninstall')} &raquo;".html_safe, apps_engine.uninstall_path(:id => app.identifier), :method => :post, :remote => true, :class => 'uninstall-app-in-background btn btn-primary btn-sm'))) 
 end 
 unless app.installed
 
 ::Temple::Utils.escape_html((t('warning'))) 
 ::Temple::Utils.escape_html((t('this_application_install_ended_with_an_error_please_uninstall_status_is'))) 
 ::Temple::Utils.escape_html((app.install_status)) 
 ::Temple::Utils.escape_html((app.install_message)) 
 end 
)) 
 ::Temple::Utils.escape_html((t('version'))) 
 ::Temple::Utils.escape_html((app.version)) 
 ::Temple::Utils.escape_html((link_to '', app.app_url, :target => '_blank', :class=>'glyphicon glyphicon-plus')) 
 if app.forum_url.present?
 
 ::Temple::Utils.escape_html((link_to "#{t('discussion_forum_for')} #{app.name}", app.forum_url, :target => '_blank')) 
 end 
 unless app.live?
 
 ::Temple::Utils.escape_html((t('warning_this_application_is_in_testing'))) 
 end 
 ::Temple::Utils.escape_html((app.identifier)) 
 ::Temple::Utils.escape_html((app.name)) 
 ::Temple::Utils.escape_html((t('is_now_installed'))) 
 end 
 ::Temple::Utils.escape_html((_slim_controls1)) 
)) 
 else
 
 ::Temple::Utils.escape_html((t('there_are_no_applications_installed'))) 
 ::Temple::Utils.escape_html((link_to(t('try_installing_some_apps'), apps_engine.root_path))) 
 end 

end

	end

	def install
		identifier = params[:id]
		@app = App.where(:identifier=>identifier).first
		App.install identifier unless @app
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
json.identifier  params[:id]
json.content  @app ? t('this_application_is_installed_already_please_refresh') : "<span class='install_progress'>#{t('preparing_to_install')}</span>".html_safe
end

	end

	def install_progress
		identifier = params[:id]
		@app = App.where(:identifier=>identifier).first

		if @app
			@app.reload
			@progress = @app.install_status
			@message = @app.install_message
		else
			@progress = App.installation_status identifier
			@message = App.installation_message @progress
		end
		# we may send HTML if there app is installed or it errored out
		before_filter_hook if @progress >= 100
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
json.identifier params[:id]
json.content @message

if @progress == 100
	self.formats = [:html]
	json.app_content render(:partial => 'apps/app_installed', :object => @app)
elsif @progress > 100
	self.formats = [:html]
	json.app_content render(:partial => 'apps/app_failed', :object => @app)
end

end

	end

	def uninstall
		identifier = params[:id]
		@app = App.where(:identifier=>identifier).first
		@app.uninstall if @app
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
json.identifier  params[:id]
json.content  @app ? "<span class='uninstall_progress'>#{t('preparing_to_uninstall')}</span>".html_safe : t('this_application_is_not_installed_please_refresh')


end

	end

	def uninstall_progress
		identifier = params[:id]
		@app = App.where(:identifier=>identifier).first
		if @app
			@app.reload
			@progress = @app.install_status
			@message = @app.uninstall_message
		else
			@message = t('application_uninstalled')
			@progress = 0
		end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
json.identifier  params[:id]
json.content @message
json.uninstalled true if @progress == 0
end

	end


	def toggle_in_dashboard
		identifier = params[:id]
		app = App.where(:identifier=>identifier).first
		if app.installed
			app.show_in_dashboard = ! app.show_in_dashboard
			app.save
			@saved = true
		end
		render :json => { :status => @saved ? :ok : :not_acceptable }
	end

end
