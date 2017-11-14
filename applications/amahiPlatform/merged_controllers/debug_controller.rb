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

class DebugController < ApplicationController

	before_filter :admin_required
	layout 'debug'

	def index
		@page_title = t('debug')
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
 ::Temple::Utils.escape_html((t 'debug')) 
 _temple_html_attributeremover1 = (::Temple::Utils.escape_html((request.fullpath == '/tab/debug' ? 'active' : ''))).to_s 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 ::Temple::Utils.escape_html((link_to "App Logs", '/tab/debug')) 
 _temple_html_attributeremover2 = (::Temple::Utils.escape_html((request.fullpath == '/tab/debug/logs' ? 'active' : ''))).to_s 
 if !_temple_html_attributeremover2.empty? 
 _temple_html_attributeremover2 
 end 
 ::Temple::Utils.escape_html((link_to "Logs", '/tab/debug/logs')) 
 _temple_html_attributeremover3 = (::Temple::Utils.escape_html((request.fullpath == '/tab/debug/system' ? 'active' : ''))).to_s 
 if !_temple_html_attributeremover3.empty? 
 _temple_html_attributeremover3 
 end 
 ::Temple::Utils.escape_html((link_to "System Info", '/tab/debug/system')) 
  ::Temple::Utils.escape_html((button_tag 'Submit for Debug', :type => 'button', :class => 'open-area btn btn-create', :id => "debug-button",  :data => { :related => "#debug-submit-form" })) 
 ::Temple::Utils.escape_html(( message_string = "\n\nExplain the sequence of events leading to the error\nin as much detail as you can.\n\nThe more *concrete detail* you can add,\nthe higher chances we fix the problem quickly!"

_slim_controls1 = form_for :debug, :remote => true, :html => {\
:class => 'debug-form form-horizontal',\
:id => 'submit-debug-form'\
} do |f|
 
 ::Temple::Utils.escape_html((f.text_field :subject, :size => 32, :maxlength => 40, :placeholder => "Describe what failed here ...",:class=> "form-control debug-form")) 
 ::Temple::Utils.escape_html((text_area_tag :comments, '', :rows => 10, :cols => 80, :placeholder => message_string, :class=> "form-control debug-form")) 
 ::Temple::Utils.escape_html((spinner)) 
 ::Temple::Utils.escape_html((button_tag 'Submit', :type => 'submit', :id => 'debug_button', :class => 'btnn btn-submit btn-info btn-sm debug-form', :data=>{:confirm=>"Machine logs will be submitted to Amahi for debug.\nThis will help improve Amahi!\nWould you like to submit?"})) 
 ::Temple::Utils.escape_html((link_to t('cancel'), '#', :class => 'btn  btn-primary left-margin-10 btn-sm close-area cancel-link debug-form', :data => {:related=> '#debug-button'}, :onclick=>"$('#debug-submit-form').hide('slow');")) 
 end 
 ::Temple::Utils.escape_html((_slim_controls1)) 
)) 
 ::Temple::Utils.escape_html((SystemUtils.run "tail -100 #{Rails.root}/log/production.log")) 
 
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

	def logs
		@page_title = t('debug')
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
 ::Temple::Utils.escape_html((t 'debug')) 
 _temple_html_attributeremover1 = (::Temple::Utils.escape_html((request.fullpath == '/tab/debug' ? 'active' : ''))).to_s 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 ::Temple::Utils.escape_html((link_to "App Logs", '/tab/debug')) 
 _temple_html_attributeremover2 = (::Temple::Utils.escape_html((request.fullpath == '/tab/debug/logs' ? 'active' : ''))).to_s 
 if !_temple_html_attributeremover2.empty? 
 _temple_html_attributeremover2 
 end 
 ::Temple::Utils.escape_html((link_to "Logs", '/tab/debug/logs')) 
 _temple_html_attributeremover3 = (::Temple::Utils.escape_html((request.fullpath == '/tab/debug/system' ? 'active' : ''))).to_s 
 if !_temple_html_attributeremover3.empty? 
 _temple_html_attributeremover3 
 end 
 ::Temple::Utils.escape_html((link_to "System Info", '/tab/debug/system')) 
  ::Temple::Utils.escape_html((SystemUtils.run "grep -v \"hda dhcpd:\" #{Platform.file_name(:syslog)} | tail -100 | tac")) 
 
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

	def system
		@page_title = t('debug')
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
 ::Temple::Utils.escape_html((t 'debug')) 
 _temple_html_attributeremover1 = (::Temple::Utils.escape_html((request.fullpath == '/tab/debug' ? 'active' : ''))).to_s 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 ::Temple::Utils.escape_html((link_to "App Logs", '/tab/debug')) 
 _temple_html_attributeremover2 = (::Temple::Utils.escape_html((request.fullpath == '/tab/debug/logs' ? 'active' : ''))).to_s 
 if !_temple_html_attributeremover2.empty? 
 _temple_html_attributeremover2 
 end 
 ::Temple::Utils.escape_html((link_to "Logs", '/tab/debug/logs')) 
 _temple_html_attributeremover3 = (::Temple::Utils.escape_html((request.fullpath == '/tab/debug/system' ? 'active' : ''))).to_s 
 if !_temple_html_attributeremover3.empty? 
 _temple_html_attributeremover3 
 end 
 ::Temple::Utils.escape_html((link_to "System Info", '/tab/debug/system')) 
  ::Temple::Utils.escape_html((SystemUtils.uptime)) 
 ::Temple::Utils.escape_html((SystemUtils.run 'cat /proc/cpuinfo')) 
 ::Temple::Utils.escape_html((SystemUtils.run 'cat /proc/meminfo')) 
 
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


	def submit
		AmahiApi.api_key = Setting.get "api-key"
		report = SystemUtils.run 'tail -200 /var/hda/platform/html/log/production.log'
		er = AmahiApi::ErrorReport.new(:report => report, :comments => params[:comments], :subject => params[:subject])
	    begin
	      if er.save
	      	render :json =>{:status=>'ok'}
	      else
	      	render :json =>{:status=>'failed',:errors=> er.errors}
	      end
	    rescue
	      	render :json =>{:status=>'failed',:errors=> er.errors}
	    end
    end


end
