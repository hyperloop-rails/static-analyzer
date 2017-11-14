# encoding: UTF-8
class Admin::AccountsController < AdminController
  before_action :load_account, except: [:index]

  def index
    accounts = Account
    if params[:login].present?
      @login = params[:login]
      accounts = accounts.where("login LIKE ? COLLATE UTF8_GENERAL_CI", "#{@login}%")
    end
    if params[:date].present?
      @date = params[:date]
      accounts = accounts.where("created_at LIKE ?", "#{@date}%")
    end
    @accounts = accounts.order("created_at DESC").page(params[:page])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  @title.join(' - ').html_safe 
 if current_stylesheet 
 stylesheet_link_tag current_stylesheet, media: nil 
 elsif current_account 
 stylesheet_link_tag current_account.stylesheet_url, media: nil 
 else 
 stylesheet_link_tag 'application', media: nil 
 end 
 if @google_plus 
 end 
 if @author 
 end 
 if @dont_index 
 end 
 @feeds.each do |link,title| 
 auto_discovery_link_tag :atom, link, { title: title } 
 end 
 
  ("active" if controller_name == "home") 
 link_to "Accueil", '/', title: "Page d'accueil du site, personnalisable" 
 ("active" if controller_name == "news" || controller_name == "sections") 
 link_to "Dpches", '/news', title: "Actualits, vnements et autres nouveauts" 
 ("active" if controller_name == "forums" || controller_name == "posts") 
 link_to "Forums", '/forums', title: "Questions/rponses, petites annonces" 
 ("active" if controller_name == "polls") 
 link_to "Sondages", '/sondages', title: "Sondages proposes aux visiteurs du site" 
 ("active" if controller_name == "wiki_pages" || controller_name == "wiki_versions") 
 link_to "Wiki", '/wiki', title: "Pages wiki" 
 ("active" if controller_name == "trackers") 
 link_to "Suivi", '/suivi', title: "Suivi des suggestions et des bugs du site" 
 form_tag '/recherche', method: :get do 
 submit_tag "Rechercher", name: nil, id: "search_submit", title: "Lancer la recherche sur le site" 
 end 
 
  logo 
 account_signed_in? ? link_to(current_account.login, current_account.user) : "Se connecter" 
 link_to "Proposer un contenu", '/proposer-un-contenu' 
 if account_signed_in? 
 if current_account.has_answers? 
 image_tag "/images/icones/chat.svg", alt: "Nouveaux !", title: "Vous avez reu des rponses  vos commentaires", width: "16px" 
 end 
 link_to "Mon tableau de bord", '/tableau-de-bord' 
 link_to "Mes contenus taggs", '/tags' 
 link_to "Les contenus que j'ai lus", '/readings' 
 link_to "Modifier mes prfrences", '/compte/modifier' 
 link_to "Changer de style", '/stylesheet/modifier' 
 button_to "Se dconnecter", '/compte/deconnexion', method: :post, id: "logout" 
 else 
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
 if current_account 
  link_to "Rdaction", '/redaction' 
 link_to "Tribune de rdaction", '/redaction' 
 list_of News.draft.sorted.limit(10) do |news| 
 if news.node.board_status(current_account) == :new_board 
 image_tag "/images/icones/chat.svg", alt: "Nouveaux !", title: "Il y a de l'activit sur cette dpche", width: "16px" 
 end 
 link_to news.title, [:redaction, news] 
 end 
 link_to "(...)", "/redaction#news" 
 
 end 
 yield :column 
 
 [:alert, :notice].each do |type| 
 if flash[type] 
 end 
 end 
  h1 "Les derniers comptes utilisateurs crs" 
 form_tag admin_accounts_path, method: :get do 
 end 
 @accounts.each do |account| 
 link_to account.login, account.user 
 account.email 
 account.karma 
 account.current_sign_in_ip 
 account.inactive? ? "Inactif" : "Actif" 
 account.created_at.to_s(:posted) 
 if account.inactive? && account.user_id != 1 
 button_to "Activer",   [:admin, account], method: :put, class: "ok_button" 
 elsif !account.inactive? 
 button_to "Renvoi mot de passe", password_admin_account_path(account), class: "reset_password" 
 button_to "Suspendre", [:admin, account], method: :put, class: "delete_button" 
 end 
 if account.editor? 
 button_to "Retour simple visiteur", admin_account_editor_path(account.id), method: :delete 
 elsif account.moderator? 
 button_to "Retour simple visiteur", admin_account_moderator_path(account.id), method: :delete 
 elsif account.admin? 
 button_to "Retour simple visiteur", admin_account_admin_path(account.id), method: :delete 
 elsif !account.inactive? 
 button_to " modrateur", admin_account_moderator_path(account.id) 
 button_to " animateur", admin_account_editor_path(account.id) 
 button_to " admin", admin_account_admin_path(account.id) 
 end 
 end 
 paginate @accounts 
 link_to "Revenir en haut de page", '#top', class: 'scroll' 
 cache "layouts/footer", expires_in: 1.minute do 
  @last_comments.each do |comment| 
 link_to comment.title, path_for_content(comment.node.content) + "#comment-#{comment.id}" 
 end 
 @popular_tags.each do |tag| 
 link_to tag.name, "/tags/#{tag.name}/public" 
 end 
 @friend_sites.each do |site| 
 link_to site.title, site.url 
 end 
 link_to "Mentions lgales", '/mentions_legales' 
 link_to "Faire un don", '/faire_un_don' 
 link_to "Team LinuxFr.org", '/team' 
 link_to "Informations sur le site", '/informations' 
 link_to "Aide / Foire aux questions", '/aide' 
 link_to "Rgles de modration", '/regles_de_moderation' 
 link_to "Statistiques", '/statistiques' 
 link_to "API pour les dveloppeurs", '/developpeur' 
 link_to "Code source du site", '/code_source_du_site' 
 link_to "Plan du site", '/plan' 
 
 end 
 javascript_include_tag "application" 

end

  end

  def password
    @account.send_reset_password_instructions
    redirect_to admin_accounts_url, notice: "Instructions pour changer le mot de passe envoyées"
  end

  def karma
    nb = params[:karma] || 50
    @account.give_karma nb
    @account.log_karma nb, current_account
    redirect_to @account.user
  end

  def update
    if @account.inactive?
      @account.reactivate!
      redirect_to :back, notice: "Compte réactivé"
    else
      @account.inactivate!
      redirect_to :back, notice: "Compte désactivé"
    end
  end

  def destroy
    @account.inactivate!
    redirect_to admin_accounts_url, notice: "Compte désactivé"
  end

protected

  def load_account
    @account = Account.find(params[:id])
    @account.amr_id = current_user.id
  end

end
