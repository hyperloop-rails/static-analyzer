# encoding: UTF-8
class Moderation::NewsController < ModerationController
  before_action :find_news, except: [:index]
  after_action  :expire_cache, only: [:update, :accept]
  after_action  :marked_as_read, only: [:show, :update, :vote]
  respond_to :html, :md

  def index
    @news    = News.candidate.sorted
    @drafts  = News.draft.sorted
    @refused = News.refused.order("updated_at DESC").limit(15)
    @polls   = Poll.draft
    @boards  = Board.all(Board.amr)
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
  h1 "Modration" 
 if @news.empty? 
 else 
 list_of(@news) do |news| 
 link_to news.title, [:moderation, news] 
 end 
 end 
 if @drafts.empty? 
 else 
 list_of(@drafts) do |news| 
 link_to news.title, [:redaction, news] 
 end 
 end 
 list_of(@refused) do |news| 
 link_to news.title, [:moderation, news] 
 end 
 link_to "Images externes", moderation_images_path 
 link_to "Sondages", moderation_polls_path 
 if @polls.empty? 
 else 
 list_of(@polls) do |poll| 
 link_to poll.title, [:moderation, poll] 
 end 
 end 
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

  def show
    enforce_view_permission(@news)
    path = moderation_news_path(@news, format: params[:format])
    redirect_to path, status: 301 and return if request.path != path
    @boards = Board.all(Board.news, @news.id)
    headers["Cache-Control"] = "no-cache, no-store, must-revalidate, max-age=0"
    flash.now[:alert] = "Attention, cette dépêche a été supprimée et n'est visible que par les modérateurs" if @news.deleted?
    flash.now[:alert] = "Attention, cette dépêche a été refusée et n'est visible que par les modérateurs" if @news.refused?
    respond_to do |wants|
      wants.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 title @news.title 
 content_for :chat do 
  if @news.urgent? 
 end 
 @news.voters_for 
 @news.voters_against 
 if current_account.can_vote?(@news) 
 button_to "Pour", "/nodes/#{@news.node.id}/vote/for", remote: true, class: "vote_for" 
 button_to "Contre", "/nodes/#{@news.node.id}/vote/against", remote: :true, class: "vote_against" 
 end 
 if @news.published? 
 if @news.on_ppp? 
 elsif current_account.can_ppp?(@news) 
 button_to "Mettre en phare", ppp_moderation_news_path(@news), class: "ppp_news" 
 end 
 elsif @news.refused? 
 else 
 if @news.acceptable? && current_account.can_accept?(@news) 
 button_to "Publier", accept_moderation_news_path(@news), class: "publish_news" 
 elsif @news.refusable? && current_account.can_refuse?(@news) 
 button_to "Refuser", refuse_moderation_news_path(@news), class: "refuse_news" 
 if @news.node.cc_licensed? 
 button_to "Re-rdaction", rewrite_moderation_news_path(@news), class: "rewrite_news" 
 end 
 elsif current_account.admin? 
 button_to "Publier", accept_moderation_news_path(@news), class: "publish_news" 
 button_to "Refuser", refuse_moderation_news_path(@news), class: "refuse_news" 
 button_to "Revoter", reset_moderation_news_path(@news), class: "reset_news" 
 if @news.node.cc_licensed? 
 button_to "Re-rdaction", rewrite_moderation_news_path(@news), class: "rewrite_news" 
 end 
 end 
 end 
 
 end 
 if @news.paragraphs.any? 
 article_for @news do |c| 
 c.title = capture do 
 render partial: 'short' 
 end 
 c.meta  = news_posted_by(@news) 
 c.image = link_to(image_tag(@news.section.image, alt: @news.section.title), @news.section) 
 c.body  = capture do 
  paragraph.body 
 user_id = paragraph.locked_by 
 if user_id && user_id.to_i != current_account.user_id 
 u = User.find(user_id) 
 u.name 
 paragraph.id 
 u.avatar_url 
 u.name 
 end 
 
 end 
 end 
 link_to "Rorganiser", reorganize_redaction_news_path(@news), class: "reorganize" 
 if @news.urgent? 
 button_to "Enlever l'urgence", cancel_urgent_redaction_news_path(@news), class: "urgent_news" 
 else 
 button_to "Marquer comme urgent", urgent_redaction_news_path(@news), class: "urgent_news", data: { confirm: "Cette dpche est urgente et doit tre publie au plus tt ?" } 
 end 
 else 
 form_for [:moderation, @news] do |form| 
 form.label :title, "Titre de la dpche" 
 form.text_field :title, autocomplete: 'off', required: 'required', spellcheck: 'true' 
 form.label :section_id, "Section de la dpche" 
 form.collection_select :section_id, Section.published, :id, :title 
 form.label :body, "Contenu de la dpche (<strong>HTML, pas de syntaxe wiki</strong>)".html_safe 
 form.text_area :body, required: 'required', spellcheck: 'true', class: 'markItUp' 
 form.fields_for :links do |lform| 
 lform.text_field :title 
 lform.url_field :url 
 lform.select :lang, Lang.all 
 end 
 form.label :second_part, "Seconde partie" 
 form.text_area :second_part, spellcheck: 'true', class: 'markItUp' 
 form.submit "Enregistrer" 
 end 
 end 
 image_tag "/images/icones/edit-cut.png", alt: "Suggestion de dcoupe" 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 

end
 }
      wants.js { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
  title @news.title 
 content_for :chat do 
  if @news.urgent? 
 end 
 @news.voters_for 
 @news.voters_against 
 if current_account.can_vote?(@news) 
 button_to "Pour", "/nodes/#{@news.node.id}/vote/for", remote: true, class: "vote_for" 
 button_to "Contre", "/nodes/#{@news.node.id}/vote/against", remote: :true, class: "vote_against" 
 end 
 if @news.published? 
 if @news.on_ppp? 
 elsif current_account.can_ppp?(@news) 
 button_to "Mettre en phare", ppp_moderation_news_path(@news), class: "ppp_news" 
 end 
 elsif @news.refused? 
 else 
 if @news.acceptable? && current_account.can_accept?(@news) 
 button_to "Publier", accept_moderation_news_path(@news), class: "publish_news" 
 elsif @news.refusable? && current_account.can_refuse?(@news) 
 button_to "Refuser", refuse_moderation_news_path(@news), class: "refuse_news" 
 if @news.node.cc_licensed? 
 button_to "Re-rdaction", rewrite_moderation_news_path(@news), class: "rewrite_news" 
 end 
 elsif current_account.admin? 
 button_to "Publier", accept_moderation_news_path(@news), class: "publish_news" 
 button_to "Refuser", refuse_moderation_news_path(@news), class: "refuse_news" 
 button_to "Revoter", reset_moderation_news_path(@news), class: "reset_news" 
 if @news.node.cc_licensed? 
 button_to "Re-rdaction", rewrite_moderation_news_path(@news), class: "rewrite_news" 
 end 
 end 
 end 
 
 end 
 if @news.paragraphs.any? 
 article_for @news do |c| 
 c.title = capture do 
 render partial: 'short' 
 end 
 c.meta  = news_posted_by(@news) 
 c.image = link_to(image_tag(@news.section.image, alt: @news.section.title), @news.section) 
 c.body  = capture do 
  paragraph.body 
 user_id = paragraph.locked_by 
 if user_id && user_id.to_i != current_account.user_id 
 u = User.find(user_id) 
 u.name 
 paragraph.id 
 u.avatar_url 
 u.name 
 end 
 
 end 
 end 
 link_to "Rorganiser", reorganize_redaction_news_path(@news), class: "reorganize" 
 if @news.urgent? 
 button_to "Enlever l'urgence", cancel_urgent_redaction_news_path(@news), class: "urgent_news" 
 else 
 button_to "Marquer comme urgent", urgent_redaction_news_path(@news), class: "urgent_news", data: { confirm: "Cette dpche est urgente et doit tre publie au plus tt ?" } 
 end 
 else 
 form_for [:moderation, @news] do |form| 
 form.label :title, "Titre de la dpche" 
 form.text_field :title, autocomplete: 'off', required: 'required', spellcheck: 'true' 
 form.label :section_id, "Section de la dpche" 
 form.collection_select :section_id, Section.published, :id, :title 
 form.label :body, "Contenu de la dpche (<strong>HTML, pas de syntaxe wiki</strong>)".html_safe 
 form.text_area :body, required: 'required', spellcheck: 'true', class: 'markItUp' 
 form.fields_for :links do |lform| 
 lform.text_field :title 
 lform.url_field :url 
 lform.select :lang, Lang.all 
 end 
 form.label :second_part, "Seconde partie" 
 form.text_area :second_part, spellcheck: 'true', class: 'markItUp' 
 form.submit "Enregistrer" 
 end 
 end 
 image_tag "/images/icones/edit-cut.png", alt: "Suggestion de dcoupe" 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 
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
 }
      wants.md { @news.put_paragraphs_together }
    end
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
  title @news.title 
 content_for :chat do 
  if @news.urgent? 
 end 
 @news.voters_for 
 @news.voters_against 
 if current_account.can_vote?(@news) 
 button_to "Pour", "/nodes/#{@news.node.id}/vote/for", remote: true, class: "vote_for" 
 button_to "Contre", "/nodes/#{@news.node.id}/vote/against", remote: :true, class: "vote_against" 
 end 
 if @news.published? 
 if @news.on_ppp? 
 elsif current_account.can_ppp?(@news) 
 button_to "Mettre en phare", ppp_moderation_news_path(@news), class: "ppp_news" 
 end 
 elsif @news.refused? 
 else 
 if @news.acceptable? && current_account.can_accept?(@news) 
 button_to "Publier", accept_moderation_news_path(@news), class: "publish_news" 
 elsif @news.refusable? && current_account.can_refuse?(@news) 
 button_to "Refuser", refuse_moderation_news_path(@news), class: "refuse_news" 
 if @news.node.cc_licensed? 
 button_to "Re-rdaction", rewrite_moderation_news_path(@news), class: "rewrite_news" 
 end 
 elsif current_account.admin? 
 button_to "Publier", accept_moderation_news_path(@news), class: "publish_news" 
 button_to "Refuser", refuse_moderation_news_path(@news), class: "refuse_news" 
 button_to "Revoter", reset_moderation_news_path(@news), class: "reset_news" 
 if @news.node.cc_licensed? 
 button_to "Re-rdaction", rewrite_moderation_news_path(@news), class: "rewrite_news" 
 end 
 end 
 end 
 
 end 
 if @news.paragraphs.any? 
 article_for @news do |c| 
 c.title = capture do 
 render partial: 'short' 
 end 
 c.meta  = news_posted_by(@news) 
 c.image = link_to(image_tag(@news.section.image, alt: @news.section.title), @news.section) 
 c.body  = capture do 
  paragraph.body 
 user_id = paragraph.locked_by 
 if user_id && user_id.to_i != current_account.user_id 
 u = User.find(user_id) 
 u.name 
 paragraph.id 
 u.avatar_url 
 u.name 
 end 
 
 end 
 end 
 link_to "Rorganiser", reorganize_redaction_news_path(@news), class: "reorganize" 
 if @news.urgent? 
 button_to "Enlever l'urgence", cancel_urgent_redaction_news_path(@news), class: "urgent_news" 
 else 
 button_to "Marquer comme urgent", urgent_redaction_news_path(@news), class: "urgent_news", data: { confirm: "Cette dpche est urgente et doit tre publie au plus tt ?" } 
 end 
 else 
 form_for [:moderation, @news] do |form| 
 form.label :title, "Titre de la dpche" 
 form.text_field :title, autocomplete: 'off', required: 'required', spellcheck: 'true' 
 form.label :section_id, "Section de la dpche" 
 form.collection_select :section_id, Section.published, :id, :title 
 form.label :body, "Contenu de la dpche (<strong>HTML, pas de syntaxe wiki</strong>)".html_safe 
 form.text_area :body, required: 'required', spellcheck: 'true', class: 'markItUp' 
 form.fields_for :links do |lform| 
 lform.text_field :title 
 lform.url_field :url 
 lform.select :lang, Lang.all 
 end 
 form.label :second_part, "Seconde partie" 
 form.text_area :second_part, spellcheck: 'true', class: 'markItUp' 
 form.submit "Enregistrer" 
 end 
 end 
 image_tag "/images/icones/edit-cut.png", alt: "Suggestion de dcoupe" 
  image_tag "/images/markdown.png", alt: "Markdown", title: "Ce site prend en charge la syntaxe Markdown", class: "markdown" 
 
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

  def edit
    enforce_update_permission(@news)
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
  form_for [:moderation, @news] do |form| 
 form.label :section_id, "Section" 
 form.collection_select :section_id, Section.published, :id, :title 
 form.label :title, "Titre" 
 form.text_field :title, autocomplete: 'off', required: 'required', spellcheck: 'true' 
 form.submit "OK" 
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

  def update
    enforce_update_permission(@news)
    @news.attributes = news_params
    @news.editor = current_account
    @news.save
    if request.xhr?
      render partial: 'short'
    else
      redirect_to @news, notice: "Modification enregistrée"
    end
  end

  def accept
    enforce_accept_permission(@news)
    if @news.unlocked?
      @news.moderator_id = current_user.id
      @news.accept!
      NewsNotifications.accept(@news).deliver
      redirect_to @news, alert: "Dépêche acceptée"
    else
      redirect_to [:moderation, @news], alert: "Impossible de modérer la dépêche tant que quelqu'un est en train de la modifier"
    end
  end

  def refuse
    enforce_refuse_permission(@news)
    if params[:message]
      @news.moderator_id = current_user.id
      @news.put_paragraphs_together
      @news.refuse!
      notif = NewsNotifications.refuse_with_message(@news, params[:message], params[:template])
      notif.deliver if notif
      redirect_to '/'
    elsif @news.unlocked?
      @boards = Board.all(Board.news, @news.id)
    else
      redirect_to [:moderation, @news], alert: "Impossible de modérer la dépêche tant que quelqu'un est train de la modifier"
    end
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
 
 [:alert, :notice].each do |type| 
 if flash[type] 
 end 
 end 
  h1 "Refuser une dpche" 
  
 form_tag refuse_moderation_news_path(@news) do 
 label_tag :template, 'Modle' 
 select_tag :template, options_from_collection_for_select(Response.all, 'id', 'title') 
 label_tag :message, 'Message personnalis qui sera ajout dans le corps du courriel' 
 text_area_tag :message, '', cols: 120, rows: 10 
 submit_tag "Refuser" 
 end 
 form_tag refuse_moderation_news_path(@news) do 
 text_area_tag :message, '', cols: 120, rows: 10 
 submit_tag "Refuser" 
 end 
 form_tag refuse_moderation_news_path(@news) do 
 hidden_field_tag :message, 'en' 
 submit_tag "Refuser" 
 end 
 form_tag refuse_moderation_news_path(@news) do 
 hidden_field_tag :message, 'no' 
 submit_tag "Refuser" 
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

  def rewrite
    enforce_rewrite_permission(@news)
    if @news.unlocked?
      @news.moderator_id = current_user.id
      @news.rewrite!
      NewsNotifications.rewrite(@news).deliver
      redirect_to @news, alert: "Dépêche renvoyée en rédaction"
    else
      redirect_to [:moderation, @news], alert: "Impossible de modérer la dépêche tant que quelqu'un est en train de la modifier"
    end
  end

  def reset
    enforce_reset_permission(@news)
    @news.reset_votes
    redirect_to [:moderation, @news], notice: "Votes remis à zéro"
  end

  def ppp
    enforce_ppp_permission(@news)
    @news.set_on_ppp
    redirect_to [:moderation, @news], notice: "Cette dépêche est maintenant affichée en phare"
  end

  def vote
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
  if @news.urgent? 
 end 
 @news.voters_for 
 @news.voters_against 
 if current_account.can_vote?(@news) 
 button_to "Pour", "/nodes/#{@news.node.id}/vote/for", remote: true, class: "vote_for" 
 button_to "Contre", "/nodes/#{@news.node.id}/vote/against", remote: :true, class: "vote_against" 
 end 
 if @news.published? 
 if @news.on_ppp? 
 elsif current_account.can_ppp?(@news) 
 button_to "Mettre en phare", ppp_moderation_news_path(@news), class: "ppp_news" 
 end 
 elsif @news.refused? 
 else 
 if @news.acceptable? && current_account.can_accept?(@news) 
 button_to "Publier", accept_moderation_news_path(@news), class: "publish_news" 
 elsif @news.refusable? && current_account.can_refuse?(@news) 
 button_to "Refuser", refuse_moderation_news_path(@news), class: "refuse_news" 
 if @news.node.cc_licensed? 
 button_to "Re-rdaction", rewrite_moderation_news_path(@news), class: "rewrite_news" 
 end 
 elsif current_account.admin? 
 button_to "Publier", accept_moderation_news_path(@news), class: "publish_news" 
 button_to "Refuser", refuse_moderation_news_path(@news), class: "refuse_news" 
 button_to "Revoter", reset_moderation_news_path(@news), class: "reset_news" 
 if @news.node.cc_licensed? 
 button_to "Re-rdaction", rewrite_moderation_news_path(@news), class: "rewrite_news" 
 end 
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

protected

  def news_params
    params.require(:news).permit(:title, :section_id, :wiki_body, :wiki_second_part, :body, :second_part,
                                 links_attributes: [Link::Accessible])
  end

  def find_news
    @news = News.find(params[:id])
  end

  def marked_as_read
    current_account.read(@news.node) unless params[:format] == "md"
  end

  def expire_cache
    return if @news.state == "candidate"
    expire_page controller: '/news', action: :index, format: :atom
  end
end
