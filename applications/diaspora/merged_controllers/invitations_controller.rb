#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class InvitationsController < ApplicationController

  before_action :authenticate_user!, :only => [:new, :create]

  def new
    @invite_code = current_user.invitation_code

    @invalid_emails = html_safe_string_from_session_array(:invalid_email_invites)
    @valid_emails   = html_safe_string_from_session_array(:valid_email_invites)

    respond_to do |format|
      format.html do
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t('.paste_link') 
 '(' + t('.codes_left', count: @invite_code.count) + ')' 
 invite_link(@invite_code) 
 form_tag new_user_invitation_path, class: 'form-horizontal' do 
 t('email') 
 text_field_tag 'email_inviter[emails]', @invalid_emails, title: t('.comma_separated_plz'),            placeholder: 'foo@bar.com, max@foo.com...', class: "form-control" 
 t('invitations.create.note_already_sent', emails: @valid_emails) unless @valid_emails.empty? 
 t('.language') 
 select_tag 'email_inviter[locale]',  options_from_collection_for_select(available_language_options,            "second", "first", selected: current_user.language), class: "form-control" 
 submit_tag t('.send_an_invitation'), class: 'btn btn-primary pull-right',            data: {disable_with: t('.sending_invitation')} 
 end 

end

      end
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 
 t('.paste_link') 
 '(' + t('.codes_left', count: @invite_code.count) + ')' 
 invite_link(@invite_code) 
 form_tag new_user_invitation_path, class: 'form-horizontal' do 
 t('email') 
 text_field_tag 'email_inviter[emails]', @invalid_emails, title: t('.comma_separated_plz'),            placeholder: 'foo@bar.com, max@foo.com...', class: "form-control" 
 t('invitations.create.note_already_sent', emails: @valid_emails) unless @valid_emails.empty? 
 t('.language') 
 select_tag 'email_inviter[locale]',  options_from_collection_for_select(available_language_options,            "second", "first", selected: current_user.language), class: "form-control" 
 submit_tag t('.send_an_invitation'), class: 'btn btn-primary pull-right',            data: {disable_with: t('.sending_invitation')} 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  # this is  for legacy invites.  We try to look the person who sent them the
  # invite, and use their new invite code
  # owe will be removing this eventually
  # @depreciated
  def edit
    user = User.find_by_invitation_token(params[:invitation_token])
    invitation_code = user.ugly_accept_invitation_code
    redirect_to invite_code_path(invitation_code)
  end

  def email
    @invitation_code =
      if params[:invitation_token]
        # this is  for legacy invites.
        user = User.find_by_invitation_token(params[:invitation_token])

        user.ugly_accept_invitation_code if user
      else
        params[:invitation_code]
      end

    if @invitation_code.present?
      render 'notifier/invite', :layout => false
    else
      flash[:error] = t('invitations.check_token.not_found')

      redirect_to root_url
    end
  end

  def create
    emails = inviter_params[:emails].split(',').map(&:strip).uniq

    valid_emails, invalid_emails = emails.partition { |email| valid_email?(email) }

    session[:valid_email_invites] = valid_emails
    session[:invalid_email_invites] = invalid_emails

    unless valid_emails.empty?
      Workers::Mail::InviteEmail.perform_async(valid_emails.join(','),
                                               current_user.id,
                                               inviter_params)
    end

    if emails.empty?
      flash[:error] = t('invitations.create.empty')
    elsif invalid_emails.empty?
      flash[:notice] =  t('invitations.create.sent', :emails => valid_emails.join(', '))
    elsif valid_emails.empty?
      flash[:error] = t('invitations.create.rejected') +  invalid_emails.join(', ')
    else
      flash[:error] = t('invitations.create.sent', :emails => valid_emails.join(', '))
      flash[:error] << '. '
      flash[:error] << t('invitations.create.rejected') +  invalid_emails.join(', ')
    end

    redirect_to :back
  end

  def check_if_invites_open
    unless AppConfig.settings.invitations.open?
      flash[:error] = I18n.t 'invitations.create.no_more'

      redirect_to :back
    end
  end

  private
  def valid_email?(email)
    User.email_regexp.match(email).present?
  end

  def html_safe_string_from_session_array(key)
    return "" unless session[key].present?
    return "" unless session[key].respond_to?(:join)
    value = session[key].join(', ').html_safe
    session[key] = nil
    return value
  end

  def inviter_params
    params.require(:email_inviter).permit(:message, :locale, :emails)
  end
end
