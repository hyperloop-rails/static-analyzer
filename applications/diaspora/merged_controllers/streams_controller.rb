#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class StreamsController < ApplicationController
  before_action :authenticate_user!
  before_action :save_selected_aspects, :only => :aspects

  layout proc { request.format == :mobile ? "application" : "with_header" }

  respond_to :html,
             :mobile,
             :json

  def aspects
    aspect_ids = (session[:a_ids] || [])
    @stream = Stream::Aspect.new(current_user, aspect_ids,
                                 :max_time => max_time)
    stream_responder
  end

  def public
    stream_responder(Stream::Public)
  end

  def activity
    stream_responder(Stream::Activity)
  end

  def multi
      stream_responder(Stream::Multi)
  end

  def commented
    stream_responder(Stream::Comments)
  end

  def liked
    stream_responder(Stream::Likes)
  end

  def mentioned
    stream_responder(Stream::Mention)
  end

  def followed_tags
    gon.preloads[:tagFollowings] = tags
    stream_responder(Stream::FollowedTag)
  end

  private

  def stream_responder(stream_klass=nil)

    if stream_klass.present?
      @stream ||= stream_klass.new(current_user, :max_time => max_time)
    end

    respond_with do |format|
      format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 og_prefix 
 page_title yield(:page_title) 
  if @post.present? 
 og_page_post_tags(@post) 
 else 
 og_general_tags 
 end 
 
 chartbeat_head_block 
 include_mixpanel 
 include_color_theme 
 if rtl? 
 stylesheet_link_tag :rtl, media:  'all' 
 end 
 old_browser_js_support 
 javascript_include_tag :ie 
 jquery_include_tag 
 unless @landing_page 
 javascript_include_tag :main, :templates 
 load_javascript_locales 
 end 
 translation_missing_warnings 
 current_user_atom_tag 
 yield(:head) 
 csrf_meta_tag 
 include_gon(camel_case:  true) 
 yield :before_content 
 
 content_for :head do 
 if AppConfig.chat.enabled? 
 javascript_include_tag :jsxc, id: 'jsxc',      data: { endpoint: get_bosh_endpoint } 
 end 
 end 
 if current_user.getting_started? 
 t('aspects.index.welcome_to_diaspora', name: current_user.first_name) 
 t('aspects.index.introduce_yourself') 
 link_to '&times;'.html_safe, getting_started_completed_path, id: "gs-skip-x", class: "close" 
 end 
 owner_image_link 
 link_to current_user.first_name, local_or_remote_person_path(current_user.person) 
 link_to t("streams.multi.title"), stream_path, rel: "backbone", class: "hoverable" 
 link_to t("streams.activity.title"), activity_stream_path, rel: "backbone", class: "hoverable" 
 link_to t("streams.mentions.title"), mentioned_stream_path, rel: "backbone", class: "hoverable" 
  link_to t('streams.aspects.title'), aspects_path, :class => 'hoverable', :rel => 'backbone', :data => {:stream => 'aspects'} 
 
  link_to t('streams.followed_tag.title'), followed_tags_stream_path, :class => 'hoverable', :data => {:stream => 'followed_tags'} 
 
 link_to t("streams.public.title"), public_stream_path, rel: "backbone", class: "hoverable" 
  if user_signed_in? && @person != current_user.person 
 stream.title 
 end 
 render 'publisher/publisher', publisher_aspects_for(stream) 
  t('.start_talking') 
 
 if current_user.contacts.size < 2 
  t(".you_should_add_some_more_contacts") 
 raw(t(".try_adding_some_more_contacts",         invite_link: link_to(t(".invite_link_text"),                                "#",                                class: "invitations-link",                                data: {toggle: "modal"}))) 
 if AppConfig.settings.community_spotlight.enable? 
 raw(t(".or_spotlight", link: link_to(t(".community_spotlight"), community_spotlight_path))) 
 end 
 
 end 
 
 @stream.title 
  if AppConfig.settings.invitations.open? 
 t('shared.invitations.invite_your_friends') 
  t(".share_this") 
 invite_link(current_user.invitation_code) 
 t(".by_email") 
  title 
 
 
 end 
 t('aspects.index.new_here.title') 
 raw(t('aspects.index.new_here.follow', link: link_to("#"+t('shared.publisher.new_user_prefill.newhere'), tag_path(name: t('shared.publisher.new_user_prefill.newhere'))))) 
 link_to(t('aspects.index.new_here.learn_more'), "http://wiki.diasporafoundation.org/Welcoming_Committee") 
 t('aspects.index.help.need_help') 
 t('aspects.index.help.here_to_help') 
 t('aspects.index.help.do_you') 
 raw(t('aspects.index.help.have_a_question', :link => link_to("#"+t('aspects.index.help.tag_question'), tag_path(:name => t('aspects.index.help.tag_question'))))) 
 raw(t('aspects.index.help.find_a_bug', :link => link_to("#"+t('aspects.index.help.tag_bug'), tag_path(:name => t('aspects.index.help.tag_bug'))))) 
 raw(t('aspects.index.help.feature_suggestion', :link => link_to("#"+t('aspects.index.help.tag_feature'), tag_path(:name => t('aspects.index.help.tag_feature'))))) 
 raw(t('aspects.index.help.tutorials_and_wiki',             :faq => link_to(t('_help'), help_path),             :tutorial => link_to(t('aspects.index.help.tutorial_link_text'), "https://diasporafoundation.org/tutorials", :target => '_blank'),             :wiki => link_to('Wiki','http://wiki.diasporafoundation.org', :target => '_blank'), :target => '_blank')) 
 unless AppConfig.configured_services.blank? || all_services_connected? 
 t('aspects.index.services.heading') 
 t('aspects.index.services.content') 
 AppConfig.configured_services.each do |service| 
 if AppConfig.show_service?(service, current_user) 
 unless current_user.services.any?{|x| x.provider == service} 
 link_to(content_tag(:div, nil, :class => "social_media_logos--24x24", :title => service.to_s.titleize), "/auth/") 
 end 
 end 
 end 
 end 
 t('bookmarklet.heading') 
 raw(t('bookmarklet.explanation', :link => link_to(t('bookmarklet.post_something'), bookmarklet_code))) 
 if AppConfig.settings.paypal_donations.enable? || AppConfig.bitcoin_donation_address 
 t('aspects.index.donate') 
 t('aspects.index.keep_pod_running', :pod => AppConfig.pod_uri.host) 
  if AppConfig.settings.paypal_donations.enable? 
 if AppConfig.settings.paypal_donations.paypal_hosted_button_id.present? 
 AppConfig.settings.paypal_donations.paypal_hosted_button_id 
 end 
 if AppConfig.settings.paypal_donations.paypal_unhosted_button_encrypted.present? 
 AppConfig.settings.paypal_donations.paypal_unhosted_button_encrypted 
 end 
 AppConfig.settings.paypal_donations.currency 
 t("aspects.index.donate") 
 end 
 if AppConfig.bitcoin_donation_address 
 true 
 AppConfig.bitcoin_donation_address 
 end 
 
 end 
 if AppConfig.admins.podmin_email.present? 
 t('aspects.index.help.any_problem') 
 t('aspects.index.help.contact_podmin') 
 link_to t("aspects.index.help.mail_podmin"), "mailto:" 
 end 
  link_to 'diasporafoundation.org', "https://diasporafoundation.org" 
 link_to 'Wiki', "https://wiki.diasporafoundation.org" 
 link_to t('layouts.application.whats_new'), changelog_url 
 link_to t('layouts.header.code') + " " + pod_version, "", {:title => t('layouts.application.source_package')} 
 link_to t("layouts.application.statistics_link"), statistics_path 
 link_to(t('layouts.application.toggle'), toggle_mobile_path) 
 if AppConfig.settings.terms.enable? 
 link_to(t('_terms'), terms_path) 
 end 
 
 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end
 }
      format.mobile { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 og_prefix 
 page_title yield(:page_title) 
  if @post.present? 
 og_page_post_tags(@post) 
 else 
 og_general_tags 
 end 
 
 chartbeat_head_block 
 include_mixpanel 
 include_color_theme 
 if rtl? 
 stylesheet_link_tag :rtl, media:  'all' 
 end 
 old_browser_js_support 
 javascript_include_tag :ie 
 jquery_include_tag 
 unless @landing_page 
 javascript_include_tag :main, :templates 
 load_javascript_locales 
 end 
 translation_missing_warnings 
 current_user_atom_tag 
 yield(:head) 
 csrf_meta_tag 
 include_gon(camel_case:  true) 
 yield :before_content 
 
 content_for :head do 
 if AppConfig.chat.enabled? 
 javascript_include_tag :jsxc, id: 'jsxc',      data: { endpoint: get_bosh_endpoint } 
 end 
 end 
 if current_user.getting_started? 
 t('aspects.index.welcome_to_diaspora', name: current_user.first_name) 
 t('aspects.index.introduce_yourself') 
 link_to '&times;'.html_safe, getting_started_completed_path, id: "gs-skip-x", class: "close" 
 end 
 owner_image_link 
 link_to current_user.first_name, local_or_remote_person_path(current_user.person) 
 link_to t("streams.multi.title"), stream_path, rel: "backbone", class: "hoverable" 
 link_to t("streams.activity.title"), activity_stream_path, rel: "backbone", class: "hoverable" 
 link_to t("streams.mentions.title"), mentioned_stream_path, rel: "backbone", class: "hoverable" 
  link_to t('streams.aspects.title'), aspects_path, :class => 'hoverable', :rel => 'backbone', :data => {:stream => 'aspects'} 
 
  link_to t('streams.followed_tag.title'), followed_tags_stream_path, :class => 'hoverable', :data => {:stream => 'followed_tags'} 
 
 link_to t("streams.public.title"), public_stream_path, rel: "backbone", class: "hoverable" 
  if user_signed_in? && @person != current_user.person 
 stream.title 
 end 
 render 'publisher/publisher', publisher_aspects_for(stream) 
  t('.start_talking') 
 
 if current_user.contacts.size < 2 
  t(".you_should_add_some_more_contacts") 
 raw(t(".try_adding_some_more_contacts",         invite_link: link_to(t(".invite_link_text"),                                "#",                                class: "invitations-link",                                data: {toggle: "modal"}))) 
 if AppConfig.settings.community_spotlight.enable? 
 raw(t(".or_spotlight", link: link_to(t(".community_spotlight"), community_spotlight_path))) 
 end 
 
 end 
 
 @stream.title 
  if AppConfig.settings.invitations.open? 
 t('shared.invitations.invite_your_friends') 
  t(".share_this") 
 invite_link(current_user.invitation_code) 
 t(".by_email") 
  title 
 
 
 end 
 t('aspects.index.new_here.title') 
 raw(t('aspects.index.new_here.follow', link: link_to("#"+t('shared.publisher.new_user_prefill.newhere'), tag_path(name: t('shared.publisher.new_user_prefill.newhere'))))) 
 link_to(t('aspects.index.new_here.learn_more'), "http://wiki.diasporafoundation.org/Welcoming_Committee") 
 t('aspects.index.help.need_help') 
 t('aspects.index.help.here_to_help') 
 t('aspects.index.help.do_you') 
 raw(t('aspects.index.help.have_a_question', :link => link_to("#"+t('aspects.index.help.tag_question'), tag_path(:name => t('aspects.index.help.tag_question'))))) 
 raw(t('aspects.index.help.find_a_bug', :link => link_to("#"+t('aspects.index.help.tag_bug'), tag_path(:name => t('aspects.index.help.tag_bug'))))) 
 raw(t('aspects.index.help.feature_suggestion', :link => link_to("#"+t('aspects.index.help.tag_feature'), tag_path(:name => t('aspects.index.help.tag_feature'))))) 
 raw(t('aspects.index.help.tutorials_and_wiki',             :faq => link_to(t('_help'), help_path),             :tutorial => link_to(t('aspects.index.help.tutorial_link_text'), "https://diasporafoundation.org/tutorials", :target => '_blank'),             :wiki => link_to('Wiki','http://wiki.diasporafoundation.org', :target => '_blank'), :target => '_blank')) 
 unless AppConfig.configured_services.blank? || all_services_connected? 
 t('aspects.index.services.heading') 
 t('aspects.index.services.content') 
 AppConfig.configured_services.each do |service| 
 if AppConfig.show_service?(service, current_user) 
 unless current_user.services.any?{|x| x.provider == service} 
 link_to(content_tag(:div, nil, :class => "social_media_logos--24x24", :title => service.to_s.titleize), "/auth/") 
 end 
 end 
 end 
 end 
 t('bookmarklet.heading') 
 raw(t('bookmarklet.explanation', :link => link_to(t('bookmarklet.post_something'), bookmarklet_code))) 
 if AppConfig.settings.paypal_donations.enable? || AppConfig.bitcoin_donation_address 
 t('aspects.index.donate') 
 t('aspects.index.keep_pod_running', :pod => AppConfig.pod_uri.host) 
  if AppConfig.settings.paypal_donations.enable? 
 if AppConfig.settings.paypal_donations.paypal_hosted_button_id.present? 
 AppConfig.settings.paypal_donations.paypal_hosted_button_id 
 end 
 if AppConfig.settings.paypal_donations.paypal_unhosted_button_encrypted.present? 
 AppConfig.settings.paypal_donations.paypal_unhosted_button_encrypted 
 end 
 AppConfig.settings.paypal_donations.currency 
 t("aspects.index.donate") 
 end 
 if AppConfig.bitcoin_donation_address 
 true 
 AppConfig.bitcoin_donation_address 
 end 
 
 end 
 if AppConfig.admins.podmin_email.present? 
 t('aspects.index.help.any_problem') 
 t('aspects.index.help.contact_podmin') 
 link_to t("aspects.index.help.mail_podmin"), "mailto:" 
 end 
  link_to 'diasporafoundation.org', "https://diasporafoundation.org" 
 link_to 'Wiki', "https://wiki.diasporafoundation.org" 
 link_to t('layouts.application.whats_new'), changelog_url 
 link_to t('layouts.header.code') + " " + pod_version, "", {:title => t('layouts.application.source_package')} 
 link_to t("layouts.application.statistics_link"), statistics_path 
 link_to(t('layouts.application.toggle'), toggle_mobile_path) 
 if AppConfig.settings.terms.enable? 
 link_to(t('_terms'), terms_path) 
 end 
 
 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end
 }
      format.json { render :json => @stream.stream_posts.map {|p| LastThreeCommentsDecorator.new(PostPresenter.new(p, current_user)) }}
    end
  end

  def save_selected_aspects
    if params[:a_ids].present?
      session[:a_ids] = params[:a_ids]
    end
  end
end
