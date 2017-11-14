module Shoppe
  class SessionsController < Shoppe::ApplicationController
    layout 'shoppe/sub'
    skip_before_filter :login_required, only: [:new, :create]

    def create
      if user = Shoppe::User.authenticate(params[:email_address], params[:password])
        session[:shoppe_user_id] = user.id
        redirect_to :orders
      else
        flash.now[:alert] = t('shoppe.sessions.create_alert')
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag 'shoppe/application' 
 javascript_include_tag 'shoppe/application' 
 csrf_meta_tags 
 link_to "Shoppe", root_path 
 t('.logged_in_as', user_name: current_user.full_name) 
 for item in Shoppe::NavigationManager.find(:admin_primary).items 
 navigation_manager_link item 
 end 
 link_to t('.logout'), [:logout], :method => :delete 
 yield :header 
 display_flash 
 @page_title =  t('shoppe.sessions.admin_login') 
 display_flash 
 form_tag :login, :class => 'login' do 
 text_field_tag 'email_address', params[:email_address], :class => 'focus', :placeholder => t('shoppe.sessions.email') 
 password_field_tag 'password', params[:password], :class => '', :placeholder =>  t('shoppe.sessions.password') 
 submit_tag t('shoppe.sessions.login'), :class => 'button green' 
 link_to t('shoppe.sessions.reset_password?'), login_reset_path 
 end 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
    end

    def destroy
      session[:shoppe_user_id] = nil
      redirect_to :login
    end
  end
end
