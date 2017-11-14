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

class CalendarController < ApplicationController
	before_filter :admin_required

	def initialize
		@page_title = t('calendars')
	end

	def index
		Dir.chdir("/var/hda/calendar/html")
		@calendars = Dir["*.ics"]
	end

	def remove
		calname = params[:name]
		return if calname.nil? or calname.blank?
		# FIXME: this is a bit brute force. the proper way would be using a {CAL/WEB}DAV API.
		Dir.chdir("/var/hda/calendar/html") do
			FileUtils.rm_rf(calname)
			FileUtils.rm_rf(".DAV/" + calname + ".pag")
			FileUtils.rm_rf(".DAV/" + calname + ".dir")
			@calendars = Dir["*.ics"]
		end
		@has_ical = App.where(:name => 'iCalendar').first != nil
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
 	calname = h(calendar.gsub(/.ics$/,''))
	sp = "calendar-#{calname.gsub(/ /, '_sp_')}" 
 cycle("even","odd") 
 if has_ical 
 calname 
 calname 
 else 
 calname 
 end 
spinner sp 
 link_to(theme_image_tag("ical-subscribe", :title => "Subscribe to calendar " + h(calendar) ),
            "webcal://calendar/" + h(calendar)) 
 link_to_remote(theme_image_tag("delete", :title => t('delete') + h(calendar)),
            		:url => url_for(:controller => :calendar, :action => :remove, :name => h(calendar)),
			:before => spinner_show(sp),
			:success => spinner_hide(sp),
    			:update => { :success => "calendars-table", :failure => 'error_msgs' },
    			:confirm => t('are_you_sure_you_would_like_to_delete_calendar', :calendar => h(calendar))) 
 
 else
 
 	calname = h(calendar.gsub(/.ics$/,''))
	sp = "calendar-#{calname.gsub(/ /, '_sp_')}" 
 cycle("even","odd") 
 if has_ical 
 calname 
 calname 
 else 
 calname 
 end 
spinner sp 
 link_to(theme_image_tag("ical-subscribe", :title => "Subscribe to calendar " + h(calendar) ),
            "webcal://calendar/" + h(calendar)) 
 link_to_remote(theme_image_tag("delete", :title => t('delete') + h(calendar)),
            		:url => url_for(:controller => :calendar, :action => :remove, :name => h(calendar)),
			:before => spinner_show(sp),
			:success => spinner_hide(sp),
    			:update => { :success => "calendars-table", :failure => 'error_msgs' },
    			:confirm => t('are_you_sure_you_would_like_to_delete_calendar', :calendar => h(calendar))) 
 
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

	def new
		calname = params[:name].strip
		return if calname.nil? or calname.blank?
		fname = calname + ".ics"
		Dir.chdir("/var/hda/calendar/html") do
			unless File.exists? fname
				open(calname + ".ics", "w") do |f|
					f.write empty_calendar(calname)
				end
			end
			@calendars = Dir["*.ics"]
		end
		@has_ical = App.where(:name=>'iCalendar').first != nil
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
 	calname = h(calendar.gsub(/.ics$/,''))
	sp = "calendar-#{calname.gsub(/ /, '_sp_')}" 
 cycle("even","odd") 
 if has_ical 
 calname 
 calname 
 else 
 calname 
 end 
spinner sp 
 link_to(theme_image_tag("ical-subscribe", :title => "Subscribe to calendar " + h(calendar) ),
            "webcal://calendar/" + h(calendar)) 
 link_to_remote(theme_image_tag("delete", :title => t('delete') + h(calendar)),
            		:url => url_for(:controller => :calendar, :action => :remove, :name => h(calendar)),
			:before => spinner_show(sp),
			:success => spinner_hide(sp),
    			:update => { :success => "calendars-table", :failure => 'error_msgs' },
    			:confirm => t('are_you_sure_you_would_like_to_delete_calendar', :calendar => h(calendar))) 
 
 else
 
 	calname = h(calendar.gsub(/.ics$/,''))
	sp = "calendar-#{calname.gsub(/ /, '_sp_')}" 
 cycle("even","odd") 
 if has_ical 
 calname 
 calname 
 else 
 calname 
 end 
spinner sp 
 link_to(theme_image_tag("ical-subscribe", :title => "Subscribe to calendar " + h(calendar) ),
            "webcal://calendar/" + h(calendar)) 
 link_to_remote(theme_image_tag("delete", :title => t('delete') + h(calendar)),
            		:url => url_for(:controller => :calendar, :action => :remove, :name => h(calendar)),
			:before => spinner_show(sp),
			:success => spinner_hide(sp),
    			:update => { :success => "calendars-table", :failure => 'error_msgs' },
    			:confirm => t('are_you_sure_you_would_like_to_delete_calendar', :calendar => h(calendar))) 
 
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

private
	def empty_calendar(name)
		ret = [	"BEGIN:VCALENDAR",
			"METHOD:PUBLISH",
			"PRODID:-//Amahi//platform 5.3//EN",
			"CALSCALE:GREGORIAN",
			"X-WR-CALNAME:%s",
			"VERSION:2.0",
			"END:VCALENDAR",
			""].join("\n")
		ret % [name]
	end

end
