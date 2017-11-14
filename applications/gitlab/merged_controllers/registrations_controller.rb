class RegistrationsController < Devise::RegistrationsController
  before_action :signup_enabled?
  include Recaptcha::Verify

  def new
    redirect_to(new_user_session_path)
  end

  def create
    if !Gitlab::Recaptcha.load_configurations! || verify_recaptcha
      # To avoid duplicate form fields on the login page, the registration form
      # names fields using `new_user`, but Devise still wants the params in
      # `user`.
      if params["new_#{resource_name}"].present? && params[resource_name].blank?
        params[resource_name] = params.delete(:"new_#{resource_name}")
      end

      super
    else
      flash[:alert] = "There was an error with the reCAPTCHA code below. Please re-enter the code."
      flash.delete :recaptcha_error
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_title    'New Group' 
 header_title  "Groups", dashboard_groups_path 
 form_for @group, html: { class: 'group-form form-horizontal' } do |f| 
 form_errors(@group) 
  if @group.persisted? 
 f.label :name, class: 'control-label' do 
 end 
 f.text_field :name, placeholder: 'open-source', class: 'form-control' 
 end 
 f.label :path, class: 'control-label' do 
 end 
 root_url 
 f.text_field :path, placeholder: 'open-source', class: 'form-control',          autofocus: local_assigns[:autofocus] || false 
 if @group.persisted? 
 end 
 f.label :description, class: 'control-label' 
 f.text_area :description, maxlength: 250,        class: 'form-control js-gfm-input', rows: 4 
 
 f.label :avatar, "Group avatar", class: 'control-label' 
  f.file_field :avatar, class: 'js-group-avatar-input hidden' 
 
  f.label :visibility_level, class: 'control-label' do 
 link_to "(?)", help_page_path("public_access", "public_access") 
 end 
 if can_change_visibility_level 
  Gitlab::VisibilityLevel.values.each do |level| 
 next if skip_level?(form_model, level) 
 restricted = restricted_visibility_levels.include?(level) 
 form.label "_" do 
 form.radio_button model_method, level, checked: (selected_level == level), disabled: restricted 
 visibility_level_icon(level) 
 visibility_level_label(level) 
 visibility_level_description(level, form_model) 
 end 
 end 
 unless restricted_visibility_levels.empty? 
 end 
 
 else 
 visibility_level_icon(visibility_level) 
 visibility_level_label(visibility_level) 
 visibility_level_description(visibility_level, form_model) 
 end 
 
  
 f.submit 'Create group', class: "btn btn-create", tabindex: 3 
 link_to 'Cancel', dashboard_groups_path, class: 'btn btn-cancel' 
 end 

end

    end
  end

  def destroy
    DeleteUserService.new(current_user).execute(current_user)

    respond_to do |format|
      format.html { redirect_to new_user_session_path, notice: "Account successfully removed." }
    end
  end

  protected

  def build_resource(hash=nil)
    super
  end

  def after_sign_up_path_for(_resource)
    users_almost_there_path
  end

  def after_inactive_sign_up_path_for(_resource)
    users_almost_there_path
  end

  private

  def signup_enabled?
    unless current_application_settings.signup_enabled?
      redirect_to(new_user_session_path)
    end
  end

  def sign_up_params
    params.require(:user).permit(:username, :email, :name, :password, :password_confirmation)
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new(sign_up_params)
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
