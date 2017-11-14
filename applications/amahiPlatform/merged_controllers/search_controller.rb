# encoding: UTF-8
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

require 'digest/sha1'

class SearchController < ApplicationController

	before_filter :login_required
	layout 'basic'

	RESULTS_PER_PAGE = 20

	SEARCH_CACHE = File.join(Rails.root, 'tmp/cache/search')

	EXT_AUDIO = ['aac', 'aif', 'iff', 'm3u', 'm4a', 'mid', 'midi', 'mp3', 'mpa', 'ra', 'ram', 'wav', 'wma']
	EXT_IMAGES = ['mng', 'pct', 'bmp', 'gif', 'jpeg', 'jpg', 'png', 'psd', 'psp', 'thm', 'tif', 'ai', 'drw', 'dxf', 'eps', 'ps', 'svg', '3dm', '3dmf']
	EXT_VIDEO = ['3g2', '3gp', 'asf', 'asx', 'avi', 'flv', 'mkv', 'mov', 'mp4', 'mpg', 'mpeg', 'qt', 'rm', 'swf', 'vob', 'wmv']

	def hda
		@page_title = 'Search Results'
		@search_value = 'HDA'

		if params[:button] && params[:button] == "Web"
			require 'uri'
			redirect_to URI.escape("http://www.google.com/search?q=#{params[:query]}")
		else
			@query = params[:query]
			@page = (params[:page] && params[:page].to_i.abs) || 1
			@rpp = (params[:per_page] && params[:per_page].to_i.abs) || RESULTS_PER_PAGE
			unless use_sample_data?
				@results = hda_search(@query, nil, @page, @rpp)
			else
				# NOTE: this is some sample fake data for development
				@results = SampleData.load('search')
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
  _temple_html_attributeremover1 = (::Temple::Utils.escape_html((active 'hda'))).to_s 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 ::Temple::Utils.escape_html((action_name == "hda" ? t('files') : link_to(t('files'), :action => :hda, :query => @query, per_page: @rpp))) 
 _temple_html_attributeremover2 = (::Temple::Utils.escape_html((active 'images'))).to_s 
 if !_temple_html_attributeremover2.empty? 
 _temple_html_attributeremover2 
 end 
 ::Temple::Utils.escape_html((action_name == "images" ? t('images') : link_to(t('images'), :action => :images, :query => @query, per_page: @rpp))) 
 _temple_html_attributeremover3 = (::Temple::Utils.escape_html((active 'audio'))).to_s 
 if !_temple_html_attributeremover3.empty? 
 _temple_html_attributeremover3 
 end 
 ::Temple::Utils.escape_html((action_name == "audio" ? t('audio') : link_to(t('audio'), :action => :audio, :query => @query, per_page: @rpp))) 
 _temple_html_attributeremover4 = (::Temple::Utils.escape_html((active 'video'))).to_s 
 if !_temple_html_attributeremover4.empty? 
 _temple_html_attributeremover4 
 end 
 ::Temple::Utils.escape_html((action_name == "video" ? t('video') : link_to(t('video'), :action => :video, :query => @query, per_page: @rpp))) 
 ::Temple::Utils.escape_html((t('results_displayed', :count => @results.size))) 
 ::Temple::Utils.escape_html((link_to 50, query: @query, per_page: 50)) 
 ::Temple::Utils.escape_html((link_to 100, query: @query, per_page: 100)) 
 if @results.size > 0
 
 ::Temple::Utils.escape_html(( _temple_html_attributeremover1 = (::Temple::Utils.escape_html((cycle('odd', 'even')))).to_s 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 ::Temple::Utils.escape_html((file_type_to_icon(result[:type], result[:path]))) 
 ::Temple::Utils.escape_html((link_to h(result[:title]), path2uri(result[:path]))) 
 ::Temple::Utils.escape_html((path2location(result[:path]))) 
 ::Temple::Utils.escape_html((number_to_human_size(result[:size]))) 
 ::Temple::Utils.escape_html((h(result[:owner]))) 
 ::Temple::Utils.escape_html((link_to theme_image_tag("icons/open-folder.png"), path2uri(File.dirname result[:path]), :title => t('open'), :class => 'file-icon')) 
)) 
 else
 
 ::Temple::Utils.escape_html((t 'no_documents_found')) 
 end 
 if @page != 1
 
 ::Temple::Utils.escape_html((link_to t('previous'), query: @query, page: @page-1, per_page: @rpp)) 
 end; if @page > 5
 
 ::Temple::Utils.escape_html((link_to "1", query: @query, page: 1, per_page: @rpp)) 
 ::Temple::Utils.escape_html((link_to "2", query: @query, page: 2, per_page: @rpp)) 
 end; (1..4).each do |p|
page = @page-(5-p)
unless page < 1
 
 ::Temple::Utils.escape_html((link_to page, query: @query, page: page, per_page: @rpp)) 
 end; end 
 ::Temple::Utils.escape_html((@page)) 
 unless @results.size < @rpp
 
 (1..6).each do |p|
 
 ::Temple::Utils.escape_html((link_to @page+p, query: @query, rel: "next", page: @page+p, per_page: @rpp)) 
 end 
 ::Temple::Utils.escape_html((link_to t('next'), query: @query, page: @page+1, per_page: @rpp)) 
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

	def images
		@query = params[:query]
		@page = (params[:page] && params[:page].to_i.abs) || 1
		@rpp = (params[:per_page] && params[:per_page].to_i.abs) || RESULTS_PER_PAGE
		@results = hda_search(@query, EXT_IMAGES, @page, @rpp)
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
  _temple_html_attributeremover1 = (::Temple::Utils.escape_html((active 'hda'))).to_s 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 ::Temple::Utils.escape_html((action_name == "hda" ? t('files') : link_to(t('files'), :action => :hda, :query => @query, per_page: @rpp))) 
 _temple_html_attributeremover2 = (::Temple::Utils.escape_html((active 'images'))).to_s 
 if !_temple_html_attributeremover2.empty? 
 _temple_html_attributeremover2 
 end 
 ::Temple::Utils.escape_html((action_name == "images" ? t('images') : link_to(t('images'), :action => :images, :query => @query, per_page: @rpp))) 
 _temple_html_attributeremover3 = (::Temple::Utils.escape_html((active 'audio'))).to_s 
 if !_temple_html_attributeremover3.empty? 
 _temple_html_attributeremover3 
 end 
 ::Temple::Utils.escape_html((action_name == "audio" ? t('audio') : link_to(t('audio'), :action => :audio, :query => @query, per_page: @rpp))) 
 _temple_html_attributeremover4 = (::Temple::Utils.escape_html((active 'video'))).to_s 
 if !_temple_html_attributeremover4.empty? 
 _temple_html_attributeremover4 
 end 
 ::Temple::Utils.escape_html((action_name == "video" ? t('video') : link_to(t('video'), :action => :video, :query => @query, per_page: @rpp))) 
 ::Temple::Utils.escape_html((t('results_displayed', :count => @results.size))) 
 ::Temple::Utils.escape_html((link_to 50, query: @query, per_page: 50)) 
 ::Temple::Utils.escape_html((link_to 100, query: @query, per_page: 100)) 
 if @results.size > 0
 
 ::Temple::Utils.escape_html(( _temple_html_attributeremover1 = (::Temple::Utils.escape_html((cycle('odd', 'even')))).to_s 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 ::Temple::Utils.escape_html((file_type_to_icon(result[:type], result[:path]))) 
 ::Temple::Utils.escape_html((link_to h(result[:title]), path2uri(result[:path]))) 
 ::Temple::Utils.escape_html((path2location(result[:path]))) 
 ::Temple::Utils.escape_html((number_to_human_size(result[:size]))) 
 ::Temple::Utils.escape_html((h(result[:owner]))) 
 ::Temple::Utils.escape_html((link_to theme_image_tag("icons/open-folder.png"), path2uri(File.dirname result[:path]), :title => t('open'), :class => 'file-icon')) 
)) 
 else
 
 ::Temple::Utils.escape_html((t 'no_documents_found')) 
 end 
 if @page != 1
 
 ::Temple::Utils.escape_html((link_to t('previous'), query: @query, page: @page-1, per_page: @rpp)) 
 end; if @page > 5
 
 ::Temple::Utils.escape_html((link_to "1", query: @query, page: 1, per_page: @rpp)) 
 ::Temple::Utils.escape_html((link_to "2", query: @query, page: 2, per_page: @rpp)) 
 end; (1..4).each do |p|
page = @page-(5-p)
unless page < 1
 
 ::Temple::Utils.escape_html((link_to page, query: @query, page: page, per_page: @rpp)) 
 end; end 
 ::Temple::Utils.escape_html((@page)) 
 unless @results.size < @rpp
 
 (1..6).each do |p|
 
 ::Temple::Utils.escape_html((link_to @page+p, query: @query, rel: "next", page: @page+p, per_page: @rpp)) 
 end 
 ::Temple::Utils.escape_html((link_to t('next'), query: @query, page: @page+1, per_page: @rpp)) 
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

	def audio
		@query = params[:query]
		@page = (params[:page] && params[:page].to_i.abs) || 1
		@rpp = (params[:per_page] && params[:per_page].to_i.abs) || RESULTS_PER_PAGE
		@results = hda_search(@query, EXT_AUDIO, @page, @rpp)
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
  _temple_html_attributeremover1 = (::Temple::Utils.escape_html((active 'hda'))).to_s 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 ::Temple::Utils.escape_html((action_name == "hda" ? t('files') : link_to(t('files'), :action => :hda, :query => @query, per_page: @rpp))) 
 _temple_html_attributeremover2 = (::Temple::Utils.escape_html((active 'images'))).to_s 
 if !_temple_html_attributeremover2.empty? 
 _temple_html_attributeremover2 
 end 
 ::Temple::Utils.escape_html((action_name == "images" ? t('images') : link_to(t('images'), :action => :images, :query => @query, per_page: @rpp))) 
 _temple_html_attributeremover3 = (::Temple::Utils.escape_html((active 'audio'))).to_s 
 if !_temple_html_attributeremover3.empty? 
 _temple_html_attributeremover3 
 end 
 ::Temple::Utils.escape_html((action_name == "audio" ? t('audio') : link_to(t('audio'), :action => :audio, :query => @query, per_page: @rpp))) 
 _temple_html_attributeremover4 = (::Temple::Utils.escape_html((active 'video'))).to_s 
 if !_temple_html_attributeremover4.empty? 
 _temple_html_attributeremover4 
 end 
 ::Temple::Utils.escape_html((action_name == "video" ? t('video') : link_to(t('video'), :action => :video, :query => @query, per_page: @rpp))) 
 ::Temple::Utils.escape_html((t('results_displayed', :count => @results.size))) 
 ::Temple::Utils.escape_html((link_to 50, query: @query, per_page: 50)) 
 ::Temple::Utils.escape_html((link_to 100, query: @query, per_page: 100)) 
 if @results.size > 0
 
 ::Temple::Utils.escape_html(( _temple_html_attributeremover1 = (::Temple::Utils.escape_html((cycle('odd', 'even')))).to_s 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 ::Temple::Utils.escape_html((file_type_to_icon(result[:type], result[:path]))) 
 ::Temple::Utils.escape_html((link_to h(result[:title]), path2uri(result[:path]))) 
 ::Temple::Utils.escape_html((path2location(result[:path]))) 
 ::Temple::Utils.escape_html((number_to_human_size(result[:size]))) 
 ::Temple::Utils.escape_html((h(result[:owner]))) 
 ::Temple::Utils.escape_html((link_to theme_image_tag("icons/open-folder.png"), path2uri(File.dirname result[:path]), :title => t('open'), :class => 'file-icon')) 
)) 
 else
 
 ::Temple::Utils.escape_html((t 'no_documents_found')) 
 end 
 if @page != 1
 
 ::Temple::Utils.escape_html((link_to t('previous'), query: @query, page: @page-1, per_page: @rpp)) 
 end; if @page > 5
 
 ::Temple::Utils.escape_html((link_to "1", query: @query, page: 1, per_page: @rpp)) 
 ::Temple::Utils.escape_html((link_to "2", query: @query, page: 2, per_page: @rpp)) 
 end; (1..4).each do |p|
page = @page-(5-p)
unless page < 1
 
 ::Temple::Utils.escape_html((link_to page, query: @query, page: page, per_page: @rpp)) 
 end; end 
 ::Temple::Utils.escape_html((@page)) 
 unless @results.size < @rpp
 
 (1..6).each do |p|
 
 ::Temple::Utils.escape_html((link_to @page+p, query: @query, rel: "next", page: @page+p, per_page: @rpp)) 
 end 
 ::Temple::Utils.escape_html((link_to t('next'), query: @query, page: @page+1, per_page: @rpp)) 
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

	def video
		@query = params[:query]
		@page = (params[:page] && params[:page].to_i.abs) || 1
		@rpp = (params[:per_page] && params[:per_page].to_i.abs) || RESULTS_PER_PAGE
		@results = hda_search(@query, EXT_VIDEO, @page, @rpp)
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
  _temple_html_attributeremover1 = (::Temple::Utils.escape_html((active 'hda'))).to_s 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 ::Temple::Utils.escape_html((action_name == "hda" ? t('files') : link_to(t('files'), :action => :hda, :query => @query, per_page: @rpp))) 
 _temple_html_attributeremover2 = (::Temple::Utils.escape_html((active 'images'))).to_s 
 if !_temple_html_attributeremover2.empty? 
 _temple_html_attributeremover2 
 end 
 ::Temple::Utils.escape_html((action_name == "images" ? t('images') : link_to(t('images'), :action => :images, :query => @query, per_page: @rpp))) 
 _temple_html_attributeremover3 = (::Temple::Utils.escape_html((active 'audio'))).to_s 
 if !_temple_html_attributeremover3.empty? 
 _temple_html_attributeremover3 
 end 
 ::Temple::Utils.escape_html((action_name == "audio" ? t('audio') : link_to(t('audio'), :action => :audio, :query => @query, per_page: @rpp))) 
 _temple_html_attributeremover4 = (::Temple::Utils.escape_html((active 'video'))).to_s 
 if !_temple_html_attributeremover4.empty? 
 _temple_html_attributeremover4 
 end 
 ::Temple::Utils.escape_html((action_name == "video" ? t('video') : link_to(t('video'), :action => :video, :query => @query, per_page: @rpp))) 
 ::Temple::Utils.escape_html((t('results_displayed', :count => @results.size))) 
 ::Temple::Utils.escape_html((link_to 50, query: @query, per_page: 50)) 
 ::Temple::Utils.escape_html((link_to 100, query: @query, per_page: 100)) 
 if @results.size > 0
 
 ::Temple::Utils.escape_html(( _temple_html_attributeremover1 = (::Temple::Utils.escape_html((cycle('odd', 'even')))).to_s 
 if !_temple_html_attributeremover1.empty? 
 _temple_html_attributeremover1 
 end 
 ::Temple::Utils.escape_html((file_type_to_icon(result[:type], result[:path]))) 
 ::Temple::Utils.escape_html((link_to h(result[:title]), path2uri(result[:path]))) 
 ::Temple::Utils.escape_html((path2location(result[:path]))) 
 ::Temple::Utils.escape_html((number_to_human_size(result[:size]))) 
 ::Temple::Utils.escape_html((h(result[:owner]))) 
 ::Temple::Utils.escape_html((link_to theme_image_tag("icons/open-folder.png"), path2uri(File.dirname result[:path]), :title => t('open'), :class => 'file-icon')) 
)) 
 else
 
 ::Temple::Utils.escape_html((t 'no_documents_found')) 
 end 
 if @page != 1
 
 ::Temple::Utils.escape_html((link_to t('previous'), query: @query, page: @page-1, per_page: @rpp)) 
 end; if @page > 5
 
 ::Temple::Utils.escape_html((link_to "1", query: @query, page: 1, per_page: @rpp)) 
 ::Temple::Utils.escape_html((link_to "2", query: @query, page: 2, per_page: @rpp)) 
 end; (1..4).each do |p|
page = @page-(5-p)
unless page < 1
 
 ::Temple::Utils.escape_html((link_to page, query: @query, page: page, per_page: @rpp)) 
 end; end 
 ::Temple::Utils.escape_html((@page)) 
 unless @results.size < @rpp
 
 (1..6).each do |p|
 
 ::Temple::Utils.escape_html((link_to @page+p, query: @query, rel: "next", page: @page+p, per_page: @rpp)) 
 end 
 ::Temple::Utils.escape_html((link_to t('next'), query: @query, page: @page+1, per_page: @rpp)) 
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

	def web
	end

protected

	def hda_search(term, filter, page, rpp = RESULTS_PER_PAGE)
		return [] unless term && !term.blank?
		locate_search(term, filter && filter.join('|'), page, rpp)
	end

	# FIXME: implement pagination
	def locate_search(term, filter, page, rpp)
		base = Share.basenames
		# lines to skip
		skip = (page - 1) * rpp
		open locate_cache(term) do |l|
			skipped = 0
			res = []
			while (file = l.gets) && (res.size < rpp)
				file.strip!
				path = pathname(file, base)
				next unless path
				r = locate2result(file, path)
				next unless r
				next if filter && r[:title] !~ /\.(#{filter})$/
				if skipped < skip
					skipped += 1
					next
				end
				res << r
			end
			res
		end
	end

	def locate_cache(term)
		FileUtils.mkdir_p(SEARCH_CACHE)
		sha1 = Digest::SHA1.hexdigest(term)
		cache = File.join(SEARCH_CACHE, sha1)
		# expire old entries in the cache to prevent accumulation (12 hours, index is 24 hours old)
		Dir.glob(File.join(SEARCH_CACHE, '*')) do |f|
			FileUtils.rm_f(f) if Time.now - File.mtime(f) > 12.hours
		end
		# is the search already in the cache? if so, return it, if not make it
		if File.exists?(cache)
			cache
		else
			# ignore case unless the search is done with some capitalization
			case_sensitive = (term =~ /[A-Z]/) ? "" : "-i"
			system "locate #{case_sensitive} -e '#{term}' > #{cache}"
			cache
		end
	end

	def locate2result(file, path)
		begin
			stat = File::Stat.new file
		rescue
			return nil
		end
		unless ["directory", "file"].include? stat.ftype
			raise "can't handle file type #{t} for #{file}"
		end
		
		{	:title => File.basename(file),
			:path => File.join(path),
			:size => stat.size,
			:owner => begin Etc.getpwuid(stat.uid).name; rescue ; stat.uid.to_s; end,
			:type => File.ftype(file)
		}
	end

	def pathname(file, basenames)
		basenames.each { |b,name| return [name, $1] if file =~ /^#{b}(.*)/ }
		nil
	end
end
