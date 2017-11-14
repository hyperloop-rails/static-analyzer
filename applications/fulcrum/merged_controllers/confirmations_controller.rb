class ConfirmationsController < Devise::ConfirmationsController

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.valid? && resource.errors.empty?
      set_flash_message :notice, :confirmed
      reset_token = resource.set_reset_password_token
      redirect_to edit_user_password_path(:reset_password_token => reset_token)
    else
      set_flash_message :notice, :invalid_token
      redirect_to new_user_confirmation_path
    end
  end

  # GET /resource/confirmation/new
  def new
    self.resource = resource_class.new
  end

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(params[resource_name])

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions
      redirect_to new_session_path(resource_name)
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :title_bar do 
 end 
 form_for(resource, :as => resource_name, :url => confirmation_path(resource_name), :html => { :method => :post }) do |f| 
 devise_error_messages! 
 f.label :email 
 f.email_field :email 
 f.submit "Resend confirmation instructions" 
 end 
  if controller_name != 'sessions' 
 link_to "Sign in", new_session_path(resource_name) 
 end 
 unless Fulcrum::Application.config.fulcrum.disable_registration 
 if devise_mapping.registerable? && controller_name != 'registrations' 
 link_to "Sign up", new_registration_path(resource_name) 
 end 
 end 
 if devise_mapping.recoverable? && controller_name != 'passwords' 
 link_to "Forgot your password?", new_password_path(resource_name) 
 end 
 if devise_mapping.confirmable? && controller_name != 'confirmations' 
 link_to "Didn't receive confirmation instructions?", new_confirmation_path(resource_name) 
 end 
 if devise_mapping.lockable? && resource_class.unlock_strategy_enabled?(:email) && controller_name != 'unlocks' 
 link_to "Didn't receive unlock instructions?", new_unlock_path(resource_name) 
 end 
 if devise_mapping.omniauthable? 
 resource_class.omniauth_providers.each do |provider| 
 link_to "Sign in with #{provider.to_s.titleize}", omniauth_authorize_path(resource_name, provider) 
 end 
 end 
 

end

    end
  end

end
