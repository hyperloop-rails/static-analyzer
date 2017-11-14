class CommunityMembershipsController < ApplicationController

  before_filter do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_this_page")
  end

  skip_filter :cannot_access_without_joining
  skip_filter :check_email_confirmation, :only => [:new, :create]

  def new
    existing_membership = @current_user.community_memberships.where(:community_id => @current_community.id).first

    if existing_membership && existing_membership.accepted?
      flash[:notice] = t("layouts.notifications.you_are_already_member")
      redirect_to root and return
    elsif existing_membership && existing_membership.pending_email_confirmation?
      # Check if requirements are already filled, but the membership just hasn't been updated yet
      # (This might happen if unexpected error happens during page load and it shouldn't leave people in loop of of
      # having email confirmed but not the membership)
      if @current_user.has_valid_email_for_community?(@current_community)
        @current_community.approve_pending_membership(@current_user)
        redirect_to root and return
      end

      redirect_to confirmation_pending_path and return
    elsif existing_membership && existing_membership.banned?
      redirect_to access_denied_tribe_memberships_path and return
    end

    @skip_terms_checkbox = true if existing_membership && existing_membership.current_terms_accepted?
    @community_membership = CommunityMembership.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {'SiteName' : '#{@current_community.ident}'}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 I18n.locale 
 content_for :head 
  
 
  
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 t('.join_community', :community => @current_community.name(I18n.locale)) 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t('.join_community', :community => @current_community.name(I18n.locale)) 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  content_for :javascript do 
 end 
  
 if session[:fb_join] == "pending_analytics" 
 content_for :javascript do 
 end 
 session[:fb_join] = "analytics_reported" 
 end 
 if @current_community.join_with_invite_only? && session[:invitation_code].blank? 
 t('.you_can_join_with_invite_only') 
 elsif @current_community.allowed_emails? && ! @current_user.has_valid_email_for_community?(@current_community) 
 if @current_community.allowed_emails.split(",").size > 1 
 t('.you_can_join_email_confirmation_multiple_addresses', :email_endings => @current_community.allowed_emails.split(",").join(", ")) 
 else 
 t('.you_can_join_email_confirmation', :email_ending => @current_community.allowed_emails) 
 end 
 else 
 if session[:fb_join] 
 t('.welcome_fb_user', :name => @current_user.given_name_or_username) 
 t('.fb_join_accept_terms') 
 else 
 t('.you_can_join') 
 end 
 end 
 unless @current_user.communities.size < 1 
 t(".if_want_to_view_content") 
 link_to(t(".log_out"), logout_path) + "." 
 end 
 form_for @community_membership, :url => { :controller => "community_memberships", :action => "create" } do |form| 
 if @current_community.join_with_invite_only? 
 if session[:invitation_code] 
 hidden_field_tag "invitation_code", session[:invitation_code] 
 else 
 label_tag :invitation_code, t('people.new.invitation_code'), :class => "inline" 
 link_to t('common.what_is_this'), "#", :tabindex => "-1", :id => "help_invitation_code_link", :class => "label-info" 
 text_field_tag "invitation_code", nil, :class => :text_field, :maxlength => "20", :value => (params[:code] || "") 
 end 
 end 
 if @current_community.allowed_emails? && ! @current_user.has_valid_email_for_community?(@current_community) 
 form.label :email, t('people.new.email'), :class => "before_description" 
 form.text_field :email, :class => :text_field, :maxlenght => "255" 
 end 
 unless @skip_terms_checkbox 
 form.label :consent, t('people.new.i_accept_the'), :class => "checkbox" 
 link_to t("people.new.terms"), "#", :tabindex => "-1", :id => "terms_link", :class => "form" 
 end 
 form.hidden_field :community_id, :value => @current_community.id 
 form.hidden_field :person_id, :value => @current_user.id 
 form.hidden_field :consent, :value => @current_community.consent 
 button_tag(t('.join_community_button'), :class => "send_button") 
 end 
  render :layout => "layouts/lightbox", locals: {id: field, field: field} do 
 unless field.eql?("terms") 
 t("people.help_texts.#{field}_title") 
 end 
 render :partial => "people/help_texts/#{field}" 
 end 
 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain || @current_community.ident}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

  end

  def create
    # if there already exists one, modify that
    existing = CommunityMembership.find_by_person_id_and_community_id(@current_user.id, @current_community.id)
    @community_membership = existing || CommunityMembership.new(params[:community_membership].merge({status: "pending_email_confirmation"}))

    # if invitation code is stored in session, use it here
    params[:invitation_code] ||= session[:invitation_code]

    if @current_community.join_with_invite_only? || params[:invitation_code]
      unless Invitation.code_usable?(params[:invitation_code], @current_community)
        # abort user creation if invitation is not usable.
        # (This actually should not happen since the code is checked with javascript)
        # This could happen if invitation code is coming from hidden field and is wrong/used for some reason
        session[:invitation_code] = nil # reset code from session if there was issues so that's not used again
        ApplicationHelper.send_error_notification("Invitation code check did not prevent submiting form, but was detected in the CommunityMembershipsController", "Invitation code error")

        # TODO: if this ever happens, should change the message to something else than "unknown error"
        flash[:error] = t("layouts.notifications.unknown_error")
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {'SiteName' : '#{@current_community.ident}'}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 I18n.locale 
 content_for :head 
  
 
  
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 t('.join_community', :community => @current_community.name(I18n.locale)) 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t('.join_community', :community => @current_community.name(I18n.locale)) 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  content_for :javascript do 
 end 
  
 if session[:fb_join] == "pending_analytics" 
 content_for :javascript do 
 end 
 session[:fb_join] = "analytics_reported" 
 end 
 if @current_community.join_with_invite_only? && session[:invitation_code].blank? 
 t('.you_can_join_with_invite_only') 
 elsif @current_community.allowed_emails? && ! @current_user.has_valid_email_for_community?(@current_community) 
 if @current_community.allowed_emails.split(",").size > 1 
 t('.you_can_join_email_confirmation_multiple_addresses', :email_endings => @current_community.allowed_emails.split(",").join(", ")) 
 else 
 t('.you_can_join_email_confirmation', :email_ending => @current_community.allowed_emails) 
 end 
 else 
 if session[:fb_join] 
 t('.welcome_fb_user', :name => @current_user.given_name_or_username) 
 t('.fb_join_accept_terms') 
 else 
 t('.you_can_join') 
 end 
 end 
 unless @current_user.communities.size < 1 
 t(".if_want_to_view_content") 
 link_to(t(".log_out"), logout_path) + "." 
 end 
 form_for @community_membership, :url => { :controller => "community_memberships", :action => "create" } do |form| 
 if @current_community.join_with_invite_only? 
 if session[:invitation_code] 
 hidden_field_tag "invitation_code", session[:invitation_code] 
 else 
 label_tag :invitation_code, t('people.new.invitation_code'), :class => "inline" 
 link_to t('common.what_is_this'), "#", :tabindex => "-1", :id => "help_invitation_code_link", :class => "label-info" 
 text_field_tag "invitation_code", nil, :class => :text_field, :maxlength => "20", :value => (params[:code] || "") 
 end 
 end 
 if @current_community.allowed_emails? && ! @current_user.has_valid_email_for_community?(@current_community) 
 form.label :email, t('people.new.email'), :class => "before_description" 
 form.text_field :email, :class => :text_field, :maxlenght => "255" 
 end 
 unless @skip_terms_checkbox 
 form.label :consent, t('people.new.i_accept_the'), :class => "checkbox" 
 link_to t("people.new.terms"), "#", :tabindex => "-1", :id => "terms_link", :class => "form" 
 end 
 form.hidden_field :community_id, :value => @current_community.id 
 form.hidden_field :person_id, :value => @current_user.id 
 form.hidden_field :consent, :value => @current_community.consent 
 button_tag(t('.join_community_button'), :class => "send_button") 
 end 
  render :layout => "layouts/lightbox", locals: {id: field, field: field} do 
 unless field.eql?("terms") 
 t("people.help_texts.#{field}_title") 
 end 
 render :partial => "people/help_texts/#{field}" 
 end 
 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain || @current_community.ident}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end
      else
        invitation = Invitation.find_by_code(params[:invitation_code].upcase)
      end
    end

    # If community requires certain email address and user doesn't have it confirmed.
    # Send confirmation for that.
    if !@current_user.has_valid_email_for_community?(@current_community)
      if @current_community.allowed_emails.present?

        # no confirmed allowed email found. Check if there is unconfirmed or should we add one.
        if @current_user.has_email?(params[:community_membership][:email])
          e = Email.find_by_address(params[:community_membership][:email])
        elsif
          e = Email.create(:person => @current_user, :address => params[:community_membership][:email])
        end

        # Send confirmation and make membership pending
        Email.send_confirmation(e, @current_community)

      # If user is already a member of one community (with pending email address)
      # we need to resend the confirmation email and update membership status to "pending_email_confirmation"
      elsif @current_user.community_memberships.size > 0
        Maybe(@current_user.latest_pending_email_address(@current_community)).map { |email_address|
          Email.send_confirmation(Email.find_by_address(email_address), @current_community)
        }
      end

      @community_membership.status = "pending_email_confirmation"
      flash[:notice] = "#{t("layouts.notifications.you_need_to_confirm_your_account_first")} #{t("sessions.confirmation_pending.check_your_email")}."
    else
      @community_membership.status = "accepted"
    end

    @community_membership.invitation = invitation if invitation.present?

    # If the community doesn't have any members, make the first one an admin
    if @current_community.members.count == 0
      @community_membership.admin = true
    end

    # This is reached only if requirements are fulfilled
    if @community_membership.save
      session[:fb_join] = nil
      session[:invitation_code] = nil
      # If invite was used, reduce usages left
      invitation.use_once! if invitation.present?

      Delayed::Job.enqueue(CommunityJoinedJob.new(@current_user.id, @current_community.id))
      Delayed::Job.enqueue(SendWelcomeEmail.new(@current_user.id, @current_community.id), priority: 5)
      flash[:notice] = t("layouts.notifications.you_are_now_member")
      redirect_to root
    else
      flash[:error] = t("layouts.notifications.joining_community_failed")
      logger.info { "Joining a community failed, because: #{@community_membership.errors.full_messages}" }
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {'SiteName' : '#{@current_community.ident}'}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 I18n.locale 
 content_for :head 
  
 
  
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 t('.join_community', :community => @current_community.name(I18n.locale)) 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t('.join_community', :community => @current_community.name(I18n.locale)) 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  content_for :javascript do 
 end 
  
 if session[:fb_join] == "pending_analytics" 
 content_for :javascript do 
 end 
 session[:fb_join] = "analytics_reported" 
 end 
 if @current_community.join_with_invite_only? && session[:invitation_code].blank? 
 t('.you_can_join_with_invite_only') 
 elsif @current_community.allowed_emails? && ! @current_user.has_valid_email_for_community?(@current_community) 
 if @current_community.allowed_emails.split(",").size > 1 
 t('.you_can_join_email_confirmation_multiple_addresses', :email_endings => @current_community.allowed_emails.split(",").join(", ")) 
 else 
 t('.you_can_join_email_confirmation', :email_ending => @current_community.allowed_emails) 
 end 
 else 
 if session[:fb_join] 
 t('.welcome_fb_user', :name => @current_user.given_name_or_username) 
 t('.fb_join_accept_terms') 
 else 
 t('.you_can_join') 
 end 
 end 
 unless @current_user.communities.size < 1 
 t(".if_want_to_view_content") 
 link_to(t(".log_out"), logout_path) + "." 
 end 
 form_for @community_membership, :url => { :controller => "community_memberships", :action => "create" } do |form| 
 if @current_community.join_with_invite_only? 
 if session[:invitation_code] 
 hidden_field_tag "invitation_code", session[:invitation_code] 
 else 
 label_tag :invitation_code, t('people.new.invitation_code'), :class => "inline" 
 link_to t('common.what_is_this'), "#", :tabindex => "-1", :id => "help_invitation_code_link", :class => "label-info" 
 text_field_tag "invitation_code", nil, :class => :text_field, :maxlength => "20", :value => (params[:code] || "") 
 end 
 end 
 if @current_community.allowed_emails? && ! @current_user.has_valid_email_for_community?(@current_community) 
 form.label :email, t('people.new.email'), :class => "before_description" 
 form.text_field :email, :class => :text_field, :maxlenght => "255" 
 end 
 unless @skip_terms_checkbox 
 form.label :consent, t('people.new.i_accept_the'), :class => "checkbox" 
 link_to t("people.new.terms"), "#", :tabindex => "-1", :id => "terms_link", :class => "form" 
 end 
 form.hidden_field :community_id, :value => @current_community.id 
 form.hidden_field :person_id, :value => @current_user.id 
 form.hidden_field :consent, :value => @current_community.consent 
 button_tag(t('.join_community_button'), :class => "send_button") 
 end 
  render :layout => "layouts/lightbox", locals: {id: field, field: field} do 
 unless field.eql?("terms") 
 t("people.help_texts.#{field}_title") 
 end 
 render :partial => "people/help_texts/#{field}" 
 end 
 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain || @current_community.ident}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

    end
  end

  def access_denied

ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {'SiteName' : '#{@current_community.ident}'}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 I18n.locale 
 content_for :head 
  
 
  
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 t(".access_denied") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t(".access_denied") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
   
 t(".you_are_banned_in_this_community", :link_to_contact_page => link_to(t(".contact_page_link"), new_user_feedback_path )).html_safe 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain || @current_community.ident}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

  end
end
