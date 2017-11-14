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

class AliasesController < ApplicationController

	before_filter :admin_required

	VALID_NAME = Regexp.new "\A[A-Za-z0-9\-]+\z"
	VALID_ADDRESS = Regexp.new '\A(|\d(\d?\d?)|\d(\d?\d?)\.\d(\d?\d?)\.\d(\d?\d?)\.\d(\d?\d?))\z'

	def initialize
	      @page_title = 'DNS Aliases'
	end

	# GET /aliases
	# GET /aliases.xml
	def index
	  @aliases = DnsAlias.find(:all)

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
   if aliases.size > 0 
t 'dns_alias' 
t 'ip_address' 
 
	name = [h(one.alias), @domain].join '.'
	name = h($1) if one.alias =~ /(.*)\.\z/
	(base, addr) = case one.address
			when ''
				[@net, @self]
			when /\A\d+\z/
				[@net, [@net, h(one.address)].join('.')]
			else
				['', h(one.address)]
		end
	delete_icon = theme_image_tag("delete", :title => t('delete_alias'))
	uid = one.id.to_s
	toggler = update_page do |page|
			row = "alias_row_" + uid
			info = "alias_info_" + uid
			page.toggle info
			page[row].toggle_class_name "settings-row-open"
		  end

 uid 
 h toggler 
 link_to(h(name), '') 
 uid 
 h(addr) 
 uid 
t 'edit_alias' 
 h(one.alias) 
 spinner uid 
t 'delete_alias' 
 h one.alias 
 link_to_remote(delete_icon,
					:update => 'aliases-table',
					:confirm => t('are_you_sure_you_want_to_delete_alias', :name => name),
					:before => "Element.show('spinner-#{uid}')",
					:success => "Element.hide('spinner-#{uid}')",
					:url => { :controller => 'aliases', :action => 'delete', :id => uid }) 
t 'ip_address' 
 base.blank? ? '' : base + '.' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.address),
						  :options => {
						    :id => "alias_address_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'aliases',
						  :action => 'update_address',
						  :id => uid
						}) 
t 'location' 
 link_to h(name), "http://#{h(name)}", { :target => "_blank" } 
 
 else 
t 'there_are_no_aliases_defined' 
 end 
 
  button_to " #{t('new_alias')} &raquo; ", update_page { |page|
   	page.hide 'new-alias-to-step1'
   	page[:alias_alias].value = ""
   	page[:alias_address].value = ""
	page[:alias_address].disabled = true
	page[:alias_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-alias-step1'
   	page[:alias_alias].focus
   }, :id => "new-alias-to-step1" 
 error_messages_for :alias 
 t 'new_dns_alias' 
 form_for(newalias) do |f| 
 f.error_messages 
 f.label :alias 
 f.text_field :alias, :size => 18, :maxlength => 32 
t 'the_alias_name_you_input_will_be_added' 
t 'ip_address' 
 f.text_field :address, :size => 18, :maxlength => 32 
t 'the_ip_address_can_be' 
t 'a_single_number_0_254_to_point_to_a_given_machine' 
t 'an_external_ip_address_to_make_the_alias' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-alias-step1'
					page.show 'new-alias-to-step1'
					page[:alias_alias].value = ""
					page[:alias_address].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:alias_address].disabled = true
					page[:alias_create_button].disabled = true
				 } 
 submit_to_remote "create_alias", " #{t('create_alias')} &raquo; ",
					:url =>  { :controller => 'aliases', :action => 'create' },
					:html =>  { :id => "alias_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "aliases", :failure => "create_aliases_error_msgs" } 
 end 
 observe_field 'alias_alias', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_alias_check' },
			:with => "'alias=' + encodeURIComponent(value)" 
 observe_field 'alias_address', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 
 
 
 else
 
   if aliases.size > 0 
t 'dns_alias' 
t 'ip_address' 
 
	name = [h(one.alias), @domain].join '.'
	name = h($1) if one.alias =~ /(.*)\.\z/
	(base, addr) = case one.address
			when ''
				[@net, @self]
			when /\A\d+\z/
				[@net, [@net, h(one.address)].join('.')]
			else
				['', h(one.address)]
		end
	delete_icon = theme_image_tag("delete", :title => t('delete_alias'))
	uid = one.id.to_s
	toggler = update_page do |page|
			row = "alias_row_" + uid
			info = "alias_info_" + uid
			page.toggle info
			page[row].toggle_class_name "settings-row-open"
		  end

 uid 
 h toggler 
 link_to(h(name), '') 
 uid 
 h(addr) 
 uid 
t 'edit_alias' 
 h(one.alias) 
 spinner uid 
t 'delete_alias' 
 h one.alias 
 link_to_remote(delete_icon,
					:update => 'aliases-table',
					:confirm => t('are_you_sure_you_want_to_delete_alias', :name => name),
					:before => "Element.show('spinner-#{uid}')",
					:success => "Element.hide('spinner-#{uid}')",
					:url => { :controller => 'aliases', :action => 'delete', :id => uid }) 
t 'ip_address' 
 base.blank? ? '' : base + '.' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.address),
						  :options => {
						    :id => "alias_address_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'aliases',
						  :action => 'update_address',
						  :id => uid
						}) 
t 'location' 
 link_to h(name), "http://#{h(name)}", { :target => "_blank" } 
 
 else 
t 'there_are_no_aliases_defined' 
 end 
 
  button_to " #{t('new_alias')} &raquo; ", update_page { |page|
   	page.hide 'new-alias-to-step1'
   	page[:alias_alias].value = ""
   	page[:alias_address].value = ""
	page[:alias_address].disabled = true
	page[:alias_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-alias-step1'
   	page[:alias_alias].focus
   }, :id => "new-alias-to-step1" 
 error_messages_for :alias 
 t 'new_dns_alias' 
 form_for(newalias) do |f| 
 f.error_messages 
 f.label :alias 
 f.text_field :alias, :size => 18, :maxlength => 32 
t 'the_alias_name_you_input_will_be_added' 
t 'ip_address' 
 f.text_field :address, :size => 18, :maxlength => 32 
t 'the_ip_address_can_be' 
t 'a_single_number_0_254_to_point_to_a_given_machine' 
t 'an_external_ip_address_to_make_the_alias' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-alias-step1'
					page.show 'new-alias-to-step1'
					page[:alias_alias].value = ""
					page[:alias_address].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:alias_address].disabled = true
					page[:alias_create_button].disabled = true
				 } 
 submit_to_remote "create_alias", " #{t('create_alias')} &raquo; ",
					:url =>  { :controller => 'aliases', :action => 'create' },
					:html =>  { :id => "alias_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "aliases", :failure => "create_aliases_error_msgs" } 
 end 
 observe_field 'alias_alias', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_alias_check' },
			:with => "'alias=' + encodeURIComponent(value)" 
 observe_field 'alias_address', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 
 
 
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
   if aliases.size > 0 
t 'dns_alias' 
t 'ip_address' 
 
	name = [h(one.alias), @domain].join '.'
	name = h($1) if one.alias =~ /(.*)\.\z/
	(base, addr) = case one.address
			when ''
				[@net, @self]
			when /\A\d+\z/
				[@net, [@net, h(one.address)].join('.')]
			else
				['', h(one.address)]
		end
	delete_icon = theme_image_tag("delete", :title => t('delete_alias'))
	uid = one.id.to_s
	toggler = update_page do |page|
			row = "alias_row_" + uid
			info = "alias_info_" + uid
			page.toggle info
			page[row].toggle_class_name "settings-row-open"
		  end

 uid 
 h toggler 
 link_to(h(name), '') 
 uid 
 h(addr) 
 uid 
t 'edit_alias' 
 h(one.alias) 
 spinner uid 
t 'delete_alias' 
 h one.alias 
 link_to_remote(delete_icon,
					:update => 'aliases-table',
					:confirm => t('are_you_sure_you_want_to_delete_alias', :name => name),
					:before => "Element.show('spinner-#{uid}')",
					:success => "Element.hide('spinner-#{uid}')",
					:url => { :controller => 'aliases', :action => 'delete', :id => uid }) 
t 'ip_address' 
 base.blank? ? '' : base + '.' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.address),
						  :options => {
						    :id => "alias_address_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'aliases',
						  :action => 'update_address',
						  :id => uid
						}) 
t 'location' 
 link_to h(name), "http://#{h(name)}", { :target => "_blank" } 
 
 else 
t 'there_are_no_aliases_defined' 
 end 
 
  button_to " #{t('new_alias')} &raquo; ", update_page { |page|
   	page.hide 'new-alias-to-step1'
   	page[:alias_alias].value = ""
   	page[:alias_address].value = ""
	page[:alias_address].disabled = true
	page[:alias_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-alias-step1'
   	page[:alias_alias].focus
   }, :id => "new-alias-to-step1" 
 error_messages_for :alias 
 t 'new_dns_alias' 
 form_for(newalias) do |f| 
 f.error_messages 
 f.label :alias 
 f.text_field :alias, :size => 18, :maxlength => 32 
t 'the_alias_name_you_input_will_be_added' 
t 'ip_address' 
 f.text_field :address, :size => 18, :maxlength => 32 
t 'the_ip_address_can_be' 
t 'a_single_number_0_254_to_point_to_a_given_machine' 
t 'an_external_ip_address_to_make_the_alias' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-alias-step1'
					page.show 'new-alias-to-step1'
					page[:alias_alias].value = ""
					page[:alias_address].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:alias_address].disabled = true
					page[:alias_create_button].disabled = true
				 } 
 submit_to_remote "create_alias", " #{t('create_alias')} &raquo; ",
					:url =>  { :controller => 'aliases', :action => 'create' },
					:html =>  { :id => "alias_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "aliases", :failure => "create_aliases_error_msgs" } 
 end 
 observe_field 'alias_alias', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_alias_check' },
			:with => "'alias=' + encodeURIComponent(value)" 
 observe_field 'alias_address', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 
 
 
 else
 
   if aliases.size > 0 
t 'dns_alias' 
t 'ip_address' 
 
	name = [h(one.alias), @domain].join '.'
	name = h($1) if one.alias =~ /(.*)\.\z/
	(base, addr) = case one.address
			when ''
				[@net, @self]
			when /\A\d+\z/
				[@net, [@net, h(one.address)].join('.')]
			else
				['', h(one.address)]
		end
	delete_icon = theme_image_tag("delete", :title => t('delete_alias'))
	uid = one.id.to_s
	toggler = update_page do |page|
			row = "alias_row_" + uid
			info = "alias_info_" + uid
			page.toggle info
			page[row].toggle_class_name "settings-row-open"
		  end

 uid 
 h toggler 
 link_to(h(name), '') 
 uid 
 h(addr) 
 uid 
t 'edit_alias' 
 h(one.alias) 
 spinner uid 
t 'delete_alias' 
 h one.alias 
 link_to_remote(delete_icon,
					:update => 'aliases-table',
					:confirm => t('are_you_sure_you_want_to_delete_alias', :name => name),
					:before => "Element.show('spinner-#{uid}')",
					:success => "Element.hide('spinner-#{uid}')",
					:url => { :controller => 'aliases', :action => 'delete', :id => uid }) 
t 'ip_address' 
 base.blank? ? '' : base + '.' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.address),
						  :options => {
						    :id => "alias_address_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'aliases',
						  :action => 'update_address',
						  :id => uid
						}) 
t 'location' 
 link_to h(name), "http://#{h(name)}", { :target => "_blank" } 
 
 else 
t 'there_are_no_aliases_defined' 
 end 
 
  button_to " #{t('new_alias')} &raquo; ", update_page { |page|
   	page.hide 'new-alias-to-step1'
   	page[:alias_alias].value = ""
   	page[:alias_address].value = ""
	page[:alias_address].disabled = true
	page[:alias_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-alias-step1'
   	page[:alias_alias].focus
   }, :id => "new-alias-to-step1" 
 error_messages_for :alias 
 t 'new_dns_alias' 
 form_for(newalias) do |f| 
 f.error_messages 
 f.label :alias 
 f.text_field :alias, :size => 18, :maxlength => 32 
t 'the_alias_name_you_input_will_be_added' 
t 'ip_address' 
 f.text_field :address, :size => 18, :maxlength => 32 
t 'the_ip_address_can_be' 
t 'a_single_number_0_254_to_point_to_a_given_machine' 
t 'an_external_ip_address_to_make_the_alias' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-alias-step1'
					page.show 'new-alias-to-step1'
					page[:alias_alias].value = ""
					page[:alias_address].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:alias_address].disabled = true
					page[:alias_create_button].disabled = true
				 } 
 submit_to_remote "create_alias", " #{t('create_alias')} &raquo; ",
					:url =>  { :controller => 'aliases', :action => 'create' },
					:html =>  { :id => "alias_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "aliases", :failure => "create_aliases_error_msgs" } 
 end 
 observe_field 'alias_alias', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_alias_check' },
			:with => "'alias=' + encodeURIComponent(value)" 
 observe_field 'alias_address', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 
 
 
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

	# GET /aliases/1
	# GET /aliases/1.xml
	def show
	  @alias = DnsAlias.find(params[:id])

	  respond_to do |format|
	    format.html # show.html.erb
	    format.xml  { render :xml => @alias }
	  end
	end

	# GET /aliases/new
	# GET /aliases/new.xml
	def new
	  @alias = DnsAlias.new

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
  button_to " #{t('new_alias')} &raquo; ", update_page { |page|
   	page.hide 'new-alias-to-step1'
   	page[:alias_alias].value = ""
   	page[:alias_address].value = ""
	page[:alias_address].disabled = true
	page[:alias_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-alias-step1'
   	page[:alias_alias].focus
   }, :id => "new-alias-to-step1" 
 error_messages_for :alias 
 t 'new_dns_alias' 
 form_for(newalias) do |f| 
 f.error_messages 
 f.label :alias 
 f.text_field :alias, :size => 18, :maxlength => 32 
t 'the_alias_name_you_input_will_be_added' 
t 'ip_address' 
 f.text_field :address, :size => 18, :maxlength => 32 
t 'the_ip_address_can_be' 
t 'a_single_number_0_254_to_point_to_a_given_machine' 
t 'an_external_ip_address_to_make_the_alias' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-alias-step1'
					page.show 'new-alias-to-step1'
					page[:alias_alias].value = ""
					page[:alias_address].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:alias_address].disabled = true
					page[:alias_create_button].disabled = true
				 } 
 submit_to_remote "create_alias", " #{t('create_alias')} &raquo; ",
					:url =>  { :controller => 'aliases', :action => 'create' },
					:html =>  { :id => "alias_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "aliases", :failure => "create_aliases_error_msgs" } 
 end 
 observe_field 'alias_alias', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_alias_check' },
			:with => "'alias=' + encodeURIComponent(value)" 
 observe_field 'alias_address', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 
 
 else
 
  button_to " #{t('new_alias')} &raquo; ", update_page { |page|
   	page.hide 'new-alias-to-step1'
   	page[:alias_alias].value = ""
   	page[:alias_address].value = ""
	page[:alias_address].disabled = true
	page[:alias_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-alias-step1'
   	page[:alias_alias].focus
   }, :id => "new-alias-to-step1" 
 error_messages_for :alias 
 t 'new_dns_alias' 
 form_for(newalias) do |f| 
 f.error_messages 
 f.label :alias 
 f.text_field :alias, :size => 18, :maxlength => 32 
t 'the_alias_name_you_input_will_be_added' 
t 'ip_address' 
 f.text_field :address, :size => 18, :maxlength => 32 
t 'the_ip_address_can_be' 
t 'a_single_number_0_254_to_point_to_a_given_machine' 
t 'an_external_ip_address_to_make_the_alias' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-alias-step1'
					page.show 'new-alias-to-step1'
					page[:alias_alias].value = ""
					page[:alias_address].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:alias_address].disabled = true
					page[:alias_create_button].disabled = true
				 } 
 submit_to_remote "create_alias", " #{t('create_alias')} &raquo; ",
					:url =>  { :controller => 'aliases', :action => 'create' },
					:html =>  { :id => "alias_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "aliases", :failure => "create_aliases_error_msgs" } 
 end 
 observe_field 'alias_alias', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_alias_check' },
			:with => "'alias=' + encodeURIComponent(value)" 
 observe_field 'alias_address', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 
 
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
  button_to " #{t('new_alias')} &raquo; ", update_page { |page|
   	page.hide 'new-alias-to-step1'
   	page[:alias_alias].value = ""
   	page[:alias_address].value = ""
	page[:alias_address].disabled = true
	page[:alias_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-alias-step1'
   	page[:alias_alias].focus
   }, :id => "new-alias-to-step1" 
 error_messages_for :alias 
 t 'new_dns_alias' 
 form_for(newalias) do |f| 
 f.error_messages 
 f.label :alias 
 f.text_field :alias, :size => 18, :maxlength => 32 
t 'the_alias_name_you_input_will_be_added' 
t 'ip_address' 
 f.text_field :address, :size => 18, :maxlength => 32 
t 'the_ip_address_can_be' 
t 'a_single_number_0_254_to_point_to_a_given_machine' 
t 'an_external_ip_address_to_make_the_alias' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-alias-step1'
					page.show 'new-alias-to-step1'
					page[:alias_alias].value = ""
					page[:alias_address].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:alias_address].disabled = true
					page[:alias_create_button].disabled = true
				 } 
 submit_to_remote "create_alias", " #{t('create_alias')} &raquo; ",
					:url =>  { :controller => 'aliases', :action => 'create' },
					:html =>  { :id => "alias_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "aliases", :failure => "create_aliases_error_msgs" } 
 end 
 observe_field 'alias_alias', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_alias_check' },
			:with => "'alias=' + encodeURIComponent(value)" 
 observe_field 'alias_address', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 
 
 else
 
  button_to " #{t('new_alias')} &raquo; ", update_page { |page|
   	page.hide 'new-alias-to-step1'
   	page[:alias_alias].value = ""
   	page[:alias_address].value = ""
	page[:alias_address].disabled = true
	page[:alias_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-alias-step1'
   	page[:alias_alias].focus
   }, :id => "new-alias-to-step1" 
 error_messages_for :alias 
 t 'new_dns_alias' 
 form_for(newalias) do |f| 
 f.error_messages 
 f.label :alias 
 f.text_field :alias, :size => 18, :maxlength => 32 
t 'the_alias_name_you_input_will_be_added' 
t 'ip_address' 
 f.text_field :address, :size => 18, :maxlength => 32 
t 'the_ip_address_can_be' 
t 'a_single_number_0_254_to_point_to_a_given_machine' 
t 'an_external_ip_address_to_make_the_alias' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-alias-step1'
					page.show 'new-alias-to-step1'
					page[:alias_alias].value = ""
					page[:alias_address].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:alias_address].disabled = true
					page[:alias_create_button].disabled = true
				 } 
 submit_to_remote "create_alias", " #{t('create_alias')} &raquo; ",
					:url =>  { :controller => 'aliases', :action => 'create' },
					:html =>  { :id => "alias_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "aliases", :failure => "create_aliases_error_msgs" } 
 end 
 observe_field 'alias_alias', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_alias_check' },
			:with => "'alias=' + encodeURIComponent(value)" 
 observe_field 'alias_address', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 
 
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

	# GET /aliases/1/edit
	def edit
	  @alias = DnsAlias.find(params[:id])
	  @net = Setting.get 'net'
	end

	# POST /aliases
	# POST /aliases.xml - FIXME
	def create
	  @alias = DnsAlias.new(params[:alias])

	  respond_to do |format|
	    if @alias.save
	      format.html do
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
   if aliases.size > 0 
t 'dns_alias' 
t 'ip_address' 
 
	name = [h(one.alias), @domain].join '.'
	name = h($1) if one.alias =~ /(.*)\.\z/
	(base, addr) = case one.address
			when ''
				[@net, @self]
			when /\A\d+\z/
				[@net, [@net, h(one.address)].join('.')]
			else
				['', h(one.address)]
		end
	delete_icon = theme_image_tag("delete", :title => t('delete_alias'))
	uid = one.id.to_s
	toggler = update_page do |page|
			row = "alias_row_" + uid
			info = "alias_info_" + uid
			page.toggle info
			page[row].toggle_class_name "settings-row-open"
		  end

 uid 
 h toggler 
 link_to(h(name), '') 
 uid 
 h(addr) 
 uid 
t 'edit_alias' 
 h(one.alias) 
 spinner uid 
t 'delete_alias' 
 h one.alias 
 link_to_remote(delete_icon,
					:update => 'aliases-table',
					:confirm => t('are_you_sure_you_want_to_delete_alias', :name => name),
					:before => "Element.show('spinner-#{uid}')",
					:success => "Element.hide('spinner-#{uid}')",
					:url => { :controller => 'aliases', :action => 'delete', :id => uid }) 
t 'ip_address' 
 base.blank? ? '' : base + '.' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.address),
						  :options => {
						    :id => "alias_address_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'aliases',
						  :action => 'update_address',
						  :id => uid
						}) 
t 'location' 
 link_to h(name), "http://#{h(name)}", { :target => "_blank" } 
 
 else 
t 'there_are_no_aliases_defined' 
 end 
 
  button_to " #{t('new_alias')} &raquo; ", update_page { |page|
   	page.hide 'new-alias-to-step1'
   	page[:alias_alias].value = ""
   	page[:alias_address].value = ""
	page[:alias_address].disabled = true
	page[:alias_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-alias-step1'
   	page[:alias_alias].focus
   }, :id => "new-alias-to-step1" 
 error_messages_for :alias 
 t 'new_dns_alias' 
 form_for(newalias) do |f| 
 f.error_messages 
 f.label :alias 
 f.text_field :alias, :size => 18, :maxlength => 32 
t 'the_alias_name_you_input_will_be_added' 
t 'ip_address' 
 f.text_field :address, :size => 18, :maxlength => 32 
t 'the_ip_address_can_be' 
t 'a_single_number_0_254_to_point_to_a_given_machine' 
t 'an_external_ip_address_to_make_the_alias' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-alias-step1'
					page.show 'new-alias-to-step1'
					page[:alias_alias].value = ""
					page[:alias_address].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:alias_address].disabled = true
					page[:alias_create_button].disabled = true
				 } 
 submit_to_remote "create_alias", " #{t('create_alias')} &raquo; ",
					:url =>  { :controller => 'aliases', :action => 'create' },
					:html =>  { :id => "alias_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "aliases", :failure => "create_aliases_error_msgs" } 
 end 
 observe_field 'alias_alias', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_alias_check' },
			:with => "'alias=' + encodeURIComponent(value)" 
 observe_field 'alias_address', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 
 
 
 else
 
   if aliases.size > 0 
t 'dns_alias' 
t 'ip_address' 
 
	name = [h(one.alias), @domain].join '.'
	name = h($1) if one.alias =~ /(.*)\.\z/
	(base, addr) = case one.address
			when ''
				[@net, @self]
			when /\A\d+\z/
				[@net, [@net, h(one.address)].join('.')]
			else
				['', h(one.address)]
		end
	delete_icon = theme_image_tag("delete", :title => t('delete_alias'))
	uid = one.id.to_s
	toggler = update_page do |page|
			row = "alias_row_" + uid
			info = "alias_info_" + uid
			page.toggle info
			page[row].toggle_class_name "settings-row-open"
		  end

 uid 
 h toggler 
 link_to(h(name), '') 
 uid 
 h(addr) 
 uid 
t 'edit_alias' 
 h(one.alias) 
 spinner uid 
t 'delete_alias' 
 h one.alias 
 link_to_remote(delete_icon,
					:update => 'aliases-table',
					:confirm => t('are_you_sure_you_want_to_delete_alias', :name => name),
					:before => "Element.show('spinner-#{uid}')",
					:success => "Element.hide('spinner-#{uid}')",
					:url => { :controller => 'aliases', :action => 'delete', :id => uid }) 
t 'ip_address' 
 base.blank? ? '' : base + '.' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.address),
						  :options => {
						    :id => "alias_address_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'aliases',
						  :action => 'update_address',
						  :id => uid
						}) 
t 'location' 
 link_to h(name), "http://#{h(name)}", { :target => "_blank" } 
 
 else 
t 'there_are_no_aliases_defined' 
 end 
 
  button_to " #{t('new_alias')} &raquo; ", update_page { |page|
   	page.hide 'new-alias-to-step1'
   	page[:alias_alias].value = ""
   	page[:alias_address].value = ""
	page[:alias_address].disabled = true
	page[:alias_create_button].disabled = true
	page.select(".messages").each do |item|
		page.send 'replace_html', item, ""
	end
   	page.show 'new-alias-step1'
   	page[:alias_alias].focus
   }, :id => "new-alias-to-step1" 
 error_messages_for :alias 
 t 'new_dns_alias' 
 form_for(newalias) do |f| 
 f.error_messages 
 f.label :alias 
 f.text_field :alias, :size => 18, :maxlength => 32 
t 'the_alias_name_you_input_will_be_added' 
t 'ip_address' 
 f.text_field :address, :size => 18, :maxlength => 32 
t 'the_ip_address_can_be' 
t 'a_single_number_0_254_to_point_to_a_given_machine' 
t 'an_external_ip_address_to_make_the_alias' 
 link_to t('cancel'), update_page { |page|
					page.hide 'new-alias-step1'
					page.show 'new-alias-to-step1'
					page[:alias_alias].value = ""
					page[:alias_address].value = ""
					page.select(".messages").each do |item|
						page.send 'replace_html', item, ""
					end
					page[:alias_address].disabled = true
					page[:alias_create_button].disabled = true
				 } 
 submit_to_remote "create_alias", " #{t('create_alias')} &raquo; ",
					:url =>  { :controller => 'aliases', :action => 'create' },
					:html =>  { :id => "alias_create_button", :disabled => true },
					:failure =>  "alert('HTTP Error ' + request.status + '!')",
					:update => { :success => "aliases", :failure => "create_aliases_error_msgs" } 
 end 
 observe_field 'alias_alias', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_alias_check' },
			:with => "'alias=' + encodeURIComponent(value)" 
 observe_field 'alias_address', :frequency => 0.5,
			:url => { :controller => 'aliases', :action => 'new_address_check' },
			:with => "'address=' + encodeURIComponent(value)" 
 
 
 
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
	      format.xml  { render :xml => @alias, :status => :created, :location => @alias }
	    else
	      format.html { raise "could not save #{params.inspect}" }
	      format.xml  { render :xml => @alias.errors, :status => :unprocessable_entity }
	    end
	  end
	end

	# PUT /aliases/1
	# PUT /aliases/1.xml
	def update
	  @alias = DnsAlias.find(params[:id])

	  respond_to do |format|
	    if @alias.update_attributes(params[:alias])
	      flash[:notice] = 'Alias was successfully updated.'
	      format.html { redirect_to(@alias) }
	      format.xml  { head :ok }
	    else
	      format.html { render :action => "edit" }
	      format.xml  { render :xml => @alias.errors, :status => :unprocessable_entity }
	    end
	  end
	end

	# DELETE /aliases/1
	# DELETE /aliases/1.xml
	def destroy
	  @alias = DnsAlias.find(params[:id])
	  @alias.destroy

	  respond_to do |format|
	    format.html { redirect_to(aliases_url) }
	    format.xml  { head :ok }
	  end
	end

	def update_address
		a = DnsAlias.find(params[:id])
		addr = params[:value].strip
		# FIXME - report errors to the user!
		unless valid_address?(addr)
			render :text => a.address
			return
		end
		if ((valid_short_address?(a.address) and not valid_short_address?(addr)) or
			(is_address_full?(a.address) and not is_address_full?(addr)))
			render :text => a.address
			return
		end
		a.address = addr
		a.save
		a.reload
		if a.address.blank?
			render :text => "(hda)"
			return
		end
		render :text => a.address
	end


	def delete
		a = DnsAlias.find params[:id]
		a.destroy
		aliases = DnsAlias.user_visible
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
  if aliases.size > 0 
t 'dns_alias' 
t 'ip_address' 
 
	name = [h(one.alias), @domain].join '.'
	name = h($1) if one.alias =~ /(.*)\.\z/
	(base, addr) = case one.address
			when ''
				[@net, @self]
			when /\A\d+\z/
				[@net, [@net, h(one.address)].join('.')]
			else
				['', h(one.address)]
		end
	delete_icon = theme_image_tag("delete", :title => t('delete_alias'))
	uid = one.id.to_s
	toggler = update_page do |page|
			row = "alias_row_" + uid
			info = "alias_info_" + uid
			page.toggle info
			page[row].toggle_class_name "settings-row-open"
		  end

 uid 
 h toggler 
 link_to(h(name), '') 
 uid 
 h(addr) 
 uid 
t 'edit_alias' 
 h(one.alias) 
 spinner uid 
t 'delete_alias' 
 h one.alias 
 link_to_remote(delete_icon,
					:update => 'aliases-table',
					:confirm => t('are_you_sure_you_want_to_delete_alias', :name => name),
					:before => "Element.show('spinner-#{uid}')",
					:success => "Element.hide('spinner-#{uid}')",
					:url => { :controller => 'aliases', :action => 'delete', :id => uid }) 
t 'ip_address' 
 base.blank? ? '' : base + '.' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.address),
						  :options => {
						    :id => "alias_address_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'aliases',
						  :action => 'update_address',
						  :id => uid
						}) 
t 'location' 
 link_to h(name), "http://#{h(name)}", { :target => "_blank" } 
 
 else 
t 'there_are_no_aliases_defined' 
 end 
 
 else
 
  if aliases.size > 0 
t 'dns_alias' 
t 'ip_address' 
 
	name = [h(one.alias), @domain].join '.'
	name = h($1) if one.alias =~ /(.*)\.\z/
	(base, addr) = case one.address
			when ''
				[@net, @self]
			when /\A\d+\z/
				[@net, [@net, h(one.address)].join('.')]
			else
				['', h(one.address)]
		end
	delete_icon = theme_image_tag("delete", :title => t('delete_alias'))
	uid = one.id.to_s
	toggler = update_page do |page|
			row = "alias_row_" + uid
			info = "alias_info_" + uid
			page.toggle info
			page[row].toggle_class_name "settings-row-open"
		  end

 uid 
 h toggler 
 link_to(h(name), '') 
 uid 
 h(addr) 
 uid 
t 'edit_alias' 
 h(one.alias) 
 spinner uid 
t 'delete_alias' 
 h one.alias 
 link_to_remote(delete_icon,
					:update => 'aliases-table',
					:confirm => t('are_you_sure_you_want_to_delete_alias', :name => name),
					:before => "Element.show('spinner-#{uid}')",
					:success => "Element.hide('spinner-#{uid}')",
					:url => { :controller => 'aliases', :action => 'delete', :id => uid }) 
t 'ip_address' 
 base.blank? ? '' : base + '.' 
 editable_content(
						:content => {
						  :element => 'span',
						  :text => h(one.address),
						  :options => {
						    :id => "alias_address_#{uid}",
						    :class => 'editable'
						  }
						 },
						:url => {
						  :controller => 'aliases',
						  :action => 'update_address',
						  :id => uid
						}) 
t 'location' 
 link_to h(name), "http://#{h(name)}", { :target => "_blank" } 
 
 else 
t 'there_are_no_aliases_defined' 
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


	def new_alias_check
		n = params[:alias]
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
 page[:alias_messages].replace_html theme_image_tag("stop") + " " + t('alias_is_not_valid')
page.show 'alias_messages'
page[:alias_address].disabled = true
page[:alias_create_button].disabled = true
 
 else
 
 page[:alias_messages].replace_html theme_image_tag("stop") + " " + t('alias_is_not_valid')
page.show 'alias_messages'
page[:alias_address].disabled = true
page[:alias_create_button].disabled = true
 
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
 page[:alias_messages].replace_html theme_image_tag("stop") + " " + t('alias_is_not_valid')
page.show 'alias_messages'
page[:alias_address].disabled = true
page[:alias_create_button].disabled = true
 
 else
 
 page[:alias_messages].replace_html theme_image_tag("stop") + " " + t('alias_is_not_valid')
page.show 'alias_messages'
page[:alias_address].disabled = true
page[:alias_create_button].disabled = true
 
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
		a = DnsAlias.where(:alias=>n).first
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
 page[:alias_messages].replace_html theme_image_tag("ok") + " " + t('alias_looks_good')
page.show 'alias_messages'
page[:alias_address].disabled = false
 
 else
 
 page[:alias_messages].replace_html theme_image_tag("ok") + " " + t('alias_looks_good')
page.show 'alias_messages'
page[:alias_address].disabled = false
 
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
 page[:alias_messages].replace_html theme_image_tag("stop") + " " + t('alias_is_taken_already')
page.show 'alias_messages'
page[:alias_address].disabled = true
page[:alias_create_button].disabled = true
 
 else
 
 page[:alias_messages].replace_html theme_image_tag("stop") + " " + t('alias_is_taken_already')
page.show 'alias_messages'
page[:alias_address].disabled = true
page[:alias_create_button].disabled = true
 
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
		if (not (valid_address?(n))) or (n.size > 28)
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
page[:alias_create_button].disabled = true
 
 else
 
 page[:address_messages].replace_html theme_image_tag("stop") + " " + t('address_is_not_valid')
page.show 'address_messages'
page[:alias_create_button].disabled = true
 
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
page[:alias_create_button].disabled = false
 
 else
 
 page[:address_messages].replace_html theme_image_tag("ok") + " " + t('address_looks_good')
page.show 'address_messages'
page[:alias_create_button].disabled = false
 
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

	# FIXME-cpg: some of this should probably be in the model for aliases

	def valid_name?(nm)
		return false unless (nm =~ VALID_NAME)
		true
	end

	def valid_address?(addr)
		return false if addr.nil?
		# NOTE: do not allow aliases to the hda as a blank address
		return false if addr.blank?
		return false unless (addr =~ VALID_ADDRESS)
		if addr =~ Regexp.new('\A(\d+)\.(\d+)\.(\d+)\.(\d+)\z')
			[$1, $2, $3, $4].each { |ip| return false if ip.to_i > 254 }
			return true
		end
		valid_short_address?(addr)
	end

	def is_address_full?(addr)
		(addr =~ Regexp.new('\A(\d+)\.(\d+)\.(\d+)\.(\d+)\z')) ? true : false
	end

	def valid_short_address?(addr)
		if addr =~ Regexp.new('\A(\d+)\z')
			v = addr.to_i
			return true unless v < 0 or v > 254
		end
		false
	end
end
