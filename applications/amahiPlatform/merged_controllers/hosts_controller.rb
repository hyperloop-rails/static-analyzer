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

class HostsController < ApplicationController
	before_filter :admin_required

	VALID_NAME = Regexp.new "\A[A-Za-z][A-Za-z0-9\-]+\z"
	VALID_ADDRESS = Regexp.new '\A(|\d(\d?\d?)|\d(\d?\d?)\.\d(\d?\d?)\.\d(\d?\d?)\.\d(\d?\d?))\z'
	MAC_P = '(\d|[A-Fa-f])(\d|[A-Fa-f])'
	# This is the range at which DHCP starts. Strictly below is valid

	# GET /hosts
	# GET /hosts.xml
	def index
	  @page_title = 'Static IP Addresses'
	  @hosts = Host.find(:all)
	  @max = VALID_DHCP_ADDRESS_RANGE-1 

	  respond_to do |format|
	    format.html # index.html.erb
	    format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
   if hosts.size > 0 
t 'name' 
t 'static_ip_address' 
 
	name = [h(one.host), @domain].join '.'
	name = h($1) if one.host =~ /(.*)\.$/
	(base, addr) = case one.address
			when ''
				[@net, @self]
			when /^\d+$/
				[@net, [@net, h(one.address)].join('.')]
			else
				['', h(one.address)]
		end
	delete_icon = theme_image_tag("delete", :title => t('delete_static_ip'))
	wake_icon = theme_image_tag("wake", :title => t('awake_this_device_via_wol'))
	uid = one.id.to_s
	toggler = update_page do |page|
			row = "host_row_" + uid
			info = "host_info_" + uid
			page.toggle info
			page[row].toggle_class_name "settings-row-open"
		  end

 uid 
 h toggler 
 link_to(h(name), '') 
 uid 
 h(addr) 
 uid 
t 'edit_static_ip' 
 h(one.host) 
 spinner uid 
t 'delete_static_ip' 
 link_to_remote(delete_icon,
					:update => 'hosts-table',
					:confirm => t('are_you_sure_you_want_to_delete_the_static_ip', :name => name),
					:before => "Element.show('spinner-#{uid}')",
					:success => "Element.hide('spinner-#{uid}')",
					:url => { :controller => 'hosts', :action => 'delete', :id => uid }) 
t 'awake_this_device_via_wol'
 uid 
 link_to_remote(wake_icon,
							:before => "Element.show('spinner-#{uid}')",
							:success => "Element.hide('spinner-#{uid}')",
							:url => { :controller => 'hosts', :action => 'wake_system', :id => uid }) 
t 'ip_address' 
 base.blank? ? '' : base + '.' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.address),
						  :options => {
						    :id => "host_address_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'hosts',
						  :action => 'update_address',
						  :id => uid
						}) 
t 'mac_address' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.mac),
						  :options => {
						    :id => "host_mac_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'hosts',
						  :action => 'update_mac',
						  :id => uid
						}) 
t 'location' 
 link_to h(name), "http://#{h(name)}", { :target => "_blank" } 
 
 else 
t 'there_are_no_static_ips_defined' 
 end 
 
  button_to " #{t('new_static_ip')} &raquo; ", update_page { |page|
   	page.hide 'new-host-to-step1'
   	page[:host_host].value = ""
   	page[:host_address].value = ""
	page[:host_address].disabled = true
   	page[:host_mac].value = ""
	page[:host_mac].disabled = true
	page[:host_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-host-step1'
   	page[:host_host].focus
   }, :id => "new-host-to-step1" 
 error_messages_for :host 
 t 'new_static_ip' 
 form_for(newhost) do |f| 
 f.error_messages 
t 'name' 
 f.text_field :host, :size => 12, :maxlength => 32 
 @domain 
t 'the_name_you_input_above_will_be_added_to_the_DNS_server' 
t 'ip_address' 
 @net 
 f.text_field :address, :size => 4, :maxlength => 5 
t('this_ip_address_will_always_be_statically_associated_to_the_mac_address', :max => @max) 
t 'mac_address' 
 f.text_field :mac, :size => 17, :maxlength => 22 
t 'mac_address_of_the_device' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-host-step1'
					page.show 'new-host-to-step1'
					page[:host_host].value = ""
					page[:host_address].value = ""
					page[:host_mac].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:host_address].disabled = true
					page[:host_mac].disabled = true
					page[:host_create_button].disabled = true
				 } 
 submit_to_remote "create_host", " #{t('create')} &raquo; ",
					:url =>  { :controller => 'hosts', :action => 'create' },
					:html =>  { :id => "host_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "hosts", :failure => "create_hosts_error_msgs" } 
 end 
 observe_field 'host_host', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_host_check' },
			:with => "'host=' + encodeURIComponent(value)" 
 observe_field 'host_address', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 observe_field 'host_mac', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_mac_check' },
			:with => "'mac=' + encodeURIComponent(value)" 
 
 
 
 else
 
   if hosts.size > 0 
t 'name' 
t 'static_ip_address' 
 
	name = [h(one.host), @domain].join '.'
	name = h($1) if one.host =~ /(.*)\.$/
	(base, addr) = case one.address
			when ''
				[@net, @self]
			when /^\d+$/
				[@net, [@net, h(one.address)].join('.')]
			else
				['', h(one.address)]
		end
	delete_icon = theme_image_tag("delete", :title => t('delete_static_ip'))
	wake_icon = theme_image_tag("wake", :title => t('awake_this_device_via_wol'))
	uid = one.id.to_s
	toggler = update_page do |page|
			row = "host_row_" + uid
			info = "host_info_" + uid
			page.toggle info
			page[row].toggle_class_name "settings-row-open"
		  end

 uid 
 h toggler 
 link_to(h(name), '') 
 uid 
 h(addr) 
 uid 
t 'edit_static_ip' 
 h(one.host) 
 spinner uid 
t 'delete_static_ip' 
 link_to_remote(delete_icon,
					:update => 'hosts-table',
					:confirm => t('are_you_sure_you_want_to_delete_the_static_ip', :name => name),
					:before => "Element.show('spinner-#{uid}')",
					:success => "Element.hide('spinner-#{uid}')",
					:url => { :controller => 'hosts', :action => 'delete', :id => uid }) 
t 'awake_this_device_via_wol'
 uid 
 link_to_remote(wake_icon,
							:before => "Element.show('spinner-#{uid}')",
							:success => "Element.hide('spinner-#{uid}')",
							:url => { :controller => 'hosts', :action => 'wake_system', :id => uid }) 
t 'ip_address' 
 base.blank? ? '' : base + '.' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.address),
						  :options => {
						    :id => "host_address_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'hosts',
						  :action => 'update_address',
						  :id => uid
						}) 
t 'mac_address' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.mac),
						  :options => {
						    :id => "host_mac_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'hosts',
						  :action => 'update_mac',
						  :id => uid
						}) 
t 'location' 
 link_to h(name), "http://#{h(name)}", { :target => "_blank" } 
 
 else 
t 'there_are_no_static_ips_defined' 
 end 
 
  button_to " #{t('new_static_ip')} &raquo; ", update_page { |page|
   	page.hide 'new-host-to-step1'
   	page[:host_host].value = ""
   	page[:host_address].value = ""
	page[:host_address].disabled = true
   	page[:host_mac].value = ""
	page[:host_mac].disabled = true
	page[:host_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-host-step1'
   	page[:host_host].focus
   }, :id => "new-host-to-step1" 
 error_messages_for :host 
 t 'new_static_ip' 
 form_for(newhost) do |f| 
 f.error_messages 
t 'name' 
 f.text_field :host, :size => 12, :maxlength => 32 
 @domain 
t 'the_name_you_input_above_will_be_added_to_the_DNS_server' 
t 'ip_address' 
 @net 
 f.text_field :address, :size => 4, :maxlength => 5 
t('this_ip_address_will_always_be_statically_associated_to_the_mac_address', :max => @max) 
t 'mac_address' 
 f.text_field :mac, :size => 17, :maxlength => 22 
t 'mac_address_of_the_device' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-host-step1'
					page.show 'new-host-to-step1'
					page[:host_host].value = ""
					page[:host_address].value = ""
					page[:host_mac].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:host_address].disabled = true
					page[:host_mac].disabled = true
					page[:host_create_button].disabled = true
				 } 
 submit_to_remote "create_host", " #{t('create')} &raquo; ",
					:url =>  { :controller => 'hosts', :action => 'create' },
					:html =>  { :id => "host_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "hosts", :failure => "create_hosts_error_msgs" } 
 end 
 observe_field 'host_host', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_host_check' },
			:with => "'host=' + encodeURIComponent(value)" 
 observe_field 'host_address', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 observe_field 'host_mac', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_mac_check' },
			:with => "'mac=' + encodeURIComponent(value)" 
 
 
 
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
 }
	  end
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
   if hosts.size > 0 
t 'name' 
t 'static_ip_address' 
 
	name = [h(one.host), @domain].join '.'
	name = h($1) if one.host =~ /(.*)\.$/
	(base, addr) = case one.address
			when ''
				[@net, @self]
			when /^\d+$/
				[@net, [@net, h(one.address)].join('.')]
			else
				['', h(one.address)]
		end
	delete_icon = theme_image_tag("delete", :title => t('delete_static_ip'))
	wake_icon = theme_image_tag("wake", :title => t('awake_this_device_via_wol'))
	uid = one.id.to_s
	toggler = update_page do |page|
			row = "host_row_" + uid
			info = "host_info_" + uid
			page.toggle info
			page[row].toggle_class_name "settings-row-open"
		  end

 uid 
 h toggler 
 link_to(h(name), '') 
 uid 
 h(addr) 
 uid 
t 'edit_static_ip' 
 h(one.host) 
 spinner uid 
t 'delete_static_ip' 
 link_to_remote(delete_icon,
					:update => 'hosts-table',
					:confirm => t('are_you_sure_you_want_to_delete_the_static_ip', :name => name),
					:before => "Element.show('spinner-#{uid}')",
					:success => "Element.hide('spinner-#{uid}')",
					:url => { :controller => 'hosts', :action => 'delete', :id => uid }) 
t 'awake_this_device_via_wol'
 uid 
 link_to_remote(wake_icon,
							:before => "Element.show('spinner-#{uid}')",
							:success => "Element.hide('spinner-#{uid}')",
							:url => { :controller => 'hosts', :action => 'wake_system', :id => uid }) 
t 'ip_address' 
 base.blank? ? '' : base + '.' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.address),
						  :options => {
						    :id => "host_address_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'hosts',
						  :action => 'update_address',
						  :id => uid
						}) 
t 'mac_address' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.mac),
						  :options => {
						    :id => "host_mac_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'hosts',
						  :action => 'update_mac',
						  :id => uid
						}) 
t 'location' 
 link_to h(name), "http://#{h(name)}", { :target => "_blank" } 
 
 else 
t 'there_are_no_static_ips_defined' 
 end 
 
  button_to " #{t('new_static_ip')} &raquo; ", update_page { |page|
   	page.hide 'new-host-to-step1'
   	page[:host_host].value = ""
   	page[:host_address].value = ""
	page[:host_address].disabled = true
   	page[:host_mac].value = ""
	page[:host_mac].disabled = true
	page[:host_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-host-step1'
   	page[:host_host].focus
   }, :id => "new-host-to-step1" 
 error_messages_for :host 
 t 'new_static_ip' 
 form_for(newhost) do |f| 
 f.error_messages 
t 'name' 
 f.text_field :host, :size => 12, :maxlength => 32 
 @domain 
t 'the_name_you_input_above_will_be_added_to_the_DNS_server' 
t 'ip_address' 
 @net 
 f.text_field :address, :size => 4, :maxlength => 5 
t('this_ip_address_will_always_be_statically_associated_to_the_mac_address', :max => @max) 
t 'mac_address' 
 f.text_field :mac, :size => 17, :maxlength => 22 
t 'mac_address_of_the_device' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-host-step1'
					page.show 'new-host-to-step1'
					page[:host_host].value = ""
					page[:host_address].value = ""
					page[:host_mac].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:host_address].disabled = true
					page[:host_mac].disabled = true
					page[:host_create_button].disabled = true
				 } 
 submit_to_remote "create_host", " #{t('create')} &raquo; ",
					:url =>  { :controller => 'hosts', :action => 'create' },
					:html =>  { :id => "host_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "hosts", :failure => "create_hosts_error_msgs" } 
 end 
 observe_field 'host_host', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_host_check' },
			:with => "'host=' + encodeURIComponent(value)" 
 observe_field 'host_address', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 observe_field 'host_mac', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_mac_check' },
			:with => "'mac=' + encodeURIComponent(value)" 
 
 
 
 else
 
   if hosts.size > 0 
t 'name' 
t 'static_ip_address' 
 
	name = [h(one.host), @domain].join '.'
	name = h($1) if one.host =~ /(.*)\.$/
	(base, addr) = case one.address
			when ''
				[@net, @self]
			when /^\d+$/
				[@net, [@net, h(one.address)].join('.')]
			else
				['', h(one.address)]
		end
	delete_icon = theme_image_tag("delete", :title => t('delete_static_ip'))
	wake_icon = theme_image_tag("wake", :title => t('awake_this_device_via_wol'))
	uid = one.id.to_s
	toggler = update_page do |page|
			row = "host_row_" + uid
			info = "host_info_" + uid
			page.toggle info
			page[row].toggle_class_name "settings-row-open"
		  end

 uid 
 h toggler 
 link_to(h(name), '') 
 uid 
 h(addr) 
 uid 
t 'edit_static_ip' 
 h(one.host) 
 spinner uid 
t 'delete_static_ip' 
 link_to_remote(delete_icon,
					:update => 'hosts-table',
					:confirm => t('are_you_sure_you_want_to_delete_the_static_ip', :name => name),
					:before => "Element.show('spinner-#{uid}')",
					:success => "Element.hide('spinner-#{uid}')",
					:url => { :controller => 'hosts', :action => 'delete', :id => uid }) 
t 'awake_this_device_via_wol'
 uid 
 link_to_remote(wake_icon,
							:before => "Element.show('spinner-#{uid}')",
							:success => "Element.hide('spinner-#{uid}')",
							:url => { :controller => 'hosts', :action => 'wake_system', :id => uid }) 
t 'ip_address' 
 base.blank? ? '' : base + '.' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.address),
						  :options => {
						    :id => "host_address_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'hosts',
						  :action => 'update_address',
						  :id => uid
						}) 
t 'mac_address' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.mac),
						  :options => {
						    :id => "host_mac_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'hosts',
						  :action => 'update_mac',
						  :id => uid
						}) 
t 'location' 
 link_to h(name), "http://#{h(name)}", { :target => "_blank" } 
 
 else 
t 'there_are_no_static_ips_defined' 
 end 
 
  button_to " #{t('new_static_ip')} &raquo; ", update_page { |page|
   	page.hide 'new-host-to-step1'
   	page[:host_host].value = ""
   	page[:host_address].value = ""
	page[:host_address].disabled = true
   	page[:host_mac].value = ""
	page[:host_mac].disabled = true
	page[:host_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-host-step1'
   	page[:host_host].focus
   }, :id => "new-host-to-step1" 
 error_messages_for :host 
 t 'new_static_ip' 
 form_for(newhost) do |f| 
 f.error_messages 
t 'name' 
 f.text_field :host, :size => 12, :maxlength => 32 
 @domain 
t 'the_name_you_input_above_will_be_added_to_the_DNS_server' 
t 'ip_address' 
 @net 
 f.text_field :address, :size => 4, :maxlength => 5 
t('this_ip_address_will_always_be_statically_associated_to_the_mac_address', :max => @max) 
t 'mac_address' 
 f.text_field :mac, :size => 17, :maxlength => 22 
t 'mac_address_of_the_device' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-host-step1'
					page.show 'new-host-to-step1'
					page[:host_host].value = ""
					page[:host_address].value = ""
					page[:host_mac].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:host_address].disabled = true
					page[:host_mac].disabled = true
					page[:host_create_button].disabled = true
				 } 
 submit_to_remote "create_host", " #{t('create')} &raquo; ",
					:url =>  { :controller => 'hosts', :action => 'create' },
					:html =>  { :id => "host_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "hosts", :failure => "create_hosts_error_msgs" } 
 end 
 observe_field 'host_host', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_host_check' },
			:with => "'host=' + encodeURIComponent(value)" 
 observe_field 'host_address', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 observe_field 'host_mac', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_mac_check' },
			:with => "'mac=' + encodeURIComponent(value)" 
 
 
 
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

	# GET /hosts/1
	# GET /hosts/1.xml
	def show
	  @host = Host.find(params[:id])

	  respond_to do |format|
	    format.html # show.html.erb
	    format.xml  { render :xml => @host }
	  end
	end

	# GET /hosts/new
	# GET /hosts/new.xml
	def new
	  @host = Host.new

	  respond_to do |format|
	    format.html # new.html.erb
	    format.xml  { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  button_to " #{t('new_static_ip')} &raquo; ", update_page { |page|
   	page.hide 'new-host-to-step1'
   	page[:host_host].value = ""
   	page[:host_address].value = ""
	page[:host_address].disabled = true
   	page[:host_mac].value = ""
	page[:host_mac].disabled = true
	page[:host_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-host-step1'
   	page[:host_host].focus
   }, :id => "new-host-to-step1" 
 error_messages_for :host 
 t 'new_static_ip' 
 form_for(newhost) do |f| 
 f.error_messages 
t 'name' 
 f.text_field :host, :size => 12, :maxlength => 32 
 @domain 
t 'the_name_you_input_above_will_be_added_to_the_DNS_server' 
t 'ip_address' 
 @net 
 f.text_field :address, :size => 4, :maxlength => 5 
t('this_ip_address_will_always_be_statically_associated_to_the_mac_address', :max => @max) 
t 'mac_address' 
 f.text_field :mac, :size => 17, :maxlength => 22 
t 'mac_address_of_the_device' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-host-step1'
					page.show 'new-host-to-step1'
					page[:host_host].value = ""
					page[:host_address].value = ""
					page[:host_mac].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:host_address].disabled = true
					page[:host_mac].disabled = true
					page[:host_create_button].disabled = true
				 } 
 submit_to_remote "create_host", " #{t('create')} &raquo; ",
					:url =>  { :controller => 'hosts', :action => 'create' },
					:html =>  { :id => "host_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "hosts", :failure => "create_hosts_error_msgs" } 
 end 
 observe_field 'host_host', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_host_check' },
			:with => "'host=' + encodeURIComponent(value)" 
 observe_field 'host_address', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 observe_field 'host_mac', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_mac_check' },
			:with => "'mac=' + encodeURIComponent(value)" 
 
 
 else
 
  button_to " #{t('new_static_ip')} &raquo; ", update_page { |page|
   	page.hide 'new-host-to-step1'
   	page[:host_host].value = ""
   	page[:host_address].value = ""
	page[:host_address].disabled = true
   	page[:host_mac].value = ""
	page[:host_mac].disabled = true
	page[:host_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-host-step1'
   	page[:host_host].focus
   }, :id => "new-host-to-step1" 
 error_messages_for :host 
 t 'new_static_ip' 
 form_for(newhost) do |f| 
 f.error_messages 
t 'name' 
 f.text_field :host, :size => 12, :maxlength => 32 
 @domain 
t 'the_name_you_input_above_will_be_added_to_the_DNS_server' 
t 'ip_address' 
 @net 
 f.text_field :address, :size => 4, :maxlength => 5 
t('this_ip_address_will_always_be_statically_associated_to_the_mac_address', :max => @max) 
t 'mac_address' 
 f.text_field :mac, :size => 17, :maxlength => 22 
t 'mac_address_of_the_device' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-host-step1'
					page.show 'new-host-to-step1'
					page[:host_host].value = ""
					page[:host_address].value = ""
					page[:host_mac].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:host_address].disabled = true
					page[:host_mac].disabled = true
					page[:host_create_button].disabled = true
				 } 
 submit_to_remote "create_host", " #{t('create')} &raquo; ",
					:url =>  { :controller => 'hosts', :action => 'create' },
					:html =>  { :id => "host_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "hosts", :failure => "create_hosts_error_msgs" } 
 end 
 observe_field 'host_host', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_host_check' },
			:with => "'host=' + encodeURIComponent(value)" 
 observe_field 'host_address', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 observe_field 'host_mac', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_mac_check' },
			:with => "'mac=' + encodeURIComponent(value)" 
 
 
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
 }
	  end
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
  button_to " #{t('new_static_ip')} &raquo; ", update_page { |page|
   	page.hide 'new-host-to-step1'
   	page[:host_host].value = ""
   	page[:host_address].value = ""
	page[:host_address].disabled = true
   	page[:host_mac].value = ""
	page[:host_mac].disabled = true
	page[:host_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-host-step1'
   	page[:host_host].focus
   }, :id => "new-host-to-step1" 
 error_messages_for :host 
 t 'new_static_ip' 
 form_for(newhost) do |f| 
 f.error_messages 
t 'name' 
 f.text_field :host, :size => 12, :maxlength => 32 
 @domain 
t 'the_name_you_input_above_will_be_added_to_the_DNS_server' 
t 'ip_address' 
 @net 
 f.text_field :address, :size => 4, :maxlength => 5 
t('this_ip_address_will_always_be_statically_associated_to_the_mac_address', :max => @max) 
t 'mac_address' 
 f.text_field :mac, :size => 17, :maxlength => 22 
t 'mac_address_of_the_device' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-host-step1'
					page.show 'new-host-to-step1'
					page[:host_host].value = ""
					page[:host_address].value = ""
					page[:host_mac].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:host_address].disabled = true
					page[:host_mac].disabled = true
					page[:host_create_button].disabled = true
				 } 
 submit_to_remote "create_host", " #{t('create')} &raquo; ",
					:url =>  { :controller => 'hosts', :action => 'create' },
					:html =>  { :id => "host_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "hosts", :failure => "create_hosts_error_msgs" } 
 end 
 observe_field 'host_host', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_host_check' },
			:with => "'host=' + encodeURIComponent(value)" 
 observe_field 'host_address', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 observe_field 'host_mac', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_mac_check' },
			:with => "'mac=' + encodeURIComponent(value)" 
 
 
 else
 
  button_to " #{t('new_static_ip')} &raquo; ", update_page { |page|
   	page.hide 'new-host-to-step1'
   	page[:host_host].value = ""
   	page[:host_address].value = ""
	page[:host_address].disabled = true
   	page[:host_mac].value = ""
	page[:host_mac].disabled = true
	page[:host_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-host-step1'
   	page[:host_host].focus
   }, :id => "new-host-to-step1" 
 error_messages_for :host 
 t 'new_static_ip' 
 form_for(newhost) do |f| 
 f.error_messages 
t 'name' 
 f.text_field :host, :size => 12, :maxlength => 32 
 @domain 
t 'the_name_you_input_above_will_be_added_to_the_DNS_server' 
t 'ip_address' 
 @net 
 f.text_field :address, :size => 4, :maxlength => 5 
t('this_ip_address_will_always_be_statically_associated_to_the_mac_address', :max => @max) 
t 'mac_address' 
 f.text_field :mac, :size => 17, :maxlength => 22 
t 'mac_address_of_the_device' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-host-step1'
					page.show 'new-host-to-step1'
					page[:host_host].value = ""
					page[:host_address].value = ""
					page[:host_mac].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:host_address].disabled = true
					page[:host_mac].disabled = true
					page[:host_create_button].disabled = true
				 } 
 submit_to_remote "create_host", " #{t('create')} &raquo; ",
					:url =>  { :controller => 'hosts', :action => 'create' },
					:html =>  { :id => "host_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "hosts", :failure => "create_hosts_error_msgs" } 
 end 
 observe_field 'host_host', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_host_check' },
			:with => "'host=' + encodeURIComponent(value)" 
 observe_field 'host_address', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 observe_field 'host_mac', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_mac_check' },
			:with => "'mac=' + encodeURIComponent(value)" 
 
 
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

	# GET /hosts/1/edit
	def edit
	  @host = Host.find(params[:id])
	  @net = Setting.get 'net'
	end

	# POST /hosts
	# POST /hosts.xml
	def create
	  @host = Host.new(params[:host])
	  @domain = Setting.get 'domain'

	  respond_to do |format|
	    if @host.save
	      format.html do
	      		@net = Setting.get('net')
	      		@self = [@net, Setting.get('self-address')].join '.'
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
   if hosts.size > 0 
t 'name' 
t 'static_ip_address' 
 
	name = [h(one.host), @domain].join '.'
	name = h($1) if one.host =~ /(.*)\.$/
	(base, addr) = case one.address
			when ''
				[@net, @self]
			when /^\d+$/
				[@net, [@net, h(one.address)].join('.')]
			else
				['', h(one.address)]
		end
	delete_icon = theme_image_tag("delete", :title => t('delete_static_ip'))
	wake_icon = theme_image_tag("wake", :title => t('awake_this_device_via_wol'))
	uid = one.id.to_s
	toggler = update_page do |page|
			row = "host_row_" + uid
			info = "host_info_" + uid
			page.toggle info
			page[row].toggle_class_name "settings-row-open"
		  end

 uid 
 h toggler 
 link_to(h(name), '') 
 uid 
 h(addr) 
 uid 
t 'edit_static_ip' 
 h(one.host) 
 spinner uid 
t 'delete_static_ip' 
 link_to_remote(delete_icon,
					:update => 'hosts-table',
					:confirm => t('are_you_sure_you_want_to_delete_the_static_ip', :name => name),
					:before => "Element.show('spinner-#{uid}')",
					:success => "Element.hide('spinner-#{uid}')",
					:url => { :controller => 'hosts', :action => 'delete', :id => uid }) 
t 'awake_this_device_via_wol'
 uid 
 link_to_remote(wake_icon,
							:before => "Element.show('spinner-#{uid}')",
							:success => "Element.hide('spinner-#{uid}')",
							:url => { :controller => 'hosts', :action => 'wake_system', :id => uid }) 
t 'ip_address' 
 base.blank? ? '' : base + '.' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.address),
						  :options => {
						    :id => "host_address_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'hosts',
						  :action => 'update_address',
						  :id => uid
						}) 
t 'mac_address' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.mac),
						  :options => {
						    :id => "host_mac_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'hosts',
						  :action => 'update_mac',
						  :id => uid
						}) 
t 'location' 
 link_to h(name), "http://#{h(name)}", { :target => "_blank" } 
 
 else 
t 'there_are_no_static_ips_defined' 
 end 
 
  button_to " #{t('new_static_ip')} &raquo; ", update_page { |page|
   	page.hide 'new-host-to-step1'
   	page[:host_host].value = ""
   	page[:host_address].value = ""
	page[:host_address].disabled = true
   	page[:host_mac].value = ""
	page[:host_mac].disabled = true
	page[:host_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-host-step1'
   	page[:host_host].focus
   }, :id => "new-host-to-step1" 
 error_messages_for :host 
 t 'new_static_ip' 
 form_for(newhost) do |f| 
 f.error_messages 
t 'name' 
 f.text_field :host, :size => 12, :maxlength => 32 
 @domain 
t 'the_name_you_input_above_will_be_added_to_the_DNS_server' 
t 'ip_address' 
 @net 
 f.text_field :address, :size => 4, :maxlength => 5 
t('this_ip_address_will_always_be_statically_associated_to_the_mac_address', :max => @max) 
t 'mac_address' 
 f.text_field :mac, :size => 17, :maxlength => 22 
t 'mac_address_of_the_device' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-host-step1'
					page.show 'new-host-to-step1'
					page[:host_host].value = ""
					page[:host_address].value = ""
					page[:host_mac].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:host_address].disabled = true
					page[:host_mac].disabled = true
					page[:host_create_button].disabled = true
				 } 
 submit_to_remote "create_host", " #{t('create')} &raquo; ",
					:url =>  { :controller => 'hosts', :action => 'create' },
					:html =>  { :id => "host_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "hosts", :failure => "create_hosts_error_msgs" } 
 end 
 observe_field 'host_host', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_host_check' },
			:with => "'host=' + encodeURIComponent(value)" 
 observe_field 'host_address', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 observe_field 'host_mac', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_mac_check' },
			:with => "'mac=' + encodeURIComponent(value)" 
 
 
 
 else
 
   if hosts.size > 0 
t 'name' 
t 'static_ip_address' 
 
	name = [h(one.host), @domain].join '.'
	name = h($1) if one.host =~ /(.*)\.$/
	(base, addr) = case one.address
			when ''
				[@net, @self]
			when /^\d+$/
				[@net, [@net, h(one.address)].join('.')]
			else
				['', h(one.address)]
		end
	delete_icon = theme_image_tag("delete", :title => t('delete_static_ip'))
	wake_icon = theme_image_tag("wake", :title => t('awake_this_device_via_wol'))
	uid = one.id.to_s
	toggler = update_page do |page|
			row = "host_row_" + uid
			info = "host_info_" + uid
			page.toggle info
			page[row].toggle_class_name "settings-row-open"
		  end

 uid 
 h toggler 
 link_to(h(name), '') 
 uid 
 h(addr) 
 uid 
t 'edit_static_ip' 
 h(one.host) 
 spinner uid 
t 'delete_static_ip' 
 link_to_remote(delete_icon,
					:update => 'hosts-table',
					:confirm => t('are_you_sure_you_want_to_delete_the_static_ip', :name => name),
					:before => "Element.show('spinner-#{uid}')",
					:success => "Element.hide('spinner-#{uid}')",
					:url => { :controller => 'hosts', :action => 'delete', :id => uid }) 
t 'awake_this_device_via_wol'
 uid 
 link_to_remote(wake_icon,
							:before => "Element.show('spinner-#{uid}')",
							:success => "Element.hide('spinner-#{uid}')",
							:url => { :controller => 'hosts', :action => 'wake_system', :id => uid }) 
t 'ip_address' 
 base.blank? ? '' : base + '.' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.address),
						  :options => {
						    :id => "host_address_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'hosts',
						  :action => 'update_address',
						  :id => uid
						}) 
t 'mac_address' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.mac),
						  :options => {
						    :id => "host_mac_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'hosts',
						  :action => 'update_mac',
						  :id => uid
						}) 
t 'location' 
 link_to h(name), "http://#{h(name)}", { :target => "_blank" } 
 
 else 
t 'there_are_no_static_ips_defined' 
 end 
 
  button_to " #{t('new_static_ip')} &raquo; ", update_page { |page|
   	page.hide 'new-host-to-step1'
   	page[:host_host].value = ""
   	page[:host_address].value = ""
	page[:host_address].disabled = true
   	page[:host_mac].value = ""
	page[:host_mac].disabled = true
	page[:host_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-host-step1'
   	page[:host_host].focus
   }, :id => "new-host-to-step1" 
 error_messages_for :host 
 t 'new_static_ip' 
 form_for(newhost) do |f| 
 f.error_messages 
t 'name' 
 f.text_field :host, :size => 12, :maxlength => 32 
 @domain 
t 'the_name_you_input_above_will_be_added_to_the_DNS_server' 
t 'ip_address' 
 @net 
 f.text_field :address, :size => 4, :maxlength => 5 
t('this_ip_address_will_always_be_statically_associated_to_the_mac_address', :max => @max) 
t 'mac_address' 
 f.text_field :mac, :size => 17, :maxlength => 22 
t 'mac_address_of_the_device' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-host-step1'
					page.show 'new-host-to-step1'
					page[:host_host].value = ""
					page[:host_address].value = ""
					page[:host_mac].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:host_address].disabled = true
					page[:host_mac].disabled = true
					page[:host_create_button].disabled = true
				 } 
 submit_to_remote "create_host", " #{t('create')} &raquo; ",
					:url =>  { :controller => 'hosts', :action => 'create' },
					:html =>  { :id => "host_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "hosts", :failure => "create_hosts_error_msgs" } 
 end 
 observe_field 'host_host', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_host_check' },
			:with => "'host=' + encodeURIComponent(value)" 
 observe_field 'host_address', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 observe_field 'host_mac', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_mac_check' },
			:with => "'mac=' + encodeURIComponent(value)" 
 
 
 
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
	      format.xml  { render :xml => @host, :status => :created, :location => @host }
	    else
	      format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  button_to " #{t('new_static_ip')} &raquo; ", update_page { |page|
   	page.hide 'new-host-to-step1'
   	page[:host_host].value = ""
   	page[:host_address].value = ""
	page[:host_address].disabled = true
   	page[:host_mac].value = ""
	page[:host_mac].disabled = true
	page[:host_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-host-step1'
   	page[:host_host].focus
   }, :id => "new-host-to-step1" 
 error_messages_for :host 
 t 'new_static_ip' 
 form_for(newhost) do |f| 
 f.error_messages 
t 'name' 
 f.text_field :host, :size => 12, :maxlength => 32 
 @domain 
t 'the_name_you_input_above_will_be_added_to_the_DNS_server' 
t 'ip_address' 
 @net 
 f.text_field :address, :size => 4, :maxlength => 5 
t('this_ip_address_will_always_be_statically_associated_to_the_mac_address', :max => @max) 
t 'mac_address' 
 f.text_field :mac, :size => 17, :maxlength => 22 
t 'mac_address_of_the_device' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-host-step1'
					page.show 'new-host-to-step1'
					page[:host_host].value = ""
					page[:host_address].value = ""
					page[:host_mac].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:host_address].disabled = true
					page[:host_mac].disabled = true
					page[:host_create_button].disabled = true
				 } 
 submit_to_remote "create_host", " #{t('create')} &raquo; ",
					:url =>  { :controller => 'hosts', :action => 'create' },
					:html =>  { :id => "host_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "hosts", :failure => "create_hosts_error_msgs" } 
 end 
 observe_field 'host_host', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_host_check' },
			:with => "'host=' + encodeURIComponent(value)" 
 observe_field 'host_address', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 observe_field 'host_mac', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_mac_check' },
			:with => "'mac=' + encodeURIComponent(value)" 
 
 
 else
 
  button_to " #{t('new_static_ip')} &raquo; ", update_page { |page|
   	page.hide 'new-host-to-step1'
   	page[:host_host].value = ""
   	page[:host_address].value = ""
	page[:host_address].disabled = true
   	page[:host_mac].value = ""
	page[:host_mac].disabled = true
	page[:host_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-host-step1'
   	page[:host_host].focus
   }, :id => "new-host-to-step1" 
 error_messages_for :host 
 t 'new_static_ip' 
 form_for(newhost) do |f| 
 f.error_messages 
t 'name' 
 f.text_field :host, :size => 12, :maxlength => 32 
 @domain 
t 'the_name_you_input_above_will_be_added_to_the_DNS_server' 
t 'ip_address' 
 @net 
 f.text_field :address, :size => 4, :maxlength => 5 
t('this_ip_address_will_always_be_statically_associated_to_the_mac_address', :max => @max) 
t 'mac_address' 
 f.text_field :mac, :size => 17, :maxlength => 22 
t 'mac_address_of_the_device' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-host-step1'
					page.show 'new-host-to-step1'
					page[:host_host].value = ""
					page[:host_address].value = ""
					page[:host_mac].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:host_address].disabled = true
					page[:host_mac].disabled = true
					page[:host_create_button].disabled = true
				 } 
 submit_to_remote "create_host", " #{t('create')} &raquo; ",
					:url =>  { :controller => 'hosts', :action => 'create' },
					:html =>  { :id => "host_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "hosts", :failure => "create_hosts_error_msgs" } 
 end 
 observe_field 'host_host', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_host_check' },
			:with => "'host=' + encodeURIComponent(value)" 
 observe_field 'host_address', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 observe_field 'host_mac', :frequency => 0.5,
			:url => { :controller => 'hosts', :action => 'new_mac_check' },
			:with => "'mac=' + encodeURIComponent(value)" 
 
 
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
 }
	      format.xml  { render :xml => @host.errors, :status => :unprocessable_entity }
	    end
	  end
	end

	# PUT /hosts/1
	# PUT /hosts/1.xml
	def update
	  @host = Host.find(params[:id])
	  @domain = Setting.get 'domain'

	  respond_to do |format|
	    if @host.update_attributes(params[:host])
	      flash[:notice] = 'Host was successfully updated.'
	      format.html { redirect_to(@host) }
	      format.xml  { head :ok }
	    else
	      format.html { render :action => "edit" }
	      format.xml  { render :xml => @host.errors, :status => :unprocessable_entity }
	    end
	  end
	end

	# DELETE /hosts/1
	# DELETE /hosts/1.xml
	def destroy
	  @host = Host.find(params[:id])
	  @host.destroy

	  respond_to do |format|
	    format.html { redirect_to(hosts_url) }
	    format.xml  { head :ok }
	  end
	end

	def update_address
		a = Host.find(params[:id])
		addr = params[:value].strip
		# FIXME - report errors to the user!
		unless valid_short_address?(addr)
			render :text => a.address
			return
		end
		h = Host.where(:address=>addr).first
		if h.nil?
			# no such address, ok to use it
			a.address = addr
			a.save
			a.reload
		end
		render :text => a.address
	end

	def update_mac
		a = Host.find(params[:id])
		mac = params[:value].strip
		# FIXME - report errors to the user!
		unless valid_mac?(mac)
			render :text => a.mac
			return
		end
		h = Host.where(:mac=>mac).first
		if h.nil?
			# no such address, ok to use it
			a.mac = mac
			a.save
			a.reload
		end
		render :text => a.mac
	end

	def delete
		a = Host.find params[:id]
		a.destroy
		hosts = Host.all
		@net = Setting.get('net')
		@domain = Setting.get('domain')
		@self = [@net, Setting.get('self-address')].join '.'
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
  if hosts.size > 0 
t 'name' 
t 'static_ip_address' 
 
	name = [h(one.host), @domain].join '.'
	name = h($1) if one.host =~ /(.*)\.$/
	(base, addr) = case one.address
			when ''
				[@net, @self]
			when /^\d+$/
				[@net, [@net, h(one.address)].join('.')]
			else
				['', h(one.address)]
		end
	delete_icon = theme_image_tag("delete", :title => t('delete_static_ip'))
	wake_icon = theme_image_tag("wake", :title => t('awake_this_device_via_wol'))
	uid = one.id.to_s
	toggler = update_page do |page|
			row = "host_row_" + uid
			info = "host_info_" + uid
			page.toggle info
			page[row].toggle_class_name "settings-row-open"
		  end

 uid 
 h toggler 
 link_to(h(name), '') 
 uid 
 h(addr) 
 uid 
t 'edit_static_ip' 
 h(one.host) 
 spinner uid 
t 'delete_static_ip' 
 link_to_remote(delete_icon,
					:update => 'hosts-table',
					:confirm => t('are_you_sure_you_want_to_delete_the_static_ip', :name => name),
					:before => "Element.show('spinner-#{uid}')",
					:success => "Element.hide('spinner-#{uid}')",
					:url => { :controller => 'hosts', :action => 'delete', :id => uid }) 
t 'awake_this_device_via_wol'
 uid 
 link_to_remote(wake_icon,
							:before => "Element.show('spinner-#{uid}')",
							:success => "Element.hide('spinner-#{uid}')",
							:url => { :controller => 'hosts', :action => 'wake_system', :id => uid }) 
t 'ip_address' 
 base.blank? ? '' : base + '.' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.address),
						  :options => {
						    :id => "host_address_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'hosts',
						  :action => 'update_address',
						  :id => uid
						}) 
t 'mac_address' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.mac),
						  :options => {
						    :id => "host_mac_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'hosts',
						  :action => 'update_mac',
						  :id => uid
						}) 
t 'location' 
 link_to h(name), "http://#{h(name)}", { :target => "_blank" } 
 
 else 
t 'there_are_no_static_ips_defined' 
 end 
 
 else
 
  if hosts.size > 0 
t 'name' 
t 'static_ip_address' 
 
	name = [h(one.host), @domain].join '.'
	name = h($1) if one.host =~ /(.*)\.$/
	(base, addr) = case one.address
			when ''
				[@net, @self]
			when /^\d+$/
				[@net, [@net, h(one.address)].join('.')]
			else
				['', h(one.address)]
		end
	delete_icon = theme_image_tag("delete", :title => t('delete_static_ip'))
	wake_icon = theme_image_tag("wake", :title => t('awake_this_device_via_wol'))
	uid = one.id.to_s
	toggler = update_page do |page|
			row = "host_row_" + uid
			info = "host_info_" + uid
			page.toggle info
			page[row].toggle_class_name "settings-row-open"
		  end

 uid 
 h toggler 
 link_to(h(name), '') 
 uid 
 h(addr) 
 uid 
t 'edit_static_ip' 
 h(one.host) 
 spinner uid 
t 'delete_static_ip' 
 link_to_remote(delete_icon,
					:update => 'hosts-table',
					:confirm => t('are_you_sure_you_want_to_delete_the_static_ip', :name => name),
					:before => "Element.show('spinner-#{uid}')",
					:success => "Element.hide('spinner-#{uid}')",
					:url => { :controller => 'hosts', :action => 'delete', :id => uid }) 
t 'awake_this_device_via_wol'
 uid 
 link_to_remote(wake_icon,
							:before => "Element.show('spinner-#{uid}')",
							:success => "Element.hide('spinner-#{uid}')",
							:url => { :controller => 'hosts', :action => 'wake_system', :id => uid }) 
t 'ip_address' 
 base.blank? ? '' : base + '.' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.address),
						  :options => {
						    :id => "host_address_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'hosts',
						  :action => 'update_address',
						  :id => uid
						}) 
t 'mac_address' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.mac),
						  :options => {
						    :id => "host_mac_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'hosts',
						  :action => 'update_mac',
						  :id => uid
						}) 
t 'location' 
 link_to h(name), "http://#{h(name)}", { :target => "_blank" } 
 
 else 
t 'there_are_no_static_ips_defined' 
 end 
 
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


	def new_host_check
		n = params[:host]
		if n.nil? or n.blank?
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
 page[:host_messages].replace_html theme_image_tag("stop") + " " + t('name_is_not_valid')
page.show 'host_messages'
page[:host_address].disabled = true
page[:host_mac].disabled = true
page[:host_create_button].disabled = true
 
 else
 
 page[:host_messages].replace_html theme_image_tag("stop") + " " + t('name_is_not_valid')
page.show 'host_messages'
page[:host_address].disabled = true
page[:host_mac].disabled = true
page[:host_create_button].disabled = true
 
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
		n = n.strip
		if (not (valid_name?(n))) or (n.size > 32)
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
 page[:host_messages].replace_html theme_image_tag("stop") + " " + t('name_is_not_valid')
page.show 'host_messages'
page[:host_address].disabled = true
page[:host_mac].disabled = true
page[:host_create_button].disabled = true
 
 else
 
 page[:host_messages].replace_html theme_image_tag("stop") + " " + t('name_is_not_valid')
page.show 'host_messages'
page[:host_address].disabled = true
page[:host_mac].disabled = true
page[:host_create_button].disabled = true
 
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
		a = Host.where(:host=>n).first
		if a.nil?
			# no such alias, ok to create it
			@name = n
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
 page[:host_messages].replace_html theme_image_tag("ok") + " " + t('name_looks_good')
page.show 'host_messages'
page[:host_address].disabled = false
 
 else
 
 page[:host_messages].replace_html theme_image_tag("ok") + " " + t('name_looks_good')
page.show 'host_messages'
page[:host_address].disabled = false
 
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

		else
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
 page[:host_messages].replace_html theme_image_tag("stop") + " " + t('name_is_taken_already_or_is_reserved')
page.show 'host_messages'
page[:host_address].disabled = true
page[:host_mac].disabled = true
page[:host_create_button].disabled = true
 
 else
 
 page[:host_messages].replace_html theme_image_tag("stop") + " " + t('name_is_taken_already_or_is_reserved')
page.show 'host_messages'
page[:host_address].disabled = true
page[:host_mac].disabled = true
page[:host_create_button].disabled = true
 
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

	def new_address_check
		n = params[:address]
		n = '' if n.nil? or n.blank?
		n = n.strip
		unless valid_short_address?(n)
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
 page[:address_messages].replace_html theme_image_tag("stop") + " " + t('address_is_not_valid')
page.show 'address_messages'
page[:host_mac].disabled = true
page[:host_create_button].disabled = true
 
 else
 
 page[:address_messages].replace_html theme_image_tag("stop") + " " + t('address_is_not_valid')
page.show 'address_messages'
page[:host_mac].disabled = true
page[:host_create_button].disabled = true
 
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
		a = Host.where(:address=>n).first
		if a.nil?
			# no such address, ok to create it
			@name = n
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
 page[:address_messages].replace_html theme_image_tag("ok") + " " + t('address_looks_good')
page.show 'address_messages'
page[:host_mac].disabled = false
 
 else
 
 page[:address_messages].replace_html theme_image_tag("ok") + " " + t('address_looks_good')
page.show 'address_messages'
page[:host_mac].disabled = false
 
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

		else
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
 page[:address_messages].replace_html theme_image_tag("stop") + " " + t('address_already_allocated')
page.show 'address_messages'
page[:host_mac].disabled = true
page[:host_create_button].disabled = true
 
 else
 
 page[:address_messages].replace_html theme_image_tag("stop") + " " + t('address_already_allocated')
page.show 'address_messages'
page[:host_mac].disabled = true
page[:host_create_button].disabled = true
 
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

	def new_mac_check
		n = params[:mac]
		n = '' if n.nil? or n.blank?
		n = n.strip
		if (not (valid_mac?(n))) or (n.size > 18)
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
 page[:mac_messages].replace_html theme_image_tag("stop") + " " + t('mac_is_invalid')
page.show 'mac_messages'
page[:host_create_button].disabled = true 
 else
 
 page[:mac_messages].replace_html theme_image_tag("stop") + " " + t('mac_is_invalid')
page.show 'mac_messages'
page[:host_create_button].disabled = true 
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
		a = Host.where(:mac=>n).first
		if a.nil?
			# no such mac, ok to create it
			@name = n
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
 page[:mac_messages].replace_html theme_image_tag("ok") + " " + t('mac_looks_good')
page.show 'mac_messages'
page[:host_create_button].disabled = false
 
 else
 
 page[:mac_messages].replace_html theme_image_tag("ok") + " " + t('mac_looks_good')
page.show 'mac_messages'
page[:host_create_button].disabled = false
 
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

		else
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
 page[:mac_messages].replace_html theme_image_tag("stop") + " " + t('mac_already_allocated')
page.show 'mac_messages'
page[:host_create_button].disabled = true
 
 else
 
 page[:mac_messages].replace_html theme_image_tag("stop") + " " + t('mac_already_allocated')
page.show 'mac_messages'
page[:host_create_button].disabled = true
 
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

	def wake_system
		@host = Host.find(params[:id])
		if @host
			system "wol #{@host.mac}"
		end
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
 page["wake-icon-#{@host.id}"].replace_html theme_image_tag("ok")
 
 else
 
 page["wake-icon-#{@host.id}"].replace_html theme_image_tag("ok")
 
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

	def wake_mac
		@mac = params[:mac]
		if @mac
			system "wol #{@mac}"
		end
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
 page["wake-icon-#{@mac}"].replace_html theme_image_tag("ok")
 
 else
 
 page["wake-icon-#{@mac}"].replace_html theme_image_tag("ok")
 
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

	# FIXME-cpg: some of this should probably be in the model for hosts

	def valid_name?(nm)
		return false unless (nm =~ VALID_NAME)
		true
	end

	def valid_short_address?(addr)
		if addr =~ Regexp.new('\A(\d+)\z')
			v = addr.to_i
			return true if v > 0 and v < VALID_DHCP_ADDRESS_RANGE
		end
		false
	end

	def valid_mac?(mac)
		m = [MAC_P, MAC_P, MAC_P, MAC_P, MAC_P, MAC_P].join ':'
		valid_mac = Regexp.new m
		return false unless (mac =~ valid_mac)
		true
	end

end
