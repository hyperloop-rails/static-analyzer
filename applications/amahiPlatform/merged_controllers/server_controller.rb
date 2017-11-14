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

class ServerController < ApplicationController

	before_filter :admin_required

	def start
		id = params[:id]	
		server = Server.find id
		server.do_start
		sleep 1
		ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ::Temple::Utils.escape_html((@locale_direction)) 
 ::Temple::Utils.escape_html((I18n.locale)) 
 ::Temple::Utils.escape_html((I18n.locale)) 
 ::Temple::Utils.escape_html((full_page_title)) 
 ::Temple::Utils.escape_html((stylesheet_link_tag 'application')) 
 if theme.name != "default" and theme.disable_inheritance == false
 
 ::Temple::Utils.escape_html((stylesheet_link_tag(theme_stylesheet_path('style', theme.default)))) 
 ::Temple::Utils.escape_html((stylesheet_link_tag(theme_stylesheet_path('rtl', theme.default)) if rtl?)) 
 end 
 ::Temple::Utils.escape_html((theme_stylesheet_link_tag 'style')) 
 ::Temple::Utils.escape_html((theme_stylesheet_link_tag('rtl') if rtl?)) 
 amahi_plugins.each do |p|
 
 ::Temple::Utils.escape_html((stylesheet_link_tag p[:class].underscore)) 
 end 
 ::Temple::Utils.escape_html((javascript_include_tag 'http://html5shim.googlecode.com/svn/trunk/html5.js')) 
 ::Temple::Utils.escape_html((javascript_tag { ::Temple::Utils.escape_html((theme_image_path('ok.png').html_safe)) 
 ::Temple::Utils.escape_html((theme_image_path('warning.png').html_safe)) 
})) 
 ::Temple::Utils.escape_html((javascript_include_tag 'application')) 
 amahi_plugins.each do |p|
 
 ::Temple::Utils.escape_html((javascript_include_tag p[:class].underscore)) 
 end 
 ::Temple::Utils.escape_html((javascript_tag {'$.fx.off = true;' if Rails.env.test?})) 
 for header in theme.headers do
 
 ::Temple::Utils.escape_html((header =~ /\.js$/ ? javascript_include_tag(header) : header)) 
 end 
 ::Temple::Utils.escape_html((csrf_meta_tags)) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((link_to t('amahi'), root_url)) 
 ::Temple::Utils.escape_html((link_to t('home'), root_path)) 
 ::Temple::Utils.escape_html(( _slim_controls1 = form_tag search_path(action: 'hda'), method: 'get', id: 'searchform' do
 
 ::Temple::Utils.escape_html((text_field_tag 'query', @query, :maxlength => 45, :size => 20, :class => "ip-input", :id => 'searchinput')) 
 ::Temple::Utils.escape_html((submit_tag 'HDA', :class => 'searchbutton', :name => "button" , :id => 'hdasearchbutton')) 
 ::Temple::Utils.escape_html((submit_tag t('web'), :class => 'searchbutton', :name => "button" , :id => 'websearchbutton')) 
 end 
 ::Temple::Utils.escape_html((_slim_controls1)) 
)) 
 _slim_codeattributes1 = root_path; if _slim_codeattributes1; if _slim_codeattributes1 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes1)) 
 end; end 
 ::Temple::Utils.escape_html((t('home'))) 
 if current_user_is_admin?
 
 _slim_codeattributes2 = users_engine.root_path; if _slim_codeattributes2; if _slim_codeattributes2 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes2)) 
 end; end 
 ::Temple::Utils.escape_html((t('setup'))) 
 ::Temple::Utils.escape_html((t('help'))) 
 _slim_codeattributes3 = apps_engine.root_path; if _slim_codeattributes3; if _slim_codeattributes3 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes3)) 
 end; end 
 ::Temple::Utils.escape_html((t('apps'))) 
 else
 
 ::Temple::Utils.escape_html((t('help'))) 
 end 
 ::Temple::Utils.escape_html((page_title)) 
)) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((page_title)) 
)) 
 ::Temple::Utils.escape_html(( flash.each do |name, msg|
 
 ::Temple::Utils.escape_html((name)) 
 ::Temple::Utils.escape_html((msg)) 
 end 
)) 
 unless @no_tabs
 
 ::Temple::Utils.escape_html(( _temple_html_attributeremover1 = ''; _temple_html_attributemerger1 = []; _temple_html_attributemerger1[0] = "preftab"; _temple_html_attributemerger1[1] = ''; _slim_codeattributes1 = nav_class(@tabs); if Array === _slim_codeattributes1; _slim_codeattributes1 = _slim_codeattributes1.flatten; _slim_codeattributes1.map!(&:to_s); _slim_codeattributes1.reject!(&:empty?); _temple_html_attributemerger1[1] << ((::Temple::Utils.escape_html((_slim_codeattributes1.join(" ")))).to_s); else; _temple_html_attributemerger1[1] << ((::Temple::Utils.escape_html((_slim_codeattributes1))).to_s); end; _temple_html_attributemerger1[1]; _temple_html_attributeremover1 << ((_temple_html_attributemerger1.reject(&:empty?).join(" ")).to_s); _temple_html_attributeremover1 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 @tabs.each do |tab|
 
 _temple_html_attributeremover2 = ''; _slim_codeattributes2 = tab_class(tab); if Array === _slim_codeattributes2; _slim_codeattributes2 = _slim_codeattributes2.flatten; _slim_codeattributes2.map!(&:to_s); _slim_codeattributes2.reject!(&:empty?); _temple_html_attributeremover2 << ((::Temple::Utils.escape_html((_slim_codeattributes2.join(" ")))).to_s); else; _temple_html_attributeremover2 << ((::Temple::Utils.escape_html((_slim_codeattributes2))).to_s); end; _temple_html_attributeremover2 
 if !_temple_html_attributeremover2.empty? 
 _temple_html_attributeremover2 
 end 
 _slim_codeattributes3 = tab.url; if _slim_codeattributes3; if _slim_codeattributes3 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes3)) 
 end; end 
 ::Temple::Utils.escape_html((t tab.label)) 
 ::Temple::Utils.escape_html((tab.label.downcase)) 
 if @advanced
tab.advanced_subtabs.each do |subtab|
 
 _temple_html_attributeremover3 = ''; _slim_codeattributes4 = subtab_class(subtab.id,tab.id); if Array === _slim_codeattributes4; _slim_codeattributes4 = _slim_codeattributes4.flatten; _slim_codeattributes4.map!(&:to_s); _slim_codeattributes4.reject!(&:empty?); _temple_html_attributeremover3 << ((::Temple::Utils.escape_html((_slim_codeattributes4.join(" ")))).to_s); else; _temple_html_attributeremover3 << ((::Temple::Utils.escape_html((_slim_codeattributes4))).to_s); end; _temple_html_attributeremover3 
 if !_temple_html_attributeremover3.empty? 
 _temple_html_attributeremover3 
 end 
 ::Temple::Utils.escape_html((link_to t(subtab.label), subtab.url)) 
 end; else
tab.basic_subtabs.each do |subtab|
 
 _temple_html_attributeremover4 = ''; _slim_codeattributes5 = subtab_class(subtab.id,tab.id); if Array === _slim_codeattributes5; _slim_codeattributes5 = _slim_codeattributes5.flatten; _slim_codeattributes5.map!(&:to_s); _slim_codeattributes5.reject!(&:empty?); _temple_html_attributeremover4 << ((::Temple::Utils.escape_html((_slim_codeattributes5.join(" ")))).to_s); else; _temple_html_attributeremover4 << ((::Temple::Utils.escape_html((_slim_codeattributes5))).to_s); end; _temple_html_attributeremover4 
 if !_temple_html_attributeremover4.empty? 
 _temple_html_attributeremover4 
 end 
 ::Temple::Utils.escape_html((link_to t(subtab.label), subtab.url)) 
 end; end 
 end 
)) 
 	uid = server.id.to_s
	is_running = ! pids.empty?
	running = server_status('running')
	stopped = server_status('stopped')
	status_msg = is_running ? running : stopped
	processes = pids.empty? ? '-' : pids.join(', ')
	start_icon = theme_image_tag("server/start")
	stop_icon = theme_image_tag("server/stop")
	restart_icon = theme_image_tag("server/restart")
	refresh_icon = theme_image_tag("server/refresh")
	spin_show = spinner_show uid
	spin_hide = spinner_hide uid

 server.comment 
t 'status' 
 status_msg 
 spinner uid 
 javascript_tag do 
 render :update do |page| page["server_status_#{uid}"].replace_html status_msg end 
 end 
t 'control' 
 link_to_remote(refresh_icon,
					:update => "server_info_#{uid}",
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'refresh', :id => uid }) 
t 'refresh_status' 
 if is_running 
 link_to_remote(stop_icon,
					:update => "server_info_#{uid}",
					:confirm => [t('are_you_sure_you_want_to_stop_the_server', :name => server.comment), "",
							server.monitored ? t('the_watchdog_is_running_and_will_restart_it_in_a_few_seconds') : t('this_will_stop_the_server_permanently', :name => server.comment)
							].join("\n"),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'stop', :id => uid }) 
t 'stop_it' 
 server.monitored ? t('it_will_be_restarted_by_the_watchdog') : t('permanently') 
 link_to_remote(restart_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_restart_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'restart', :id => uid }) 
 t 'restart' 
 else 
 link_to_remote(start_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_start_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'start', :id => uid }) 
 end 
 checkbox_to_remote server.monitored,
					:url => { :controller => 'server', :action => 'toggle_monitored', :id => uid },
					:confirm => server.monitored ? t('the_watchdog_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" 
t 'watchdog' 
 server.comment 
 server.monitored ? t('is_being_monitored_24x7') : t('is_not_being_monitored_24x7') 
 checkbox_to_remote (server.monitored or server.start_at_boot), {
					:url => { :controller => 'server', :action => 'toggle_start_at_boot', :id => uid },
					:confirm => server.start_at_boot ? t('the_boot_option_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" },
					:disabled => server.monitored 
t 'start_at_boot_time' 
 server.comment 
 server.start_at_boot ? t('will_start_at_boot_time') : t('will_not_start_at_boot_time') 
 
 else
 
 	uid = server.id.to_s
	is_running = ! pids.empty?
	running = server_status('running')
	stopped = server_status('stopped')
	status_msg = is_running ? running : stopped
	processes = pids.empty? ? '-' : pids.join(', ')
	start_icon = theme_image_tag("server/start")
	stop_icon = theme_image_tag("server/stop")
	restart_icon = theme_image_tag("server/restart")
	refresh_icon = theme_image_tag("server/refresh")
	spin_show = spinner_show uid
	spin_hide = spinner_hide uid

 server.comment 
t 'status' 
 status_msg 
 spinner uid 
 javascript_tag do 
 render :update do |page| page["server_status_#{uid}"].replace_html status_msg end 
 end 
t 'control' 
 link_to_remote(refresh_icon,
					:update => "server_info_#{uid}",
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'refresh', :id => uid }) 
t 'refresh_status' 
 if is_running 
 link_to_remote(stop_icon,
					:update => "server_info_#{uid}",
					:confirm => [t('are_you_sure_you_want_to_stop_the_server', :name => server.comment), "",
							server.monitored ? t('the_watchdog_is_running_and_will_restart_it_in_a_few_seconds') : t('this_will_stop_the_server_permanently', :name => server.comment)
							].join("\n"),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'stop', :id => uid }) 
t 'stop_it' 
 server.monitored ? t('it_will_be_restarted_by_the_watchdog') : t('permanently') 
 link_to_remote(restart_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_restart_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'restart', :id => uid }) 
 t 'restart' 
 else 
 link_to_remote(start_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_start_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'start', :id => uid }) 
 end 
 checkbox_to_remote server.monitored,
					:url => { :controller => 'server', :action => 'toggle_monitored', :id => uid },
					:confirm => server.monitored ? t('the_watchdog_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" 
t 'watchdog' 
 server.comment 
 server.monitored ? t('is_being_monitored_24x7') : t('is_not_being_monitored_24x7') 
 checkbox_to_remote (server.monitored or server.start_at_boot), {
					:url => { :controller => 'server', :action => 'toggle_start_at_boot', :id => uid },
					:confirm => server.start_at_boot ? t('the_boot_option_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" },
					:disabled => server.monitored 
t 'start_at_boot_time' 
 server.comment 
 server.start_at_boot ? t('will_start_at_boot_time') : t('will_not_start_at_boot_time') 
 
 end 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((Date.today.year)) 
 ::Temple::Utils.escape_html((link_to "Amahi", "http://www.amahi.org", :target => "_blank")) 
 ::Temple::Utils.escape_html((link_to t('your_control_panel'), 'https://www.amahi.org/user', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('feedback'),'https://www.amahi.org/feedback', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('wiki'), 'https://wiki.amahi.org/', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('tracker'), 'https://bugs.amahi.org', :target=>'_blank')) 
 if theme.author
 
 ::Temple::Utils.escape_html((t('theme_by'))) 
 ::Temple::Utils.escape_html((theme.author_url ? link_to(theme.author, theme.author_url) : "#{theme.author} ")) 
 ::Temple::Utils.escape_html((link_to t('live_help'), 'http://talk.amahi.org', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('forums'), 'https://forums.amahi.org', :target=>'_blank')) 
 end; if current_user
 
 ::Temple::Utils.escape_html((link_to (t('logout') + " " + current_user.login), logout_path)) 
 else
 
 ::Temple::Utils.escape_html((link_to t('log_in'), login_path)) 
 end 
)) 
 ::Temple::Utils.escape_html((yield :js_templates)) 

end

	end

	def restart
		id = params[:id]	
		server = Server.find id
		server.do_restart
		sleep 1
		ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ::Temple::Utils.escape_html((@locale_direction)) 
 ::Temple::Utils.escape_html((I18n.locale)) 
 ::Temple::Utils.escape_html((I18n.locale)) 
 ::Temple::Utils.escape_html((full_page_title)) 
 ::Temple::Utils.escape_html((stylesheet_link_tag 'application')) 
 if theme.name != "default" and theme.disable_inheritance == false
 
 ::Temple::Utils.escape_html((stylesheet_link_tag(theme_stylesheet_path('style', theme.default)))) 
 ::Temple::Utils.escape_html((stylesheet_link_tag(theme_stylesheet_path('rtl', theme.default)) if rtl?)) 
 end 
 ::Temple::Utils.escape_html((theme_stylesheet_link_tag 'style')) 
 ::Temple::Utils.escape_html((theme_stylesheet_link_tag('rtl') if rtl?)) 
 amahi_plugins.each do |p|
 
 ::Temple::Utils.escape_html((stylesheet_link_tag p[:class].underscore)) 
 end 
 ::Temple::Utils.escape_html((javascript_include_tag 'http://html5shim.googlecode.com/svn/trunk/html5.js')) 
 ::Temple::Utils.escape_html((javascript_tag { ::Temple::Utils.escape_html((theme_image_path('ok.png').html_safe)) 
 ::Temple::Utils.escape_html((theme_image_path('warning.png').html_safe)) 
})) 
 ::Temple::Utils.escape_html((javascript_include_tag 'application')) 
 amahi_plugins.each do |p|
 
 ::Temple::Utils.escape_html((javascript_include_tag p[:class].underscore)) 
 end 
 ::Temple::Utils.escape_html((javascript_tag {'$.fx.off = true;' if Rails.env.test?})) 
 for header in theme.headers do
 
 ::Temple::Utils.escape_html((header =~ /\.js$/ ? javascript_include_tag(header) : header)) 
 end 
 ::Temple::Utils.escape_html((csrf_meta_tags)) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((link_to t('amahi'), root_url)) 
 ::Temple::Utils.escape_html((link_to t('home'), root_path)) 
 ::Temple::Utils.escape_html(( _slim_controls1 = form_tag search_path(action: 'hda'), method: 'get', id: 'searchform' do
 
 ::Temple::Utils.escape_html((text_field_tag 'query', @query, :maxlength => 45, :size => 20, :class => "ip-input", :id => 'searchinput')) 
 ::Temple::Utils.escape_html((submit_tag 'HDA', :class => 'searchbutton', :name => "button" , :id => 'hdasearchbutton')) 
 ::Temple::Utils.escape_html((submit_tag t('web'), :class => 'searchbutton', :name => "button" , :id => 'websearchbutton')) 
 end 
 ::Temple::Utils.escape_html((_slim_controls1)) 
)) 
 _slim_codeattributes1 = root_path; if _slim_codeattributes1; if _slim_codeattributes1 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes1)) 
 end; end 
 ::Temple::Utils.escape_html((t('home'))) 
 if current_user_is_admin?
 
 _slim_codeattributes2 = users_engine.root_path; if _slim_codeattributes2; if _slim_codeattributes2 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes2)) 
 end; end 
 ::Temple::Utils.escape_html((t('setup'))) 
 ::Temple::Utils.escape_html((t('help'))) 
 _slim_codeattributes3 = apps_engine.root_path; if _slim_codeattributes3; if _slim_codeattributes3 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes3)) 
 end; end 
 ::Temple::Utils.escape_html((t('apps'))) 
 else
 
 ::Temple::Utils.escape_html((t('help'))) 
 end 
 ::Temple::Utils.escape_html((page_title)) 
)) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((page_title)) 
)) 
 ::Temple::Utils.escape_html(( flash.each do |name, msg|
 
 ::Temple::Utils.escape_html((name)) 
 ::Temple::Utils.escape_html((msg)) 
 end 
)) 
 unless @no_tabs
 
 ::Temple::Utils.escape_html(( _temple_html_attributeremover1 = ''; _temple_html_attributemerger1 = []; _temple_html_attributemerger1[0] = "preftab"; _temple_html_attributemerger1[1] = ''; _slim_codeattributes1 = nav_class(@tabs); if Array === _slim_codeattributes1; _slim_codeattributes1 = _slim_codeattributes1.flatten; _slim_codeattributes1.map!(&:to_s); _slim_codeattributes1.reject!(&:empty?); _temple_html_attributemerger1[1] << ((::Temple::Utils.escape_html((_slim_codeattributes1.join(" ")))).to_s); else; _temple_html_attributemerger1[1] << ((::Temple::Utils.escape_html((_slim_codeattributes1))).to_s); end; _temple_html_attributemerger1[1]; _temple_html_attributeremover1 << ((_temple_html_attributemerger1.reject(&:empty?).join(" ")).to_s); _temple_html_attributeremover1 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 @tabs.each do |tab|
 
 _temple_html_attributeremover2 = ''; _slim_codeattributes2 = tab_class(tab); if Array === _slim_codeattributes2; _slim_codeattributes2 = _slim_codeattributes2.flatten; _slim_codeattributes2.map!(&:to_s); _slim_codeattributes2.reject!(&:empty?); _temple_html_attributeremover2 << ((::Temple::Utils.escape_html((_slim_codeattributes2.join(" ")))).to_s); else; _temple_html_attributeremover2 << ((::Temple::Utils.escape_html((_slim_codeattributes2))).to_s); end; _temple_html_attributeremover2 
 if !_temple_html_attributeremover2.empty? 
 _temple_html_attributeremover2 
 end 
 _slim_codeattributes3 = tab.url; if _slim_codeattributes3; if _slim_codeattributes3 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes3)) 
 end; end 
 ::Temple::Utils.escape_html((t tab.label)) 
 ::Temple::Utils.escape_html((tab.label.downcase)) 
 if @advanced
tab.advanced_subtabs.each do |subtab|
 
 _temple_html_attributeremover3 = ''; _slim_codeattributes4 = subtab_class(subtab.id,tab.id); if Array === _slim_codeattributes4; _slim_codeattributes4 = _slim_codeattributes4.flatten; _slim_codeattributes4.map!(&:to_s); _slim_codeattributes4.reject!(&:empty?); _temple_html_attributeremover3 << ((::Temple::Utils.escape_html((_slim_codeattributes4.join(" ")))).to_s); else; _temple_html_attributeremover3 << ((::Temple::Utils.escape_html((_slim_codeattributes4))).to_s); end; _temple_html_attributeremover3 
 if !_temple_html_attributeremover3.empty? 
 _temple_html_attributeremover3 
 end 
 ::Temple::Utils.escape_html((link_to t(subtab.label), subtab.url)) 
 end; else
tab.basic_subtabs.each do |subtab|
 
 _temple_html_attributeremover4 = ''; _slim_codeattributes5 = subtab_class(subtab.id,tab.id); if Array === _slim_codeattributes5; _slim_codeattributes5 = _slim_codeattributes5.flatten; _slim_codeattributes5.map!(&:to_s); _slim_codeattributes5.reject!(&:empty?); _temple_html_attributeremover4 << ((::Temple::Utils.escape_html((_slim_codeattributes5.join(" ")))).to_s); else; _temple_html_attributeremover4 << ((::Temple::Utils.escape_html((_slim_codeattributes5))).to_s); end; _temple_html_attributeremover4 
 if !_temple_html_attributeremover4.empty? 
 _temple_html_attributeremover4 
 end 
 ::Temple::Utils.escape_html((link_to t(subtab.label), subtab.url)) 
 end; end 
 end 
)) 
 	uid = server.id.to_s
	is_running = ! pids.empty?
	running = server_status('running')
	stopped = server_status('stopped')
	status_msg = is_running ? running : stopped
	processes = pids.empty? ? '-' : pids.join(', ')
	start_icon = theme_image_tag("server/start")
	stop_icon = theme_image_tag("server/stop")
	restart_icon = theme_image_tag("server/restart")
	refresh_icon = theme_image_tag("server/refresh")
	spin_show = spinner_show uid
	spin_hide = spinner_hide uid

 server.comment 
t 'status' 
 status_msg 
 spinner uid 
 javascript_tag do 
 render :update do |page| page["server_status_#{uid}"].replace_html status_msg end 
 end 
t 'control' 
 link_to_remote(refresh_icon,
					:update => "server_info_#{uid}",
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'refresh', :id => uid }) 
t 'refresh_status' 
 if is_running 
 link_to_remote(stop_icon,
					:update => "server_info_#{uid}",
					:confirm => [t('are_you_sure_you_want_to_stop_the_server', :name => server.comment), "",
							server.monitored ? t('the_watchdog_is_running_and_will_restart_it_in_a_few_seconds') : t('this_will_stop_the_server_permanently', :name => server.comment)
							].join("\n"),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'stop', :id => uid }) 
t 'stop_it' 
 server.monitored ? t('it_will_be_restarted_by_the_watchdog') : t('permanently') 
 link_to_remote(restart_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_restart_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'restart', :id => uid }) 
 t 'restart' 
 else 
 link_to_remote(start_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_start_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'start', :id => uid }) 
 end 
 checkbox_to_remote server.monitored,
					:url => { :controller => 'server', :action => 'toggle_monitored', :id => uid },
					:confirm => server.monitored ? t('the_watchdog_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" 
t 'watchdog' 
 server.comment 
 server.monitored ? t('is_being_monitored_24x7') : t('is_not_being_monitored_24x7') 
 checkbox_to_remote (server.monitored or server.start_at_boot), {
					:url => { :controller => 'server', :action => 'toggle_start_at_boot', :id => uid },
					:confirm => server.start_at_boot ? t('the_boot_option_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" },
					:disabled => server.monitored 
t 'start_at_boot_time' 
 server.comment 
 server.start_at_boot ? t('will_start_at_boot_time') : t('will_not_start_at_boot_time') 
 
 else
 
 	uid = server.id.to_s
	is_running = ! pids.empty?
	running = server_status('running')
	stopped = server_status('stopped')
	status_msg = is_running ? running : stopped
	processes = pids.empty? ? '-' : pids.join(', ')
	start_icon = theme_image_tag("server/start")
	stop_icon = theme_image_tag("server/stop")
	restart_icon = theme_image_tag("server/restart")
	refresh_icon = theme_image_tag("server/refresh")
	spin_show = spinner_show uid
	spin_hide = spinner_hide uid

 server.comment 
t 'status' 
 status_msg 
 spinner uid 
 javascript_tag do 
 render :update do |page| page["server_status_#{uid}"].replace_html status_msg end 
 end 
t 'control' 
 link_to_remote(refresh_icon,
					:update => "server_info_#{uid}",
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'refresh', :id => uid }) 
t 'refresh_status' 
 if is_running 
 link_to_remote(stop_icon,
					:update => "server_info_#{uid}",
					:confirm => [t('are_you_sure_you_want_to_stop_the_server', :name => server.comment), "",
							server.monitored ? t('the_watchdog_is_running_and_will_restart_it_in_a_few_seconds') : t('this_will_stop_the_server_permanently', :name => server.comment)
							].join("\n"),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'stop', :id => uid }) 
t 'stop_it' 
 server.monitored ? t('it_will_be_restarted_by_the_watchdog') : t('permanently') 
 link_to_remote(restart_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_restart_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'restart', :id => uid }) 
 t 'restart' 
 else 
 link_to_remote(start_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_start_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'start', :id => uid }) 
 end 
 checkbox_to_remote server.monitored,
					:url => { :controller => 'server', :action => 'toggle_monitored', :id => uid },
					:confirm => server.monitored ? t('the_watchdog_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" 
t 'watchdog' 
 server.comment 
 server.monitored ? t('is_being_monitored_24x7') : t('is_not_being_monitored_24x7') 
 checkbox_to_remote (server.monitored or server.start_at_boot), {
					:url => { :controller => 'server', :action => 'toggle_start_at_boot', :id => uid },
					:confirm => server.start_at_boot ? t('the_boot_option_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" },
					:disabled => server.monitored 
t 'start_at_boot_time' 
 server.comment 
 server.start_at_boot ? t('will_start_at_boot_time') : t('will_not_start_at_boot_time') 
 
 end 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((Date.today.year)) 
 ::Temple::Utils.escape_html((link_to "Amahi", "http://www.amahi.org", :target => "_blank")) 
 ::Temple::Utils.escape_html((link_to t('your_control_panel'), 'https://www.amahi.org/user', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('feedback'),'https://www.amahi.org/feedback', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('wiki'), 'https://wiki.amahi.org/', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('tracker'), 'https://bugs.amahi.org', :target=>'_blank')) 
 if theme.author
 
 ::Temple::Utils.escape_html((t('theme_by'))) 
 ::Temple::Utils.escape_html((theme.author_url ? link_to(theme.author, theme.author_url) : "#{theme.author} ")) 
 ::Temple::Utils.escape_html((link_to t('live_help'), 'http://talk.amahi.org', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('forums'), 'https://forums.amahi.org', :target=>'_blank')) 
 end; if current_user
 
 ::Temple::Utils.escape_html((link_to (t('logout') + " " + current_user.login), logout_path)) 
 else
 
 ::Temple::Utils.escape_html((link_to t('log_in'), login_path)) 
 end 
)) 
 ::Temple::Utils.escape_html((yield :js_templates)) 

end

	end

	def stop
		id = params[:id]	
		server = Server.find id
		server.do_stop
		sleep 1
		ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ::Temple::Utils.escape_html((@locale_direction)) 
 ::Temple::Utils.escape_html((I18n.locale)) 
 ::Temple::Utils.escape_html((I18n.locale)) 
 ::Temple::Utils.escape_html((full_page_title)) 
 ::Temple::Utils.escape_html((stylesheet_link_tag 'application')) 
 if theme.name != "default" and theme.disable_inheritance == false
 
 ::Temple::Utils.escape_html((stylesheet_link_tag(theme_stylesheet_path('style', theme.default)))) 
 ::Temple::Utils.escape_html((stylesheet_link_tag(theme_stylesheet_path('rtl', theme.default)) if rtl?)) 
 end 
 ::Temple::Utils.escape_html((theme_stylesheet_link_tag 'style')) 
 ::Temple::Utils.escape_html((theme_stylesheet_link_tag('rtl') if rtl?)) 
 amahi_plugins.each do |p|
 
 ::Temple::Utils.escape_html((stylesheet_link_tag p[:class].underscore)) 
 end 
 ::Temple::Utils.escape_html((javascript_include_tag 'http://html5shim.googlecode.com/svn/trunk/html5.js')) 
 ::Temple::Utils.escape_html((javascript_tag { ::Temple::Utils.escape_html((theme_image_path('ok.png').html_safe)) 
 ::Temple::Utils.escape_html((theme_image_path('warning.png').html_safe)) 
})) 
 ::Temple::Utils.escape_html((javascript_include_tag 'application')) 
 amahi_plugins.each do |p|
 
 ::Temple::Utils.escape_html((javascript_include_tag p[:class].underscore)) 
 end 
 ::Temple::Utils.escape_html((javascript_tag {'$.fx.off = true;' if Rails.env.test?})) 
 for header in theme.headers do
 
 ::Temple::Utils.escape_html((header =~ /\.js$/ ? javascript_include_tag(header) : header)) 
 end 
 ::Temple::Utils.escape_html((csrf_meta_tags)) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((link_to t('amahi'), root_url)) 
 ::Temple::Utils.escape_html((link_to t('home'), root_path)) 
 ::Temple::Utils.escape_html(( _slim_controls1 = form_tag search_path(action: 'hda'), method: 'get', id: 'searchform' do
 
 ::Temple::Utils.escape_html((text_field_tag 'query', @query, :maxlength => 45, :size => 20, :class => "ip-input", :id => 'searchinput')) 
 ::Temple::Utils.escape_html((submit_tag 'HDA', :class => 'searchbutton', :name => "button" , :id => 'hdasearchbutton')) 
 ::Temple::Utils.escape_html((submit_tag t('web'), :class => 'searchbutton', :name => "button" , :id => 'websearchbutton')) 
 end 
 ::Temple::Utils.escape_html((_slim_controls1)) 
)) 
 _slim_codeattributes1 = root_path; if _slim_codeattributes1; if _slim_codeattributes1 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes1)) 
 end; end 
 ::Temple::Utils.escape_html((t('home'))) 
 if current_user_is_admin?
 
 _slim_codeattributes2 = users_engine.root_path; if _slim_codeattributes2; if _slim_codeattributes2 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes2)) 
 end; end 
 ::Temple::Utils.escape_html((t('setup'))) 
 ::Temple::Utils.escape_html((t('help'))) 
 _slim_codeattributes3 = apps_engine.root_path; if _slim_codeattributes3; if _slim_codeattributes3 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes3)) 
 end; end 
 ::Temple::Utils.escape_html((t('apps'))) 
 else
 
 ::Temple::Utils.escape_html((t('help'))) 
 end 
 ::Temple::Utils.escape_html((page_title)) 
)) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((page_title)) 
)) 
 ::Temple::Utils.escape_html(( flash.each do |name, msg|
 
 ::Temple::Utils.escape_html((name)) 
 ::Temple::Utils.escape_html((msg)) 
 end 
)) 
 unless @no_tabs
 
 ::Temple::Utils.escape_html(( _temple_html_attributeremover1 = ''; _temple_html_attributemerger1 = []; _temple_html_attributemerger1[0] = "preftab"; _temple_html_attributemerger1[1] = ''; _slim_codeattributes1 = nav_class(@tabs); if Array === _slim_codeattributes1; _slim_codeattributes1 = _slim_codeattributes1.flatten; _slim_codeattributes1.map!(&:to_s); _slim_codeattributes1.reject!(&:empty?); _temple_html_attributemerger1[1] << ((::Temple::Utils.escape_html((_slim_codeattributes1.join(" ")))).to_s); else; _temple_html_attributemerger1[1] << ((::Temple::Utils.escape_html((_slim_codeattributes1))).to_s); end; _temple_html_attributemerger1[1]; _temple_html_attributeremover1 << ((_temple_html_attributemerger1.reject(&:empty?).join(" ")).to_s); _temple_html_attributeremover1 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 @tabs.each do |tab|
 
 _temple_html_attributeremover2 = ''; _slim_codeattributes2 = tab_class(tab); if Array === _slim_codeattributes2; _slim_codeattributes2 = _slim_codeattributes2.flatten; _slim_codeattributes2.map!(&:to_s); _slim_codeattributes2.reject!(&:empty?); _temple_html_attributeremover2 << ((::Temple::Utils.escape_html((_slim_codeattributes2.join(" ")))).to_s); else; _temple_html_attributeremover2 << ((::Temple::Utils.escape_html((_slim_codeattributes2))).to_s); end; _temple_html_attributeremover2 
 if !_temple_html_attributeremover2.empty? 
 _temple_html_attributeremover2 
 end 
 _slim_codeattributes3 = tab.url; if _slim_codeattributes3; if _slim_codeattributes3 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes3)) 
 end; end 
 ::Temple::Utils.escape_html((t tab.label)) 
 ::Temple::Utils.escape_html((tab.label.downcase)) 
 if @advanced
tab.advanced_subtabs.each do |subtab|
 
 _temple_html_attributeremover3 = ''; _slim_codeattributes4 = subtab_class(subtab.id,tab.id); if Array === _slim_codeattributes4; _slim_codeattributes4 = _slim_codeattributes4.flatten; _slim_codeattributes4.map!(&:to_s); _slim_codeattributes4.reject!(&:empty?); _temple_html_attributeremover3 << ((::Temple::Utils.escape_html((_slim_codeattributes4.join(" ")))).to_s); else; _temple_html_attributeremover3 << ((::Temple::Utils.escape_html((_slim_codeattributes4))).to_s); end; _temple_html_attributeremover3 
 if !_temple_html_attributeremover3.empty? 
 _temple_html_attributeremover3 
 end 
 ::Temple::Utils.escape_html((link_to t(subtab.label), subtab.url)) 
 end; else
tab.basic_subtabs.each do |subtab|
 
 _temple_html_attributeremover4 = ''; _slim_codeattributes5 = subtab_class(subtab.id,tab.id); if Array === _slim_codeattributes5; _slim_codeattributes5 = _slim_codeattributes5.flatten; _slim_codeattributes5.map!(&:to_s); _slim_codeattributes5.reject!(&:empty?); _temple_html_attributeremover4 << ((::Temple::Utils.escape_html((_slim_codeattributes5.join(" ")))).to_s); else; _temple_html_attributeremover4 << ((::Temple::Utils.escape_html((_slim_codeattributes5))).to_s); end; _temple_html_attributeremover4 
 if !_temple_html_attributeremover4.empty? 
 _temple_html_attributeremover4 
 end 
 ::Temple::Utils.escape_html((link_to t(subtab.label), subtab.url)) 
 end; end 
 end 
)) 
 	uid = server.id.to_s
	is_running = ! pids.empty?
	running = server_status('running')
	stopped = server_status('stopped')
	status_msg = is_running ? running : stopped
	processes = pids.empty? ? '-' : pids.join(', ')
	start_icon = theme_image_tag("server/start")
	stop_icon = theme_image_tag("server/stop")
	restart_icon = theme_image_tag("server/restart")
	refresh_icon = theme_image_tag("server/refresh")
	spin_show = spinner_show uid
	spin_hide = spinner_hide uid

 server.comment 
t 'status' 
 status_msg 
 spinner uid 
 javascript_tag do 
 render :update do |page| page["server_status_#{uid}"].replace_html status_msg end 
 end 
t 'control' 
 link_to_remote(refresh_icon,
					:update => "server_info_#{uid}",
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'refresh', :id => uid }) 
t 'refresh_status' 
 if is_running 
 link_to_remote(stop_icon,
					:update => "server_info_#{uid}",
					:confirm => [t('are_you_sure_you_want_to_stop_the_server', :name => server.comment), "",
							server.monitored ? t('the_watchdog_is_running_and_will_restart_it_in_a_few_seconds') : t('this_will_stop_the_server_permanently', :name => server.comment)
							].join("\n"),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'stop', :id => uid }) 
t 'stop_it' 
 server.monitored ? t('it_will_be_restarted_by_the_watchdog') : t('permanently') 
 link_to_remote(restart_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_restart_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'restart', :id => uid }) 
 t 'restart' 
 else 
 link_to_remote(start_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_start_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'start', :id => uid }) 
 end 
 checkbox_to_remote server.monitored,
					:url => { :controller => 'server', :action => 'toggle_monitored', :id => uid },
					:confirm => server.monitored ? t('the_watchdog_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" 
t 'watchdog' 
 server.comment 
 server.monitored ? t('is_being_monitored_24x7') : t('is_not_being_monitored_24x7') 
 checkbox_to_remote (server.monitored or server.start_at_boot), {
					:url => { :controller => 'server', :action => 'toggle_start_at_boot', :id => uid },
					:confirm => server.start_at_boot ? t('the_boot_option_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" },
					:disabled => server.monitored 
t 'start_at_boot_time' 
 server.comment 
 server.start_at_boot ? t('will_start_at_boot_time') : t('will_not_start_at_boot_time') 
 
 else
 
 	uid = server.id.to_s
	is_running = ! pids.empty?
	running = server_status('running')
	stopped = server_status('stopped')
	status_msg = is_running ? running : stopped
	processes = pids.empty? ? '-' : pids.join(', ')
	start_icon = theme_image_tag("server/start")
	stop_icon = theme_image_tag("server/stop")
	restart_icon = theme_image_tag("server/restart")
	refresh_icon = theme_image_tag("server/refresh")
	spin_show = spinner_show uid
	spin_hide = spinner_hide uid

 server.comment 
t 'status' 
 status_msg 
 spinner uid 
 javascript_tag do 
 render :update do |page| page["server_status_#{uid}"].replace_html status_msg end 
 end 
t 'control' 
 link_to_remote(refresh_icon,
					:update => "server_info_#{uid}",
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'refresh', :id => uid }) 
t 'refresh_status' 
 if is_running 
 link_to_remote(stop_icon,
					:update => "server_info_#{uid}",
					:confirm => [t('are_you_sure_you_want_to_stop_the_server', :name => server.comment), "",
							server.monitored ? t('the_watchdog_is_running_and_will_restart_it_in_a_few_seconds') : t('this_will_stop_the_server_permanently', :name => server.comment)
							].join("\n"),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'stop', :id => uid }) 
t 'stop_it' 
 server.monitored ? t('it_will_be_restarted_by_the_watchdog') : t('permanently') 
 link_to_remote(restart_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_restart_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'restart', :id => uid }) 
 t 'restart' 
 else 
 link_to_remote(start_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_start_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'start', :id => uid }) 
 end 
 checkbox_to_remote server.monitored,
					:url => { :controller => 'server', :action => 'toggle_monitored', :id => uid },
					:confirm => server.monitored ? t('the_watchdog_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" 
t 'watchdog' 
 server.comment 
 server.monitored ? t('is_being_monitored_24x7') : t('is_not_being_monitored_24x7') 
 checkbox_to_remote (server.monitored or server.start_at_boot), {
					:url => { :controller => 'server', :action => 'toggle_start_at_boot', :id => uid },
					:confirm => server.start_at_boot ? t('the_boot_option_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" },
					:disabled => server.monitored 
t 'start_at_boot_time' 
 server.comment 
 server.start_at_boot ? t('will_start_at_boot_time') : t('will_not_start_at_boot_time') 
 
 end 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((Date.today.year)) 
 ::Temple::Utils.escape_html((link_to "Amahi", "http://www.amahi.org", :target => "_blank")) 
 ::Temple::Utils.escape_html((link_to t('your_control_panel'), 'https://www.amahi.org/user', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('feedback'),'https://www.amahi.org/feedback', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('wiki'), 'https://wiki.amahi.org/', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('tracker'), 'https://bugs.amahi.org', :target=>'_blank')) 
 if theme.author
 
 ::Temple::Utils.escape_html((t('theme_by'))) 
 ::Temple::Utils.escape_html((theme.author_url ? link_to(theme.author, theme.author_url) : "#{theme.author} ")) 
 ::Temple::Utils.escape_html((link_to t('live_help'), 'http://talk.amahi.org', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('forums'), 'https://forums.amahi.org', :target=>'_blank')) 
 end; if current_user
 
 ::Temple::Utils.escape_html((link_to (t('logout') + " " + current_user.login), logout_path)) 
 else
 
 ::Temple::Utils.escape_html((link_to t('log_in'), login_path)) 
 end 
)) 
 ::Temple::Utils.escape_html((yield :js_templates)) 

end

	end

	def refresh
		id = params[:id]	
		server = Server.find id
		sleep 1
		ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ::Temple::Utils.escape_html((@locale_direction)) 
 ::Temple::Utils.escape_html((I18n.locale)) 
 ::Temple::Utils.escape_html((I18n.locale)) 
 ::Temple::Utils.escape_html((full_page_title)) 
 ::Temple::Utils.escape_html((stylesheet_link_tag 'application')) 
 if theme.name != "default" and theme.disable_inheritance == false
 
 ::Temple::Utils.escape_html((stylesheet_link_tag(theme_stylesheet_path('style', theme.default)))) 
 ::Temple::Utils.escape_html((stylesheet_link_tag(theme_stylesheet_path('rtl', theme.default)) if rtl?)) 
 end 
 ::Temple::Utils.escape_html((theme_stylesheet_link_tag 'style')) 
 ::Temple::Utils.escape_html((theme_stylesheet_link_tag('rtl') if rtl?)) 
 amahi_plugins.each do |p|
 
 ::Temple::Utils.escape_html((stylesheet_link_tag p[:class].underscore)) 
 end 
 ::Temple::Utils.escape_html((javascript_include_tag 'http://html5shim.googlecode.com/svn/trunk/html5.js')) 
 ::Temple::Utils.escape_html((javascript_tag { ::Temple::Utils.escape_html((theme_image_path('ok.png').html_safe)) 
 ::Temple::Utils.escape_html((theme_image_path('warning.png').html_safe)) 
})) 
 ::Temple::Utils.escape_html((javascript_include_tag 'application')) 
 amahi_plugins.each do |p|
 
 ::Temple::Utils.escape_html((javascript_include_tag p[:class].underscore)) 
 end 
 ::Temple::Utils.escape_html((javascript_tag {'$.fx.off = true;' if Rails.env.test?})) 
 for header in theme.headers do
 
 ::Temple::Utils.escape_html((header =~ /\.js$/ ? javascript_include_tag(header) : header)) 
 end 
 ::Temple::Utils.escape_html((csrf_meta_tags)) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((link_to t('amahi'), root_url)) 
 ::Temple::Utils.escape_html((link_to t('home'), root_path)) 
 ::Temple::Utils.escape_html(( _slim_controls1 = form_tag search_path(action: 'hda'), method: 'get', id: 'searchform' do
 
 ::Temple::Utils.escape_html((text_field_tag 'query', @query, :maxlength => 45, :size => 20, :class => "ip-input", :id => 'searchinput')) 
 ::Temple::Utils.escape_html((submit_tag 'HDA', :class => 'searchbutton', :name => "button" , :id => 'hdasearchbutton')) 
 ::Temple::Utils.escape_html((submit_tag t('web'), :class => 'searchbutton', :name => "button" , :id => 'websearchbutton')) 
 end 
 ::Temple::Utils.escape_html((_slim_controls1)) 
)) 
 _slim_codeattributes1 = root_path; if _slim_codeattributes1; if _slim_codeattributes1 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes1)) 
 end; end 
 ::Temple::Utils.escape_html((t('home'))) 
 if current_user_is_admin?
 
 _slim_codeattributes2 = users_engine.root_path; if _slim_codeattributes2; if _slim_codeattributes2 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes2)) 
 end; end 
 ::Temple::Utils.escape_html((t('setup'))) 
 ::Temple::Utils.escape_html((t('help'))) 
 _slim_codeattributes3 = apps_engine.root_path; if _slim_codeattributes3; if _slim_codeattributes3 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes3)) 
 end; end 
 ::Temple::Utils.escape_html((t('apps'))) 
 else
 
 ::Temple::Utils.escape_html((t('help'))) 
 end 
 ::Temple::Utils.escape_html((page_title)) 
)) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((page_title)) 
)) 
 ::Temple::Utils.escape_html(( flash.each do |name, msg|
 
 ::Temple::Utils.escape_html((name)) 
 ::Temple::Utils.escape_html((msg)) 
 end 
)) 
 unless @no_tabs
 
 ::Temple::Utils.escape_html(( _temple_html_attributeremover1 = ''; _temple_html_attributemerger1 = []; _temple_html_attributemerger1[0] = "preftab"; _temple_html_attributemerger1[1] = ''; _slim_codeattributes1 = nav_class(@tabs); if Array === _slim_codeattributes1; _slim_codeattributes1 = _slim_codeattributes1.flatten; _slim_codeattributes1.map!(&:to_s); _slim_codeattributes1.reject!(&:empty?); _temple_html_attributemerger1[1] << ((::Temple::Utils.escape_html((_slim_codeattributes1.join(" ")))).to_s); else; _temple_html_attributemerger1[1] << ((::Temple::Utils.escape_html((_slim_codeattributes1))).to_s); end; _temple_html_attributemerger1[1]; _temple_html_attributeremover1 << ((_temple_html_attributemerger1.reject(&:empty?).join(" ")).to_s); _temple_html_attributeremover1 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 @tabs.each do |tab|
 
 _temple_html_attributeremover2 = ''; _slim_codeattributes2 = tab_class(tab); if Array === _slim_codeattributes2; _slim_codeattributes2 = _slim_codeattributes2.flatten; _slim_codeattributes2.map!(&:to_s); _slim_codeattributes2.reject!(&:empty?); _temple_html_attributeremover2 << ((::Temple::Utils.escape_html((_slim_codeattributes2.join(" ")))).to_s); else; _temple_html_attributeremover2 << ((::Temple::Utils.escape_html((_slim_codeattributes2))).to_s); end; _temple_html_attributeremover2 
 if !_temple_html_attributeremover2.empty? 
 _temple_html_attributeremover2 
 end 
 _slim_codeattributes3 = tab.url; if _slim_codeattributes3; if _slim_codeattributes3 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes3)) 
 end; end 
 ::Temple::Utils.escape_html((t tab.label)) 
 ::Temple::Utils.escape_html((tab.label.downcase)) 
 if @advanced
tab.advanced_subtabs.each do |subtab|
 
 _temple_html_attributeremover3 = ''; _slim_codeattributes4 = subtab_class(subtab.id,tab.id); if Array === _slim_codeattributes4; _slim_codeattributes4 = _slim_codeattributes4.flatten; _slim_codeattributes4.map!(&:to_s); _slim_codeattributes4.reject!(&:empty?); _temple_html_attributeremover3 << ((::Temple::Utils.escape_html((_slim_codeattributes4.join(" ")))).to_s); else; _temple_html_attributeremover3 << ((::Temple::Utils.escape_html((_slim_codeattributes4))).to_s); end; _temple_html_attributeremover3 
 if !_temple_html_attributeremover3.empty? 
 _temple_html_attributeremover3 
 end 
 ::Temple::Utils.escape_html((link_to t(subtab.label), subtab.url)) 
 end; else
tab.basic_subtabs.each do |subtab|
 
 _temple_html_attributeremover4 = ''; _slim_codeattributes5 = subtab_class(subtab.id,tab.id); if Array === _slim_codeattributes5; _slim_codeattributes5 = _slim_codeattributes5.flatten; _slim_codeattributes5.map!(&:to_s); _slim_codeattributes5.reject!(&:empty?); _temple_html_attributeremover4 << ((::Temple::Utils.escape_html((_slim_codeattributes5.join(" ")))).to_s); else; _temple_html_attributeremover4 << ((::Temple::Utils.escape_html((_slim_codeattributes5))).to_s); end; _temple_html_attributeremover4 
 if !_temple_html_attributeremover4.empty? 
 _temple_html_attributeremover4 
 end 
 ::Temple::Utils.escape_html((link_to t(subtab.label), subtab.url)) 
 end; end 
 end 
)) 
 	uid = server.id.to_s
	is_running = ! pids.empty?
	running = server_status('running')
	stopped = server_status('stopped')
	status_msg = is_running ? running : stopped
	processes = pids.empty? ? '-' : pids.join(', ')
	start_icon = theme_image_tag("server/start")
	stop_icon = theme_image_tag("server/stop")
	restart_icon = theme_image_tag("server/restart")
	refresh_icon = theme_image_tag("server/refresh")
	spin_show = spinner_show uid
	spin_hide = spinner_hide uid

 server.comment 
t 'status' 
 status_msg 
 spinner uid 
 javascript_tag do 
 render :update do |page| page["server_status_#{uid}"].replace_html status_msg end 
 end 
t 'control' 
 link_to_remote(refresh_icon,
					:update => "server_info_#{uid}",
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'refresh', :id => uid }) 
t 'refresh_status' 
 if is_running 
 link_to_remote(stop_icon,
					:update => "server_info_#{uid}",
					:confirm => [t('are_you_sure_you_want_to_stop_the_server', :name => server.comment), "",
							server.monitored ? t('the_watchdog_is_running_and_will_restart_it_in_a_few_seconds') : t('this_will_stop_the_server_permanently', :name => server.comment)
							].join("\n"),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'stop', :id => uid }) 
t 'stop_it' 
 server.monitored ? t('it_will_be_restarted_by_the_watchdog') : t('permanently') 
 link_to_remote(restart_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_restart_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'restart', :id => uid }) 
 t 'restart' 
 else 
 link_to_remote(start_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_start_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'start', :id => uid }) 
 end 
 checkbox_to_remote server.monitored,
					:url => { :controller => 'server', :action => 'toggle_monitored', :id => uid },
					:confirm => server.monitored ? t('the_watchdog_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" 
t 'watchdog' 
 server.comment 
 server.monitored ? t('is_being_monitored_24x7') : t('is_not_being_monitored_24x7') 
 checkbox_to_remote (server.monitored or server.start_at_boot), {
					:url => { :controller => 'server', :action => 'toggle_start_at_boot', :id => uid },
					:confirm => server.start_at_boot ? t('the_boot_option_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" },
					:disabled => server.monitored 
t 'start_at_boot_time' 
 server.comment 
 server.start_at_boot ? t('will_start_at_boot_time') : t('will_not_start_at_boot_time') 
 
 else
 
 	uid = server.id.to_s
	is_running = ! pids.empty?
	running = server_status('running')
	stopped = server_status('stopped')
	status_msg = is_running ? running : stopped
	processes = pids.empty? ? '-' : pids.join(', ')
	start_icon = theme_image_tag("server/start")
	stop_icon = theme_image_tag("server/stop")
	restart_icon = theme_image_tag("server/restart")
	refresh_icon = theme_image_tag("server/refresh")
	spin_show = spinner_show uid
	spin_hide = spinner_hide uid

 server.comment 
t 'status' 
 status_msg 
 spinner uid 
 javascript_tag do 
 render :update do |page| page["server_status_#{uid}"].replace_html status_msg end 
 end 
t 'control' 
 link_to_remote(refresh_icon,
					:update => "server_info_#{uid}",
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'refresh', :id => uid }) 
t 'refresh_status' 
 if is_running 
 link_to_remote(stop_icon,
					:update => "server_info_#{uid}",
					:confirm => [t('are_you_sure_you_want_to_stop_the_server', :name => server.comment), "",
							server.monitored ? t('the_watchdog_is_running_and_will_restart_it_in_a_few_seconds') : t('this_will_stop_the_server_permanently', :name => server.comment)
							].join("\n"),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'stop', :id => uid }) 
t 'stop_it' 
 server.monitored ? t('it_will_be_restarted_by_the_watchdog') : t('permanently') 
 link_to_remote(restart_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_restart_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'restart', :id => uid }) 
 t 'restart' 
 else 
 link_to_remote(start_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_start_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'start', :id => uid }) 
 end 
 checkbox_to_remote server.monitored,
					:url => { :controller => 'server', :action => 'toggle_monitored', :id => uid },
					:confirm => server.monitored ? t('the_watchdog_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" 
t 'watchdog' 
 server.comment 
 server.monitored ? t('is_being_monitored_24x7') : t('is_not_being_monitored_24x7') 
 checkbox_to_remote (server.monitored or server.start_at_boot), {
					:url => { :controller => 'server', :action => 'toggle_start_at_boot', :id => uid },
					:confirm => server.start_at_boot ? t('the_boot_option_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" },
					:disabled => server.monitored 
t 'start_at_boot_time' 
 server.comment 
 server.start_at_boot ? t('will_start_at_boot_time') : t('will_not_start_at_boot_time') 
 
 end 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((Date.today.year)) 
 ::Temple::Utils.escape_html((link_to "Amahi", "http://www.amahi.org", :target => "_blank")) 
 ::Temple::Utils.escape_html((link_to t('your_control_panel'), 'https://www.amahi.org/user', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('feedback'),'https://www.amahi.org/feedback', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('wiki'), 'https://wiki.amahi.org/', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('tracker'), 'https://bugs.amahi.org', :target=>'_blank')) 
 if theme.author
 
 ::Temple::Utils.escape_html((t('theme_by'))) 
 ::Temple::Utils.escape_html((theme.author_url ? link_to(theme.author, theme.author_url) : "#{theme.author} ")) 
 ::Temple::Utils.escape_html((link_to t('live_help'), 'http://talk.amahi.org', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('forums'), 'https://forums.amahi.org', :target=>'_blank')) 
 end; if current_user
 
 ::Temple::Utils.escape_html((link_to (t('logout') + " " + current_user.login), logout_path)) 
 else
 
 ::Temple::Utils.escape_html((link_to t('log_in'), login_path)) 
 end 
)) 
 ::Temple::Utils.escape_html((yield :js_templates)) 

end

	end

	def toggle_monitored
		id = params[:id]	
		server = Server.find id
		server.monitored = ! server.monitored
		server.save!
		ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ::Temple::Utils.escape_html((@locale_direction)) 
 ::Temple::Utils.escape_html((I18n.locale)) 
 ::Temple::Utils.escape_html((I18n.locale)) 
 ::Temple::Utils.escape_html((full_page_title)) 
 ::Temple::Utils.escape_html((stylesheet_link_tag 'application')) 
 if theme.name != "default" and theme.disable_inheritance == false
 
 ::Temple::Utils.escape_html((stylesheet_link_tag(theme_stylesheet_path('style', theme.default)))) 
 ::Temple::Utils.escape_html((stylesheet_link_tag(theme_stylesheet_path('rtl', theme.default)) if rtl?)) 
 end 
 ::Temple::Utils.escape_html((theme_stylesheet_link_tag 'style')) 
 ::Temple::Utils.escape_html((theme_stylesheet_link_tag('rtl') if rtl?)) 
 amahi_plugins.each do |p|
 
 ::Temple::Utils.escape_html((stylesheet_link_tag p[:class].underscore)) 
 end 
 ::Temple::Utils.escape_html((javascript_include_tag 'http://html5shim.googlecode.com/svn/trunk/html5.js')) 
 ::Temple::Utils.escape_html((javascript_tag { ::Temple::Utils.escape_html((theme_image_path('ok.png').html_safe)) 
 ::Temple::Utils.escape_html((theme_image_path('warning.png').html_safe)) 
})) 
 ::Temple::Utils.escape_html((javascript_include_tag 'application')) 
 amahi_plugins.each do |p|
 
 ::Temple::Utils.escape_html((javascript_include_tag p[:class].underscore)) 
 end 
 ::Temple::Utils.escape_html((javascript_tag {'$.fx.off = true;' if Rails.env.test?})) 
 for header in theme.headers do
 
 ::Temple::Utils.escape_html((header =~ /\.js$/ ? javascript_include_tag(header) : header)) 
 end 
 ::Temple::Utils.escape_html((csrf_meta_tags)) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((link_to t('amahi'), root_url)) 
 ::Temple::Utils.escape_html((link_to t('home'), root_path)) 
 ::Temple::Utils.escape_html(( _slim_controls1 = form_tag search_path(action: 'hda'), method: 'get', id: 'searchform' do
 
 ::Temple::Utils.escape_html((text_field_tag 'query', @query, :maxlength => 45, :size => 20, :class => "ip-input", :id => 'searchinput')) 
 ::Temple::Utils.escape_html((submit_tag 'HDA', :class => 'searchbutton', :name => "button" , :id => 'hdasearchbutton')) 
 ::Temple::Utils.escape_html((submit_tag t('web'), :class => 'searchbutton', :name => "button" , :id => 'websearchbutton')) 
 end 
 ::Temple::Utils.escape_html((_slim_controls1)) 
)) 
 _slim_codeattributes1 = root_path; if _slim_codeattributes1; if _slim_codeattributes1 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes1)) 
 end; end 
 ::Temple::Utils.escape_html((t('home'))) 
 if current_user_is_admin?
 
 _slim_codeattributes2 = users_engine.root_path; if _slim_codeattributes2; if _slim_codeattributes2 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes2)) 
 end; end 
 ::Temple::Utils.escape_html((t('setup'))) 
 ::Temple::Utils.escape_html((t('help'))) 
 _slim_codeattributes3 = apps_engine.root_path; if _slim_codeattributes3; if _slim_codeattributes3 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes3)) 
 end; end 
 ::Temple::Utils.escape_html((t('apps'))) 
 else
 
 ::Temple::Utils.escape_html((t('help'))) 
 end 
 ::Temple::Utils.escape_html((page_title)) 
)) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((page_title)) 
)) 
 ::Temple::Utils.escape_html(( flash.each do |name, msg|
 
 ::Temple::Utils.escape_html((name)) 
 ::Temple::Utils.escape_html((msg)) 
 end 
)) 
 unless @no_tabs
 
 ::Temple::Utils.escape_html(( _temple_html_attributeremover1 = ''; _temple_html_attributemerger1 = []; _temple_html_attributemerger1[0] = "preftab"; _temple_html_attributemerger1[1] = ''; _slim_codeattributes1 = nav_class(@tabs); if Array === _slim_codeattributes1; _slim_codeattributes1 = _slim_codeattributes1.flatten; _slim_codeattributes1.map!(&:to_s); _slim_codeattributes1.reject!(&:empty?); _temple_html_attributemerger1[1] << ((::Temple::Utils.escape_html((_slim_codeattributes1.join(" ")))).to_s); else; _temple_html_attributemerger1[1] << ((::Temple::Utils.escape_html((_slim_codeattributes1))).to_s); end; _temple_html_attributemerger1[1]; _temple_html_attributeremover1 << ((_temple_html_attributemerger1.reject(&:empty?).join(" ")).to_s); _temple_html_attributeremover1 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 @tabs.each do |tab|
 
 _temple_html_attributeremover2 = ''; _slim_codeattributes2 = tab_class(tab); if Array === _slim_codeattributes2; _slim_codeattributes2 = _slim_codeattributes2.flatten; _slim_codeattributes2.map!(&:to_s); _slim_codeattributes2.reject!(&:empty?); _temple_html_attributeremover2 << ((::Temple::Utils.escape_html((_slim_codeattributes2.join(" ")))).to_s); else; _temple_html_attributeremover2 << ((::Temple::Utils.escape_html((_slim_codeattributes2))).to_s); end; _temple_html_attributeremover2 
 if !_temple_html_attributeremover2.empty? 
 _temple_html_attributeremover2 
 end 
 _slim_codeattributes3 = tab.url; if _slim_codeattributes3; if _slim_codeattributes3 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes3)) 
 end; end 
 ::Temple::Utils.escape_html((t tab.label)) 
 ::Temple::Utils.escape_html((tab.label.downcase)) 
 if @advanced
tab.advanced_subtabs.each do |subtab|
 
 _temple_html_attributeremover3 = ''; _slim_codeattributes4 = subtab_class(subtab.id,tab.id); if Array === _slim_codeattributes4; _slim_codeattributes4 = _slim_codeattributes4.flatten; _slim_codeattributes4.map!(&:to_s); _slim_codeattributes4.reject!(&:empty?); _temple_html_attributeremover3 << ((::Temple::Utils.escape_html((_slim_codeattributes4.join(" ")))).to_s); else; _temple_html_attributeremover3 << ((::Temple::Utils.escape_html((_slim_codeattributes4))).to_s); end; _temple_html_attributeremover3 
 if !_temple_html_attributeremover3.empty? 
 _temple_html_attributeremover3 
 end 
 ::Temple::Utils.escape_html((link_to t(subtab.label), subtab.url)) 
 end; else
tab.basic_subtabs.each do |subtab|
 
 _temple_html_attributeremover4 = ''; _slim_codeattributes5 = subtab_class(subtab.id,tab.id); if Array === _slim_codeattributes5; _slim_codeattributes5 = _slim_codeattributes5.flatten; _slim_codeattributes5.map!(&:to_s); _slim_codeattributes5.reject!(&:empty?); _temple_html_attributeremover4 << ((::Temple::Utils.escape_html((_slim_codeattributes5.join(" ")))).to_s); else; _temple_html_attributeremover4 << ((::Temple::Utils.escape_html((_slim_codeattributes5))).to_s); end; _temple_html_attributeremover4 
 if !_temple_html_attributeremover4.empty? 
 _temple_html_attributeremover4 
 end 
 ::Temple::Utils.escape_html((link_to t(subtab.label), subtab.url)) 
 end; end 
 end 
)) 
 	uid = server.id.to_s
	is_running = ! pids.empty?
	running = server_status('running')
	stopped = server_status('stopped')
	status_msg = is_running ? running : stopped
	processes = pids.empty? ? '-' : pids.join(', ')
	start_icon = theme_image_tag("server/start")
	stop_icon = theme_image_tag("server/stop")
	restart_icon = theme_image_tag("server/restart")
	refresh_icon = theme_image_tag("server/refresh")
	spin_show = spinner_show uid
	spin_hide = spinner_hide uid

 server.comment 
t 'status' 
 status_msg 
 spinner uid 
 javascript_tag do 
 render :update do |page| page["server_status_#{uid}"].replace_html status_msg end 
 end 
t 'control' 
 link_to_remote(refresh_icon,
					:update => "server_info_#{uid}",
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'refresh', :id => uid }) 
t 'refresh_status' 
 if is_running 
 link_to_remote(stop_icon,
					:update => "server_info_#{uid}",
					:confirm => [t('are_you_sure_you_want_to_stop_the_server', :name => server.comment), "",
							server.monitored ? t('the_watchdog_is_running_and_will_restart_it_in_a_few_seconds') : t('this_will_stop_the_server_permanently', :name => server.comment)
							].join("\n"),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'stop', :id => uid }) 
t 'stop_it' 
 server.monitored ? t('it_will_be_restarted_by_the_watchdog') : t('permanently') 
 link_to_remote(restart_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_restart_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'restart', :id => uid }) 
 t 'restart' 
 else 
 link_to_remote(start_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_start_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'start', :id => uid }) 
 end 
 checkbox_to_remote server.monitored,
					:url => { :controller => 'server', :action => 'toggle_monitored', :id => uid },
					:confirm => server.monitored ? t('the_watchdog_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" 
t 'watchdog' 
 server.comment 
 server.monitored ? t('is_being_monitored_24x7') : t('is_not_being_monitored_24x7') 
 checkbox_to_remote (server.monitored or server.start_at_boot), {
					:url => { :controller => 'server', :action => 'toggle_start_at_boot', :id => uid },
					:confirm => server.start_at_boot ? t('the_boot_option_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" },
					:disabled => server.monitored 
t 'start_at_boot_time' 
 server.comment 
 server.start_at_boot ? t('will_start_at_boot_time') : t('will_not_start_at_boot_time') 
 
 else
 
 	uid = server.id.to_s
	is_running = ! pids.empty?
	running = server_status('running')
	stopped = server_status('stopped')
	status_msg = is_running ? running : stopped
	processes = pids.empty? ? '-' : pids.join(', ')
	start_icon = theme_image_tag("server/start")
	stop_icon = theme_image_tag("server/stop")
	restart_icon = theme_image_tag("server/restart")
	refresh_icon = theme_image_tag("server/refresh")
	spin_show = spinner_show uid
	spin_hide = spinner_hide uid

 server.comment 
t 'status' 
 status_msg 
 spinner uid 
 javascript_tag do 
 render :update do |page| page["server_status_#{uid}"].replace_html status_msg end 
 end 
t 'control' 
 link_to_remote(refresh_icon,
					:update => "server_info_#{uid}",
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'refresh', :id => uid }) 
t 'refresh_status' 
 if is_running 
 link_to_remote(stop_icon,
					:update => "server_info_#{uid}",
					:confirm => [t('are_you_sure_you_want_to_stop_the_server', :name => server.comment), "",
							server.monitored ? t('the_watchdog_is_running_and_will_restart_it_in_a_few_seconds') : t('this_will_stop_the_server_permanently', :name => server.comment)
							].join("\n"),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'stop', :id => uid }) 
t 'stop_it' 
 server.monitored ? t('it_will_be_restarted_by_the_watchdog') : t('permanently') 
 link_to_remote(restart_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_restart_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'restart', :id => uid }) 
 t 'restart' 
 else 
 link_to_remote(start_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_start_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'start', :id => uid }) 
 end 
 checkbox_to_remote server.monitored,
					:url => { :controller => 'server', :action => 'toggle_monitored', :id => uid },
					:confirm => server.monitored ? t('the_watchdog_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" 
t 'watchdog' 
 server.comment 
 server.monitored ? t('is_being_monitored_24x7') : t('is_not_being_monitored_24x7') 
 checkbox_to_remote (server.monitored or server.start_at_boot), {
					:url => { :controller => 'server', :action => 'toggle_start_at_boot', :id => uid },
					:confirm => server.start_at_boot ? t('the_boot_option_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" },
					:disabled => server.monitored 
t 'start_at_boot_time' 
 server.comment 
 server.start_at_boot ? t('will_start_at_boot_time') : t('will_not_start_at_boot_time') 
 
 end 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((Date.today.year)) 
 ::Temple::Utils.escape_html((link_to "Amahi", "http://www.amahi.org", :target => "_blank")) 
 ::Temple::Utils.escape_html((link_to t('your_control_panel'), 'https://www.amahi.org/user', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('feedback'),'https://www.amahi.org/feedback', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('wiki'), 'https://wiki.amahi.org/', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('tracker'), 'https://bugs.amahi.org', :target=>'_blank')) 
 if theme.author
 
 ::Temple::Utils.escape_html((t('theme_by'))) 
 ::Temple::Utils.escape_html((theme.author_url ? link_to(theme.author, theme.author_url) : "#{theme.author} ")) 
 ::Temple::Utils.escape_html((link_to t('live_help'), 'http://talk.amahi.org', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('forums'), 'https://forums.amahi.org', :target=>'_blank')) 
 end; if current_user
 
 ::Temple::Utils.escape_html((link_to (t('logout') + " " + current_user.login), logout_path)) 
 else
 
 ::Temple::Utils.escape_html((link_to t('log_in'), login_path)) 
 end 
)) 
 ::Temple::Utils.escape_html((yield :js_templates)) 

end

	end

	def toggle_start_at_boot
		id = params[:id]	
		server = Server.find id
		server.start_at_boot = ! server.start_at_boot
		server.save!
		ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 ::Temple::Utils.escape_html((@locale_direction)) 
 ::Temple::Utils.escape_html((I18n.locale)) 
 ::Temple::Utils.escape_html((I18n.locale)) 
 ::Temple::Utils.escape_html((full_page_title)) 
 ::Temple::Utils.escape_html((stylesheet_link_tag 'application')) 
 if theme.name != "default" and theme.disable_inheritance == false
 
 ::Temple::Utils.escape_html((stylesheet_link_tag(theme_stylesheet_path('style', theme.default)))) 
 ::Temple::Utils.escape_html((stylesheet_link_tag(theme_stylesheet_path('rtl', theme.default)) if rtl?)) 
 end 
 ::Temple::Utils.escape_html((theme_stylesheet_link_tag 'style')) 
 ::Temple::Utils.escape_html((theme_stylesheet_link_tag('rtl') if rtl?)) 
 amahi_plugins.each do |p|
 
 ::Temple::Utils.escape_html((stylesheet_link_tag p[:class].underscore)) 
 end 
 ::Temple::Utils.escape_html((javascript_include_tag 'http://html5shim.googlecode.com/svn/trunk/html5.js')) 
 ::Temple::Utils.escape_html((javascript_tag { ::Temple::Utils.escape_html((theme_image_path('ok.png').html_safe)) 
 ::Temple::Utils.escape_html((theme_image_path('warning.png').html_safe)) 
})) 
 ::Temple::Utils.escape_html((javascript_include_tag 'application')) 
 amahi_plugins.each do |p|
 
 ::Temple::Utils.escape_html((javascript_include_tag p[:class].underscore)) 
 end 
 ::Temple::Utils.escape_html((javascript_tag {'$.fx.off = true;' if Rails.env.test?})) 
 for header in theme.headers do
 
 ::Temple::Utils.escape_html((header =~ /\.js$/ ? javascript_include_tag(header) : header)) 
 end 
 ::Temple::Utils.escape_html((csrf_meta_tags)) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((link_to t('amahi'), root_url)) 
 ::Temple::Utils.escape_html((link_to t('home'), root_path)) 
 ::Temple::Utils.escape_html(( _slim_controls1 = form_tag search_path(action: 'hda'), method: 'get', id: 'searchform' do
 
 ::Temple::Utils.escape_html((text_field_tag 'query', @query, :maxlength => 45, :size => 20, :class => "ip-input", :id => 'searchinput')) 
 ::Temple::Utils.escape_html((submit_tag 'HDA', :class => 'searchbutton', :name => "button" , :id => 'hdasearchbutton')) 
 ::Temple::Utils.escape_html((submit_tag t('web'), :class => 'searchbutton', :name => "button" , :id => 'websearchbutton')) 
 end 
 ::Temple::Utils.escape_html((_slim_controls1)) 
)) 
 _slim_codeattributes1 = root_path; if _slim_codeattributes1; if _slim_codeattributes1 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes1)) 
 end; end 
 ::Temple::Utils.escape_html((t('home'))) 
 if current_user_is_admin?
 
 _slim_codeattributes2 = users_engine.root_path; if _slim_codeattributes2; if _slim_codeattributes2 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes2)) 
 end; end 
 ::Temple::Utils.escape_html((t('setup'))) 
 ::Temple::Utils.escape_html((t('help'))) 
 _slim_codeattributes3 = apps_engine.root_path; if _slim_codeattributes3; if _slim_codeattributes3 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes3)) 
 end; end 
 ::Temple::Utils.escape_html((t('apps'))) 
 else
 
 ::Temple::Utils.escape_html((t('help'))) 
 end 
 ::Temple::Utils.escape_html((page_title)) 
)) 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((page_title)) 
)) 
 ::Temple::Utils.escape_html(( flash.each do |name, msg|
 
 ::Temple::Utils.escape_html((name)) 
 ::Temple::Utils.escape_html((msg)) 
 end 
)) 
 unless @no_tabs
 
 ::Temple::Utils.escape_html(( _temple_html_attributeremover1 = ''; _temple_html_attributemerger1 = []; _temple_html_attributemerger1[0] = "preftab"; _temple_html_attributemerger1[1] = ''; _slim_codeattributes1 = nav_class(@tabs); if Array === _slim_codeattributes1; _slim_codeattributes1 = _slim_codeattributes1.flatten; _slim_codeattributes1.map!(&:to_s); _slim_codeattributes1.reject!(&:empty?); _temple_html_attributemerger1[1] << ((::Temple::Utils.escape_html((_slim_codeattributes1.join(" ")))).to_s); else; _temple_html_attributemerger1[1] << ((::Temple::Utils.escape_html((_slim_codeattributes1))).to_s); end; _temple_html_attributemerger1[1]; _temple_html_attributeremover1 << ((_temple_html_attributemerger1.reject(&:empty?).join(" ")).to_s); _temple_html_attributeremover1 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 @tabs.each do |tab|
 
 _temple_html_attributeremover2 = ''; _slim_codeattributes2 = tab_class(tab); if Array === _slim_codeattributes2; _slim_codeattributes2 = _slim_codeattributes2.flatten; _slim_codeattributes2.map!(&:to_s); _slim_codeattributes2.reject!(&:empty?); _temple_html_attributeremover2 << ((::Temple::Utils.escape_html((_slim_codeattributes2.join(" ")))).to_s); else; _temple_html_attributeremover2 << ((::Temple::Utils.escape_html((_slim_codeattributes2))).to_s); end; _temple_html_attributeremover2 
 if !_temple_html_attributeremover2.empty? 
 _temple_html_attributeremover2 
 end 
 _slim_codeattributes3 = tab.url; if _slim_codeattributes3; if _slim_codeattributes3 == true 
 else 
 ::Temple::Utils.escape_html((_slim_codeattributes3)) 
 end; end 
 ::Temple::Utils.escape_html((t tab.label)) 
 ::Temple::Utils.escape_html((tab.label.downcase)) 
 if @advanced
tab.advanced_subtabs.each do |subtab|
 
 _temple_html_attributeremover3 = ''; _slim_codeattributes4 = subtab_class(subtab.id,tab.id); if Array === _slim_codeattributes4; _slim_codeattributes4 = _slim_codeattributes4.flatten; _slim_codeattributes4.map!(&:to_s); _slim_codeattributes4.reject!(&:empty?); _temple_html_attributeremover3 << ((::Temple::Utils.escape_html((_slim_codeattributes4.join(" ")))).to_s); else; _temple_html_attributeremover3 << ((::Temple::Utils.escape_html((_slim_codeattributes4))).to_s); end; _temple_html_attributeremover3 
 if !_temple_html_attributeremover3.empty? 
 _temple_html_attributeremover3 
 end 
 ::Temple::Utils.escape_html((link_to t(subtab.label), subtab.url)) 
 end; else
tab.basic_subtabs.each do |subtab|
 
 _temple_html_attributeremover4 = ''; _slim_codeattributes5 = subtab_class(subtab.id,tab.id); if Array === _slim_codeattributes5; _slim_codeattributes5 = _slim_codeattributes5.flatten; _slim_codeattributes5.map!(&:to_s); _slim_codeattributes5.reject!(&:empty?); _temple_html_attributeremover4 << ((::Temple::Utils.escape_html((_slim_codeattributes5.join(" ")))).to_s); else; _temple_html_attributeremover4 << ((::Temple::Utils.escape_html((_slim_codeattributes5))).to_s); end; _temple_html_attributeremover4 
 if !_temple_html_attributeremover4.empty? 
 _temple_html_attributeremover4 
 end 
 ::Temple::Utils.escape_html((link_to t(subtab.label), subtab.url)) 
 end; end 
 end 
)) 
 	uid = server.id.to_s
	is_running = ! pids.empty?
	running = server_status('running')
	stopped = server_status('stopped')
	status_msg = is_running ? running : stopped
	processes = pids.empty? ? '-' : pids.join(', ')
	start_icon = theme_image_tag("server/start")
	stop_icon = theme_image_tag("server/stop")
	restart_icon = theme_image_tag("server/restart")
	refresh_icon = theme_image_tag("server/refresh")
	spin_show = spinner_show uid
	spin_hide = spinner_hide uid

 server.comment 
t 'status' 
 status_msg 
 spinner uid 
 javascript_tag do 
 render :update do |page| page["server_status_#{uid}"].replace_html status_msg end 
 end 
t 'control' 
 link_to_remote(refresh_icon,
					:update => "server_info_#{uid}",
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'refresh', :id => uid }) 
t 'refresh_status' 
 if is_running 
 link_to_remote(stop_icon,
					:update => "server_info_#{uid}",
					:confirm => [t('are_you_sure_you_want_to_stop_the_server', :name => server.comment), "",
							server.monitored ? t('the_watchdog_is_running_and_will_restart_it_in_a_few_seconds') : t('this_will_stop_the_server_permanently', :name => server.comment)
							].join("\n"),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'stop', :id => uid }) 
t 'stop_it' 
 server.monitored ? t('it_will_be_restarted_by_the_watchdog') : t('permanently') 
 link_to_remote(restart_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_restart_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'restart', :id => uid }) 
 t 'restart' 
 else 
 link_to_remote(start_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_start_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'start', :id => uid }) 
 end 
 checkbox_to_remote server.monitored,
					:url => { :controller => 'server', :action => 'toggle_monitored', :id => uid },
					:confirm => server.monitored ? t('the_watchdog_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" 
t 'watchdog' 
 server.comment 
 server.monitored ? t('is_being_monitored_24x7') : t('is_not_being_monitored_24x7') 
 checkbox_to_remote (server.monitored or server.start_at_boot), {
					:url => { :controller => 'server', :action => 'toggle_start_at_boot', :id => uid },
					:confirm => server.start_at_boot ? t('the_boot_option_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" },
					:disabled => server.monitored 
t 'start_at_boot_time' 
 server.comment 
 server.start_at_boot ? t('will_start_at_boot_time') : t('will_not_start_at_boot_time') 
 
 else
 
 	uid = server.id.to_s
	is_running = ! pids.empty?
	running = server_status('running')
	stopped = server_status('stopped')
	status_msg = is_running ? running : stopped
	processes = pids.empty? ? '-' : pids.join(', ')
	start_icon = theme_image_tag("server/start")
	stop_icon = theme_image_tag("server/stop")
	restart_icon = theme_image_tag("server/restart")
	refresh_icon = theme_image_tag("server/refresh")
	spin_show = spinner_show uid
	spin_hide = spinner_hide uid

 server.comment 
t 'status' 
 status_msg 
 spinner uid 
 javascript_tag do 
 render :update do |page| page["server_status_#{uid}"].replace_html status_msg end 
 end 
t 'control' 
 link_to_remote(refresh_icon,
					:update => "server_info_#{uid}",
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'refresh', :id => uid }) 
t 'refresh_status' 
 if is_running 
 link_to_remote(stop_icon,
					:update => "server_info_#{uid}",
					:confirm => [t('are_you_sure_you_want_to_stop_the_server', :name => server.comment), "",
							server.monitored ? t('the_watchdog_is_running_and_will_restart_it_in_a_few_seconds') : t('this_will_stop_the_server_permanently', :name => server.comment)
							].join("\n"),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'stop', :id => uid }) 
t 'stop_it' 
 server.monitored ? t('it_will_be_restarted_by_the_watchdog') : t('permanently') 
 link_to_remote(restart_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_restart_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'restart', :id => uid }) 
 t 'restart' 
 else 
 link_to_remote(start_icon,
					:update => "server_info_#{uid}",
					:confirm => t('are_you_sure_you_want_to_start_the_server', :name => server.comment),
					:before => spin_show,
					:success => spin_hide,
					:url => { :controller => 'server', :action => 'start', :id => uid }) 
 end 
 checkbox_to_remote server.monitored,
					:url => { :controller => 'server', :action => 'toggle_monitored', :id => uid },
					:confirm => server.monitored ? t('the_watchdog_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" 
t 'watchdog' 
 server.comment 
 server.monitored ? t('is_being_monitored_24x7') : t('is_not_being_monitored_24x7') 
 checkbox_to_remote (server.monitored or server.start_at_boot), {
					:url => { :controller => 'server', :action => 'toggle_start_at_boot', :id => uid },
					:confirm => server.start_at_boot ? t('the_boot_option_is_a_critical_setting') : nil,
					:before => spin_show,
					:success => spin_hide,
					:update => "server_info_#{uid}" },
					:disabled => server.monitored 
t 'start_at_boot_time' 
 server.comment 
 server.start_at_boot ? t('will_start_at_boot_time') : t('will_not_start_at_boot_time') 
 
 end 
 ::Temple::Utils.escape_html(( ::Temple::Utils.escape_html((Date.today.year)) 
 ::Temple::Utils.escape_html((link_to "Amahi", "http://www.amahi.org", :target => "_blank")) 
 ::Temple::Utils.escape_html((link_to t('your_control_panel'), 'https://www.amahi.org/user', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('feedback'),'https://www.amahi.org/feedback', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('wiki'), 'https://wiki.amahi.org/', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('tracker'), 'https://bugs.amahi.org', :target=>'_blank')) 
 if theme.author
 
 ::Temple::Utils.escape_html((t('theme_by'))) 
 ::Temple::Utils.escape_html((theme.author_url ? link_to(theme.author, theme.author_url) : "#{theme.author} ")) 
 ::Temple::Utils.escape_html((link_to t('live_help'), 'http://talk.amahi.org', :target=>'_blank')) 
 ::Temple::Utils.escape_html((link_to t('forums'), 'https://forums.amahi.org', :target=>'_blank')) 
 end; if current_user
 
 ::Temple::Utils.escape_html((link_to (t('logout') + " " + current_user.login), logout_path)) 
 else
 
 ::Temple::Utils.escape_html((link_to t('log_in'), login_path)) 
 end 
)) 
 ::Temple::Utils.escape_html((yield :js_templates)) 

end

	end
end
