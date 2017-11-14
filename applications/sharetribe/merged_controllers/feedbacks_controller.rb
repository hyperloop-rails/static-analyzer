class FeedbacksController < ApplicationController

  skip_filter :check_email_confirmation
  skip_filter :cannot_access_without_joining

  FeedbackForm = FormUtils.define_form("Feedback",
                                       :content,
                                       :title,
                                       :url, # referrer
                                       :email
  ).with_validations {
    validates_presence_of :content
  }

  def new
    render_form
  end

  def create
    feedback_form = FeedbackForm.new(params[:feedback])
    return if ensure_not_spam!(params[:feedback], feedback_form)

    unless feedback_form.valid?
      flash[:error] = t("layouts.notifications.feedback_not_saved") # feedback_form.errors.full_messages.join(", ")
      return render_form(feedback_form)
    end

    author_id = Maybe(@current_user).id.or_else("Anonymous")
    email = current_user_email || feedback_form.email

    feedback = Feedback.create(
      feedback_form.to_hash.merge({
                                    community_id: @current_community.id,
                                    author_id: author_id,
                                    email: email
                                  }))

    PersonMailer.new_feedback(feedback, @current_community).deliver

    flash[:notice] = t("layouts.notifications.feedback_saved")
    redirect_to root
  end

  private

  def render_form(form = nil)
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
 t("layouts.no_tribe.feedback") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.no_tribe.feedback") 
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
  
 form_for feedback_form, :url => user_feedbacks_path do |form| 
 unless email_present 
 form.label :email, t("layouts.application.your_email_address") 
 form.text_field :email 
 end 
 form.label :title, "You should not see this field, if CSS is working.", :class => "unwanted_text_field" 
 form.text_field :title, :class => "unwanted_text_field", :id => "error_feedback_unwanted_title" 
 form.label :content, t("layouts.application.feedback") 
 form.text_area :content, :placeholder => t("layouts.application.default_feedback") 
 form.hidden_field :url, :value => request.headers["HTTP_REFERER"] || request.original_url 
 form.button t("layouts.application.send_feedback_to_admin") 
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

  def feedback_locals(feedback_form)
    {
      email_present: current_user_email.present?,
      feedback_form: feedback_form || FeedbackForm.new(title: nil) # title is honeypot
    }
  end

  def current_user_email
    Maybe(@current_user).confirmed_notification_email_to.or_else(nil)
  end

  # Return truthy if is spam
  def ensure_not_spam!(params, feedback_form)
    if spam?(params[:content], params[:title])
      flash[:error] = t("layouts.notifications.feedback_considered_spam")
      return render_form(feedback_form)
    else
      false
    end
  end

  def link_tags?(str)
    str.include?("[url=") || str.include?("<a href=")
  end

  def too_many_urls?(str)
    str.scan("http://").count > 10
  end

  # Detect most usual spam messages
  def spam?(content, honeypot)
    honeypot.present? || link_tags?(content) || too_many_urls?(content)
  end
end
