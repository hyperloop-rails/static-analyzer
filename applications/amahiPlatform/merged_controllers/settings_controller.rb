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

class SettingsController < ApplicationController

	before_filter :admin_required

	def index
		@page_title = t 'settings'
		@available_locales = locales_implemented
		@advanced_settings = Setting.where(:name=>'advanced').first
		@guest = Setting.where(:name=>"guest-dashboard").first
		@version = Platform.platform_versions
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ::Temple::Utils.escape_html((t 'global_settings')) 
 ::Temple::Utils.escape_html((t 'language')) 
 ::Temple::Utils.escape_html((select_tag 'locale', options_for_select(@available_locales, I18n.locale.to_s),
data: { remote: true, url: settings_engine.change_language_path, update: 'language' },
class: 'remote-select form-control')) 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((t 'advanced_settings')) 
 ::Temple::Utils.escape_html((tag "input", id: "advanced", class: "remote-check", type: "checkbox", checked: @advanced_settings.set?,
data: { remote: true, url: settings_engine.toggle_setting_path(id: @advanced_settings),
confirm: @advanced_settings.set? ? nil : [t('avanced_settings_is_for_developers'),
'', '', t('are_you_sure_advanced_features')].join("\n") })) 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((t 'guest_dashboard')) 
 ::Temple::Utils.escape_html((tag "input", id: "guest", class: "remote-check", type: "checkbox", checked: @guest.set?,
data: { remote: true, url: settings_engine.toggle_setting_path(id: @guest) })) 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((t 'system_info')) 
 ::Temple::Utils.escape_html((link_to '',
settings_engine.poweroff_path,
remote: true,
method: :post,
class: 'btn-system glyphicon glyphicon-off left-margin-40',
id: 'btn-poweroff',
data: {:confirm => t('this_will_power_off')})) 
 ::Temple::Utils.escape_html((link_to '',
settings_engine.reboot_path,
remote: true,
method: :post,
data: {:confirm => t('this_will_reboot')},
class: 'btn-system glyphicon glyphicon-repeat',
id: 'btn-reboot')) 
 ::Temple::Utils.escape_html((t 'system')) 
 ::Temple::Utils.escape_html((`uname -r`)) 
 ::Temple::Utils.escape_html((`uname -m`)) 
 ::Temple::Utils.escape_html((t 'platform')) 
 ::Temple::Utils.escape_html((@version[:platform])) 
 ::Temple::Utils.escape_html((t 'core')) 
 ::Temple::Utils.escape_html((@version[:core])) 
 ::Temple::Utils.escape_html((t 'uptime')) 
 ::Temple::Utils.escape_html((`uptime`)) 

end

	end

	def servers
		@page_title = t 'settings'
		unless @advanced
			redirect_to settings_engine_path
		else
			@message = nil
			unless use_sample_data?
				@servers = Server.all
			else
				@message = "NOTE: these servers are fake data! Interacting with them will not work."
				@servers = SampleData.load('servers')
			end
		end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @servers.length < 1
 
 ::Temple::Utils.escape_html((t 'there_are_no_servers_available')) 
 else
if @message
 
 ::Temple::Utils.escape_html((@message)) 
 end 
 ::Temple::Utils.escape_html((t 'servers')) 
 ::Temple::Utils.escape_html((t 'state')) 
 ::Temple::Utils.escape_html(( uid = server.id.to_s
 
 ::Temple::Utils.escape_html((uid)) 
 ::Temple::Utils.escape_html((uid)) 
 ::Temple::Utils.escape_html((server.comment)) 
 ::Temple::Utils.escape_html((server.stopped? ? server_status('stopped') : server_status('running'))) 
 ::Temple::Utils.escape_html((uid)) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((server.comment)) 
 ::Temple::Utils.escape_html((t 'status')) 
 ::Temple::Utils.escape_html((server.running? ? server_status('running') : server_status('stopped'))) 
 ::Temple::Utils.escape_html((t 'control')) 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((link_to t('refresh_status'),
settings_engine.refresh_path(server),
remote: true,
class: 'btn-refresh remote-btn btn btn-info btn-sm')) 
 ::Temple::Utils.escape_html((t 'refresh_status')) 
 if server.running?
 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((link_to t('stop_it'),
settings_engine.stop_path(server),
remote: true,
class: 'btn-stop remote-btn btn btn-success btn-sm',
confirm: [t('are_you_sure_you_want_to_stop_the_server', :name => server.comment), "",
server.monitored ? t('the_watchdog_is_running_and_will_restart_it_in_a_few_seconds') : t('this_will_stop_the_server_permanently', :name => server.comment)].join("\n"))) 
 ::Temple::Utils.escape_html((t 'stop_it')) 
 ::Temple::Utils.escape_html((server.monitored ? t('it_will_be_restarted_by_the_watchdog') : t('permanently'))) 
 else
 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((link_to t('start_server'),
settings_engine.start_path(server),
remote: true,
class: 'btn-start remote-btn btn btn-success btn-sm',
confirm: t('are_you_sure_you_want_to_start_the_server', name: server.comment))) 
 ::Temple::Utils.escape_html((t 'start_it')) 
 end 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((link_to t('restart_server'),
settings_engine.restart_path(server),
remote: true,
class: 'btn-restart remote-btn btn btn-primary btn-sm',
confirm: t('are_you_sure_you_want_to_restart_the_server', name: server.comment))) 
 ::Temple::Utils.escape_html((t 'restart')) 
 ::Temple::Utils.escape_html((t 'settings')) 
 ::Temple::Utils.escape_html((simple_remote_checkbox id: "server_monitored_#{server.id}",
css_class: 'server_monitored_checkbox',
url: settings_engine.toggle_monitored_path(server),
confirm: server.monitored ? t('the_watchdog_is_a_critical_setting') : nil,
label: "&nbsp; &mdash; &nbsp; #{t('watchdog')}. #{server.comment} #{server.monitored ? t('is_being_monitored_24x7') : t('is_not_being_monitored_24x7')}",
checked: server.monitored)) 
 ::Temple::Utils.escape_html((simple_remote_checkbox id: "server_start_at_boot_#{server.id}",
css_class: 'server_start_at_boot_checkbox',
url: settings_engine.toggle_start_at_boot_path(server),
confirm: server.start_at_boot ? t('the_boot_option_is_a_critical_setting') : nil,
label: "&nbsp; &mdash; &nbsp; #{t('start_at_boot_time')}. #{server.comment} #{server.start_at_boot ? t('will_start_at_boot_time') : t('will_not_start_at_boot_time')}",
checked: server.start_at_boot,
disabled: server.monitored)) 
)) 
)) 
 end 

end

	end

	def change_language
		sleep 2 if development?
		l = params[:locale]
		if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
			cookies['locale'] = { :value => params[:locale], :expires => 1.year.from_now }
		end
		render json: { status: 'ok' }
	end

	def toggle_setting
		sleep 2 if development?
		id = params[:id]
		s = Setting.find id
		s.value = (1 - s.value.to_i).to_s
		if s.save
			render json: { status: 'ok' }
		else
			render json: { status: 'error' }
		end
	end

	def reboot
		c = Command.new("reboot")
		c.execute
		render :text => t('rebooting')
	end

	def poweroff
		c = Command.new("poweroff")
		c.execute
		render :text => t('powering_off')
	end

  def refresh
    sleep 2 if Rails.env.development?
    @server = Server.find(params[:id])
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
self.formats = ['html']

json.status :ok
json.content render(partial: 'server', locals: {server: @server})

end

  end

  def start
    sleep 2 if Rails.env.development?
    @server = Server.find(params[:id])
    @server.do_start
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
self.formats = ['html']

json.status :ok
json.content render(partial: 'server', locals: {server: @server})

end

  end

  def stop
    sleep 2 if Rails.env.development?
    @server = Server.find(params[:id])
    @server.do_stop
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
self.formats = ['html']

json.status :ok
json.content render(partial: 'server', locals: {server: @server})

end

  end

  def restart
    sleep 2 if Rails.env.development?
    @server = Server.find(params[:id])
    @server.do_restart
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
self.formats = ['html']

json.status :ok
json.content render(partial: 'server', locals: {server: @server})

end

  end

  def toggle_monitored
    sleep 2 if Rails.env.development?
    @server = Server.find(params[:id])
    @server.toggle!(:monitored)
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
self.formats = ['html']

json.status :ok
json.content render(partial: 'server', locals: {server: @server})

end

  end

  def toggle_start_at_boot
    sleep 2 if Rails.env.development?
    @server = Server.find(params[:id])
    @server.toggle!(:start_at_boot)
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
self.formats = ['html']

json.status :ok
json.content render(partial: 'server', locals: {server: @server})

end

  end

	# index of all themes
	def themes
		@page_title = t 'settings'
		@themes = Theme.available
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @themes.each do |theme|
 
 ::Temple::Utils.escape_html((link_to image_tag(theme_image_path('theme-thumb.png', theme.css), :class => "theme-thumb thumbnail right-margin-10", title: theme.name),
settings_engine.activate_theme_path(id: theme.css),
{ onmouseover: "$('#theme-sshot').attr('src', '#{theme_image_path('theme-sshot.png', theme.css)}')" })) 
 end 
 ::Temple::Utils.escape_html((theme_image_tag('theme-sshot.png', id: "theme-sshot", alt: theme.name, title: theme.name))) 

end

	end

	def activate_theme
		s = Setting.where(:name=> "theme").first
		s.value = params[:id]
		s.save!
		# redirect rather than render, so that it re-displays with the new theme
		redirect_to settings_engine.themes_path
	end

end
