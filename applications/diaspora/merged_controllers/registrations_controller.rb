#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class RegistrationsController < Devise::RegistrationsController
  before_action :check_registrations_open_or_valid_invite!, :check_valid_invite!

  layout ->(c) { request.format == :mobile ? "application" : "with_header" }, :only => [:new]

  def create
    @user = User.build(user_params)
    @user.process_invite_acceptence(invite) if invite.present?

    if @user.sign_up
      flash[:notice] = I18n.t 'registrations.create.success'
      @user.seed_aspects
      @user.send_welcome_message
      sign_in_and_redirect(:user, @user)
      logger.info "event=registration status=successful user=#{@user.diaspora_handle}"
    else
      @user.errors.delete(:person)

      flash.now[:error] = @user.errors.full_messages.join(" - ")
      logger.info "event=registration status=failure errors='#{@user.errors.full_messages.join(', ')}'"
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 AppConfig.settings.pod_name 
  form_for(resource, url: registration_path(resource_name), html: {class: "form-horizontal block-form", autocomplete: "off"}) do |f| 
 f.label :email, t("registrations.new.email"), class: "sr-only control-label", id: "emailLabel" 
 f.email_field :email,                    autofocus:   true,                    class:       "input-block-level form-control",                    data:        {content: t("users.edit.your_email_private")},                    placeholder: t("registrations.new.email"),                    required:    true,                    title:       t("registrations.new.enter_email"),                    aria:        {labelledby: "emailLabel"} 
 t("registrations.new.username") 
 f.text_field :username,                   class:       "input-block-level form-control",                   placeholder: t("registrations.new.username"),                   title:       t("registrations.new.enter_username"),                   required:    true,                   pattern:     "[A-Za-z0-9_]+",                   aria:        {labelledby: "usernameLabel"} 
 t("registrations.new.password") 
 f.password_field :password,                       class:       "input-block-level form-control",                       placeholder: t("registrations.new.password"),                       title:       t("registrations.new.enter_password"),                       required:    true,                       pattern:     "......+",                       aria:        {labelledby: "passwordLabel"} 
 t("registrations.new.password_confirmation") 
 f.password_field :password_confirmation,                       class:       "input-block-level form-control",                       placeholder: t("registrations.new.password_confirmation"),                       title:       t("registrations.new.enter_password_again"),                       required:    true,                       pattern:     "......+",                       aria:        {labelledby: "passwordConfirmationLabel"} 
 if AppConfig.settings.captcha.enable? 
 show_simple_captcha object: "user",                            code_type: "numeric",                            class: "simple-captcha-image",                            input_html: {class: "form-control captcha-input"} 
 end 
 invite_hidden_tag(invite) 
 if AppConfig.settings.terms.enable? 
 t('registrations.new.terms', terms_link: link_to(t('registrations.new.terms_link'), terms_path, target: "_blank")).html_safe 
 end 
 f.submit t("registrations.new.sign_up"), class: "btn btn-block btn-large btn-primary",    data: {disable_with: t("registrations.new.submitting")} 
 end 
 

end

    end
  end

  def new
    super
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 AppConfig.settings.pod_name 
  form_for(resource, url: registration_path(resource_name), html: {class: "form-horizontal block-form", autocomplete: "off"}) do |f| 
 f.label :email, t("registrations.new.email"), class: "sr-only control-label", id: "emailLabel" 
 f.email_field :email,                    autofocus:   true,                    class:       "input-block-level form-control",                    data:        {content: t("users.edit.your_email_private")},                    placeholder: t("registrations.new.email"),                    required:    true,                    title:       t("registrations.new.enter_email"),                    aria:        {labelledby: "emailLabel"} 
 t("registrations.new.username") 
 f.text_field :username,                   class:       "input-block-level form-control",                   placeholder: t("registrations.new.username"),                   title:       t("registrations.new.enter_username"),                   required:    true,                   pattern:     "[A-Za-z0-9_]+",                   aria:        {labelledby: "usernameLabel"} 
 t("registrations.new.password") 
 f.password_field :password,                       class:       "input-block-level form-control",                       placeholder: t("registrations.new.password"),                       title:       t("registrations.new.enter_password"),                       required:    true,                       pattern:     "......+",                       aria:        {labelledby: "passwordLabel"} 
 t("registrations.new.password_confirmation") 
 f.password_field :password_confirmation,                       class:       "input-block-level form-control",                       placeholder: t("registrations.new.password_confirmation"),                       title:       t("registrations.new.enter_password_again"),                       required:    true,                       pattern:     "......+",                       aria:        {labelledby: "passwordConfirmationLabel"} 
 if AppConfig.settings.captcha.enable? 
 show_simple_captcha object: "user",                            code_type: "numeric",                            class: "simple-captcha-image",                            input_html: {class: "form-control captcha-input"} 
 end 
 invite_hidden_tag(invite) 
 if AppConfig.settings.terms.enable? 
 t('registrations.new.terms', terms_link: link_to(t('registrations.new.terms_link'), terms_path, target: "_blank")).html_safe 
 end 
 f.submit t("registrations.new.sign_up"), class: "btn btn-block btn-large btn-primary",    data: {disable_with: t("registrations.new.submitting")} 
 end 
 

end

  end

  private

  def check_valid_invite!
    return true if AppConfig.settings.enable_registrations? #this sucks
    return true if invite && invite.can_be_used?
    flash[:error] = t('registrations.invalid_invite')
    redirect_to new_user_session_path
  end

  def check_registrations_open_or_valid_invite!
    return true if invite.present?
    unless AppConfig.settings.enable_registrations?
      flash[:error] = t('registrations.closed')
      redirect_to new_user_session_path
    end
  end

  def invite
    if params[:invite].present?
      @invite ||= InvitationCode.find_by_token(params[:invite][:token])
    end
  end

  helper_method :invite

  def user_params
    params.require(:user).permit(:username, :email, :getting_started, :password, :password_confirmation, :language, :disable_mail, :invitation_service, :invitation_identifier, :show_community_spotlight_in_stream, :auto_follow_back, :auto_follow_back_aspect_id, :remember_me, :captcha, :captcha_key)
  end
end
