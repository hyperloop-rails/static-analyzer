module Shoppe
  class UsersController < Shoppe::ApplicationController
    before_filter { @active_nav = :users }
    before_filter { params[:id] && @user = Shoppe::User.find(params[:id]) }
    before_filter(only: [:create, :update, :destroy]) do
      if Shoppe.settings.demo_mode?
        fail Shoppe::Error, t('shoppe.users.demo_mode_error')
      end
    end

    def index
      @users = Shoppe::User.all
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
 link_to t('shoppe.users.new_user'), :new_user, :class => 'button green' 
 t('shoppe.users.users') 
 display_flash 
 @page_title = t('shoppe.users.users') 
  
 t('shoppe.users.name') 
 t('shoppe.users.email') 
 for user in @users 
 link_to user.full_name, [:edit, user] 
 user.email_address 
 end 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def new
      @user = Shoppe::User.new
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
 link_to t('shoppe.users.back_to_users'), :users, :class => 'button' 
 t('shoppe.users.users') 
 display_flash 
 @page_title = t('shoppe.users.users') 
  
  form_for @user do |f| 
 f.error_messages 
 field_set_tag t('shoppe.users.user_details') do 
 f.label :first_name, t('shoppe.users.first_name') 
 f.text_field :first_name, :class => 'focus text' 
 f.label :last_name, t('shoppe.users.last_name') 
 f.text_field :last_name, :class => 'text' 
 end 
 field_set_tag t("shoppe.users.login") do 
 f.label :email_address, t('shoppe.users.email') 
 f.text_field :email_address, :class => 'text' 
 f.label :password, t('shoppe.users.password') 
 f.password_field :password, :class => 'text' 
 f.label :password_confirmation, t('shoppe.users.password_confirmation') 
 f.password_field :password_confirmation, :class => 'text' 
 end 
 unless @user.new_record? 
 link_to t('shoppe.delete'), @user, :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.users.delete_confirmation')} 
 end 
 f.submit  t('shoppe.submit'), :class => 'button green' 
 link_to t('shoppe.cancel'), :users, :class => 'button' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def create
      @user = Shoppe::User.new(safe_params)
      if @user.save
        redirect_to :users, flash: { notice: t('shoppe.users.create_notice') }
      else
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
 link_to t('shoppe.users.back_to_users'), :users, :class => 'button' 
 t('shoppe.users.users') 
 display_flash 
 @page_title = t('shoppe.users.users') 
  
  form_for @user do |f| 
 f.error_messages 
 field_set_tag t('shoppe.users.user_details') do 
 f.label :first_name, t('shoppe.users.first_name') 
 f.text_field :first_name, :class => 'focus text' 
 f.label :last_name, t('shoppe.users.last_name') 
 f.text_field :last_name, :class => 'text' 
 end 
 field_set_tag t("shoppe.users.login") do 
 f.label :email_address, t('shoppe.users.email') 
 f.text_field :email_address, :class => 'text' 
 f.label :password, t('shoppe.users.password') 
 f.password_field :password, :class => 'text' 
 f.label :password_confirmation, t('shoppe.users.password_confirmation') 
 f.password_field :password_confirmation, :class => 'text' 
 end 
 unless @user.new_record? 
 link_to t('shoppe.delete'), @user, :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.users.delete_confirmation')} 
 end 
 f.submit  t('shoppe.submit'), :class => 'button green' 
 link_to t('shoppe.cancel'), :users, :class => 'button' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
    end

    def edit
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
 link_to t('shoppe.users.back_to_users'), :users, :class => 'button' 
 t('shoppe.users.users') 
 display_flash 
 @page_title = t('shoppe.users.users') 
  
  form_for @user do |f| 
 f.error_messages 
 field_set_tag t('shoppe.users.user_details') do 
 f.label :first_name, t('shoppe.users.first_name') 
 f.text_field :first_name, :class => 'focus text' 
 f.label :last_name, t('shoppe.users.last_name') 
 f.text_field :last_name, :class => 'text' 
 end 
 field_set_tag t("shoppe.users.login") do 
 f.label :email_address, t('shoppe.users.email') 
 f.text_field :email_address, :class => 'text' 
 f.label :password, t('shoppe.users.password') 
 f.password_field :password, :class => 'text' 
 f.label :password_confirmation, t('shoppe.users.password_confirmation') 
 f.password_field :password_confirmation, :class => 'text' 
 end 
 unless @user.new_record? 
 link_to t('shoppe.delete'), @user, :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.users.delete_confirmation')} 
 end 
 f.submit  t('shoppe.submit'), :class => 'button green' 
 link_to t('shoppe.cancel'), :users, :class => 'button' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def update
      if @user.update(safe_params)
        redirect_to [:edit, @user], flash: { notice: t('shoppe.users.update_notice') }
      else
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
 link_to t('shoppe.users.back_to_users'), :users, :class => 'button' 
 t('shoppe.users.users') 
 display_flash 
 @page_title = t('shoppe.users.users') 
  
  form_for @user do |f| 
 f.error_messages 
 field_set_tag t('shoppe.users.user_details') do 
 f.label :first_name, t('shoppe.users.first_name') 
 f.text_field :first_name, :class => 'focus text' 
 f.label :last_name, t('shoppe.users.last_name') 
 f.text_field :last_name, :class => 'text' 
 end 
 field_set_tag t("shoppe.users.login") do 
 f.label :email_address, t('shoppe.users.email') 
 f.text_field :email_address, :class => 'text' 
 f.label :password, t('shoppe.users.password') 
 f.password_field :password, :class => 'text' 
 f.label :password_confirmation, t('shoppe.users.password_confirmation') 
 f.password_field :password_confirmation, :class => 'text' 
 end 
 unless @user.new_record? 
 link_to t('shoppe.delete'), @user, :class => 'button purple', :method => :delete, :data => {:confirm => t('shoppe.users.delete_confirmation')} 
 end 
 f.submit  t('shoppe.submit'), :class => 'button green' 
 link_to t('shoppe.cancel'), :users, :class => 'button' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
    end

    def destroy
      fail Shoppe::Error, t('shoppe.users.self_remove_error') if @user == current_user
      @user.destroy
      redirect_to :users, flash: { notice: t('shoppe.users.destroy_notice') }
    end

    private

    def safe_params
      params[:user].permit(:first_name, :last_name, :email_address, :password, :password_confirmation)
    end
  end
end
