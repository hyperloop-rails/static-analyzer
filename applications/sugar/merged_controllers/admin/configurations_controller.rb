class Admin::ConfigurationsController < AdminController
  before_action :find_configuration

  def show
    redirect_to edit_admin_configuration_url
  end

  def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 [@page_title, Sugar.config.forum_name].compact.join(' - ') 
 stylesheet_link_tag "application" 
 if current_user? && current_user.stylesheet_url? 
 stylesheet_link_tag current_user.stylesheet_url 
 else 
 stylesheet_link_tag @theme.stylesheet_path 
 end 
 icon_tags 
 csrf_meta_tag 
 javascript_include_tag "swfobject" 
 body_classes 
 if Sugar.config.custom_header 
 raw Sugar.config.custom_header 
 end 
 Sugar.config.forum_title.html_safe 
 if current_user? || Sugar.public_browsing? 
 form_tag((@search_path || search_path), method: 'get') do 
 text_field_tag 'q', @search_query, class: :query 
 select_tag 'search_mode', options_for_select(
            search_mode_options,
            @search_path || search_path
          ) 
 submit_tag "Search", name: nil 
 end 
 end 
 if current_user? 
 profile_link(current_user) 
 link_to "Sign out", logout_users_path, data: { confirm: "Do you really want to sign out?"} 
 else 
 if Sugar.config.signups_allowed 
 link_to("Sign up", new_user_path) 
 end 
 link_to "Log in", login_users_path 
 end 
 if current_user? || Sugar.public_browsing? 
 header_tab 'Discussions', discussions_path 
 if current_user? 
 header_tab 'Following', following_discussions_path 
 header_tab 'Favorites', favorites_discussions_path 
 if current_user.unread_conversations? 
 header_tab(
                "Conversations (#{current_user.unread_conversations_count})",
                conversations_path,
                section: :conversations,
                class:   'new'
              )
            
 else 
 header_tab 'Conversations', conversations_path 
 end 
 end 
 header_tab 'Users', online_users_path 
 if current_user? && (current_user.invites? || current_user.available_invites?) 
 if !current_user.user_admin? && current_user.available_invites? 
 header_tab(
                "Invites (#{current_user.available_invites})",
                invites_path,
                section: :invites
              )
            
 else 
 header_tab 'Invites', invites_path 
 end 
 end 
 end 
 if flash[:notice] 
 raw flash[:notice] 
 end 
 if content_for?(:sidebar) 
 yield :sidebar 
 end 

  add_body_class "admin configuration"
  @page_title = t('configuration.configuration')

 link_to t('admin'), admin_path 
 link_to t('configuration.configuration'), admin_configuration_path 
 t('configuration.general_settings') 
 t('configuration.themes') 
 t('configuration.services_and_integration') 
 t('configuration.customization') 
 form_for Sugar.config, url: admin_configuration_path, method: :patch, builder: Sugar::FormBuilder do |f| 
 t('configuration.forum_name') 
 f.labelled_text_field :forum_name, size: 48 
 f.labelled_text_field :forum_title, size: 48, description: t('configuration.forum_title_description') 
 f.labelled_text_field :forum_short_name, size: 10, description: t('configuration.forum_short_name_description') 
 t('configuration.domain_and_email') 
 f.labelled_text_field :domain_names, size: 48, description: t('configuration.domain_names_description') 
 f.labelled_text_field :mail_sender, size: 48, description: t('configuration.mail_sender_description') 
 t('configuration.login_and_signup') 
 t('configuration.access_control') 
 f.radio_button :public_browsing, true 
 t('configuration.anyone_can_browse') 
 f.radio_button :public_browsing, false 
 t('configuration.browsing_requires_login') 
 t('configuration.signing_up') 
 f.radio_button :signups_allowed, true 
 t('configuration.users_can_sign_up') 
 f.radio_button :signups_allowed, false 
 t('configuration.users_must_be_invited') 
 t('configuration.themes') 
 f.labelled_select :default_theme, Theme.all.map{|t| [t.full_name, t.id]} 
 f.labelled_select :default_mobile_theme, Theme.mobile.map{|t| [t.full_name, t.id]} 
 t('configuration.google_analytics') 
 f.labelled_text_field :google_analytics, description: t('configuration.google_analytics_description') 
 t('configuration.facebook') 
 t('configuration.facebook_description', link: link_to(t('configuration.facebook_apps_link'), 'http://www.facebook.com/developers')).html_safe 
 f.labelled_text_field :facebook_app_id, size: 48 
 f.labelled_text_field :facebook_api_secret, size: 48 
 t('configuration.amazon_aws') 
 t('configuration.amazon_aws_description', link: link_to(t('configuration.amazon_signup_link'), 'http://aws.amazon.com/s3/')).html_safe 
 f.labelled_text_field :amazon_aws_key, size: 48 
 f.labelled_text_field :amazon_aws_secret, size: 48 
 f.labelled_text_field :amazon_s3_bucket, size: 48 
 t('configuration.amazon_associates') 
 f.labelled_text_field :amazon_associates_id, description: t('configuration.amazon_associates_id_description') 
 t('configuration.emoticons') 
 f.labelled_text_field :emoticons, size: 48 
 t('configuration.custom_html') 
 f.labelled_text_area :custom_header, size: '40x15', class: 'code', description: t('configuration.custom_header_description') 
 f.labelled_text_area :custom_footer, size: '40x15', class: 'code', description: t('configuration.custom_footer_description') 
 t('configuration.custom_javascript') 
 t('configuration.custom_javascript_info').html_safe 
 f.labelled_text_area :custom_javascript, size: '40x15', class: 'code' 
 t('save') 
 end 
 if mobile_user_agent? 
 link_to "mobile version", mobile_format: 'mobile' 
 end 
 if Sugar.config.custom_footer 
 raw Sugar.config.custom_footer 
 end 
 javascript_include_tag "application" 
 frontend_configuration.to_json.html_safe 
 unless Sugar.config.custom_javascript.blank? 
 raw Sugar.config.custom_javascript 
 end 
 if @posts && @posts.any? 
 end 
 if @google_maps_api 
 end 
 if Sugar.config.google_analytics 
 Sugar.config.google_analytics 
 end 

end

  end

  def update
    @configuration.update(configuration_params) if configuration_params
    redirect_to edit_admin_configuration_url
  end

  protected

  def configuration_params
    params[:configuration]
  end

  def find_configuration
    @configuration = Sugar.config
  end
end
