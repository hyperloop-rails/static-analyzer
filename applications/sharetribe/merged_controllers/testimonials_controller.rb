class TestimonialsController < ApplicationController

  before_filter :except => :index do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_give_feedback")
  end

  before_filter :ensure_authorized_to_give_feedback, :except => :index
  before_filter :ensure_feedback_not_given, :except => :index

  # Skip auth token check as current jQuery doesn't provide it automatically
  skip_before_filter :verify_authenticity_token, :only => [:skip]

  def index
    @person = Person.find(params[:person_id] || params[:id])
    PersonViewUtils.ensure_person_belongs_to_community!(@person, @current_community)

    if request.xhr?
      @testimonials = @person.received_testimonials.paginate(:per_page => params[:per_page], :page => params[:page])
      limit = params[:per_page].to_i
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
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
   
 if received_testimonials.size > limit 
 link_to t("people.show.show_all_reviews"), "#" 
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
      redirect_to person_path(@person)
    end
  end

  def new
    transaction = Transaction.find(params[:message_id])
    testimonial = Testimonial.new
    render(locals: { transaction: transaction, testimonial: testimonial})
  end

  def create
    @testimonial = @transaction.testimonials.build(params[:testimonial])

    if @testimonial.save
      Delayed::Job.enqueue(TestimonialGivenJob.new(@testimonial.id, @current_community))
      flash[:notice] = t("layouts.notifications.feedback_sent_to", :target_person => view_context.link_to(@transaction.other_party(@current_user).given_name_or_username, @transaction.other_party(@current_user))).html_safe
      redirect_to person_transaction_path(:person_id => @current_user.id, :id => @transaction.id)
    else
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
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
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
 t(".give_feedback_to", :person => transaction.other_party(@current_user).name(@current_community)) 
 t(".this_will_be_shown_in_profile", :person => transaction.other_party(@current_user).given_name_or_username) 
 form_for testimonial, :url => person_message_feedbacks_path(:person_id => @current_user.id, :message_id => transaction.id) do |form| 
 form.error_messages 
 form.label :text, t('.textual_feedback') 
 form.text_area :text, :placeholder => t(".default_textual_feedback") 
 form.label :grade, t(".grade") 
 Testimonial::GRADES.each do |grade| 
 grade[1][:form_value] 
 radio_button_tag "testimonial[grade]", grade[1][:db_value], grade[1][:default], :id => "grade-#{grade[1][:form_value]}" 
 grade[0] 
 grade[1][:form_value] 
 icon_tag(grade[1][:icon], ["link-icon"]) 
 grade[0] 
 t(".#{grade[0]}") 
 end 
 form.hidden_field :author_id, :value => @current_user.id 
 form.hidden_field :receiver_id, :value => transaction.other_party(@current_user).id 
 form.button t(".send_feedback"), :class => "send_button", :id => "send_testimonial_button" 
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

  def skip
    is_author = @transaction.author == @current_user

    if is_author
      @transaction.update_attributes(author_skipped_feedback: true)
    else
      @transaction.update_attributes(starter_skipped_feedback: true)
    end

    respond_to do |format|
      format.html {
        flash[:notice] = t("layouts.notifications.feedback_skipped")
        redirect_to single_conversation_path(:conversation_type => "received", :person_id => @current_user.id, :id => @transaction.id)
      }
      format.js { render :layout => false, locals: {is_author: is_author} }
    end
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
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
   get_conversation_statuses(__transaction_model, is_author).each do |status| 
 if status[:type] == :status_info 
  if status_info[:info_icon_tag].present? 
 status_info[:info_icon_tag] 
 else 
 status_info[:info_icon_part_classes] 
 end 
 status_info[:info_text_part] 
 
 else 
 if role == :participant 
 status[:content].each do |status_link| 
  status_link[:link_classes] 
 status_link[:link_data] 
 status_link[:link_href] 
 if status_link[:link_icon_tag].present? 
 status_link[:link_icon_tag] 
 else 
 status_link[:link_icon_with_text_classes] 
 end 
 status_link[:link_text_with_icon] 
 
 end 
 end 
 end 
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

  private

  def ensure_authorized_to_give_feedback
    # Rails was giving some read-only records. That's why we have to do some manual queries here and use INCLUDES,
    # not joins.
    # TODO Move this to service
    @transaction = Transaction
      .includes(:listing)
      .where("starter_id = ? OR listings.author_id = ?", @current_user.id, @current_user.id)
      .where({
        community_id: @current_community.id,
        id: params[:message_id]
      }).first

    if @transaction.nil?
      flash[:error] = t("layouts.notifications.you_are_not_allowed_to_give_feedback_on_this_transaction")
      redirect_to root and return
    end
  end

  def ensure_feedback_not_given
    transaction_entity = MarketplaceService::Transaction::Entity.transaction(@transaction)
    waiting = MarketplaceService::Transaction::Entity.waiting_testimonial_from?(transaction_entity, @current_user.id)

    unless waiting
      flash[:error] = t("layouts.notifications.you_have_already_given_feedback_about_this_event")
      redirect_to root and return
    end
  end

end
