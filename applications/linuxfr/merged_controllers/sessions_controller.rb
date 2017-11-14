# encoding: utf-8
class SessionsController < DeviseController
  prepend_before_action :allow_params_authentication!, only: [:create]
  prepend_before_action :require_no_authentication,    only: [:new, :create]
  skip_before_action    :verify_authenticity_token,    only: [:new, :create]

  def new
    session[:account_return_to] ||= url_for('/')
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @account ||= Account.new 
 form_for @account, url: '/compte/connexion', html: { id: "#{dom_id @account}#{id_suffix}" }, authenticity_token: false do |f| 
 f.label "login#{id_suffix}", "Identifiant" 
 f.text_field :login, id: "account_login#{id_suffix}", required: "required", placeholder: "Identifiant", size: 20 
 f.label "password#{id_suffix}", "Mot de passe" 
 f.password_field :password, id: "account_password#{id_suffix}", required: "required", placeholder: "Mot de passe", size: 20 
 f.check_box :remember_me, id: "account_remember_me#{id_suffix}" 
 f.label "remember_me#{id_suffix}", "Connexion automatique" 
 f.submit "Se connecter", id: "account_submit#{id_suffix}" 
 end 

end

  end

  def create
    cookies.permanent[:https] = { value: "1", secure: false } if request.ssl?
    @account = warden.authenticate!(scope: :account, recall: "#{controller_path}#new")
    sign_in :account, @account
    redirect_to stored_location_for(:account) || :back, notice: I18n.t("devise.sessions.signed_in")
  rescue ActionController::RedirectBackError
    redirect_to '/'
  end

  def destroy
    cookies.delete :https
    sign_out :account
    redirect_to "/"
  end
end
