# encoding: utf-8
class RedactionController < ApplicationController
  before_action :authenticate_account!
  append_view_path NoNamespaceResolver.new

  def index
    @boards = Board.all(Board.writing)
    @board  = @boards.build
    @drafts = News.draft.sorted
    @news   = News.candidate.sorted
    @stats  = Statistics::Redaction.new
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
  link_to "tes-vous inscrit  la liste de diffusion des rdacteurs ?", "/news/une-liste-de-diffusion-pour-les-redacteurs-de-linuxfr-org" 
 link_to "Avez-vous lu la page d'aide  la rdaction ?", "/wiki/redaction" 
 h1 "Tribune rdacteurs" 
  board = boards.build 
 Push.private_key(board.meta) 
 if current_account && current_account.can_post_on_board? 
  form_tag "/board", class: 'chat' do 
 hidden_field :board, :object_type, value: form.object_type 
 hidden_field :board, :object_id, value: form.object_id 
 text_field :board, :message, value: '', size: 80, autocomplete: 'off', required: 'required', spellcheck: 'true', autofocus: (form.object_type == Board.free) 
 submit_tag 'Envoyer', class: "submit_board" 
 end 
 
 end 
  board.id 
 board.user_agent 
 board.created_at.iso8601 
 norloge(board, box) 
 board.user_link 
 board.message 
 
 
 list_of @stats.top_month do |stat| 
 end 
 link_to "Autres statistiques sur la rdaction", "/statistiques/redaction" 
 feed "Flux atom des dpches en cours de rdaction", "/redaction/news.atom" 
 button_to "Commencer une nouvelle dpche", "/redaction/news", class: "create_news" 
 link_to "Rgles de modration", "/regles_de_moderation" 
 if @drafts.empty? 
 else 
 link_to "Afficher toutes les dpches", "/redaction/news" 
 list_of @drafts do |n| 
 if n.node.board_status(current_account) == :new_board 
 image_tag "/images/icones/chat.svg", alt: "Nouveaux !", title: "Il y a de l'activit sur cette dpche", width: "16px" 
 end 
 link_to n.title, [:redaction, n] 
 end 
 end 
 feed "Flux atom des dpches en cours de modration", "/redaction/news/moderation.atom" 
 if @news.empty? 
 else 
 list_of @news do |n| 
 n.title 
 end 
 end 
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
end
