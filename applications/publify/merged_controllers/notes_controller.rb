class NotesController < ContentController
  require 'json'

  layout :theme_layout
  cache_sweeper :blog_sweeper
  caches_page :index, :show, if: proc { |c| c.request.query_string == '' }

  after_action :set_blog_infos

  def index
    @notes = Note.published.page(params[:page]).per(this_blog.limit_article_display)

    if @notes.empty?
      @message = I18n.t('errors.no_notes_found')
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @message 

end

    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 for note in @notes 
 note.html(:body) 
 link_to_permalink(note, display_date_and_time(note.published_at)) 
 end 
 paginate @notes, :next_label => "#{t(".next_page")} &raquo;", :previous_label => "&laquo; #{t('.previous_page')}" 

end

  end

  def show
    @note = Note.published.find_by_permalink(CGI.escape(params[:permalink]))

    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("errors.page_not_found") 
 t("errors.the_page_you_are_looking_for") 

end
 @note

    if @note.in_reply_to_message.present?
      @reply = JSON.parse(@note.in_reply_to_message)
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 image_tag(@reply['user']['profile_image_url'] , class: "alignleft", alt: @reply['user']['name']) 
 get_reply_context_url(@reply) 
 nofollowify_links(PublifyApp::Textfilter::Twitterfilter.filtertext(nil,nil,@reply['text'],nil)) 
 get_reply_context_twitter_link(@reply) 
  author_picture note 
 note.html(:body) 
 link_to_permalink(note, display_date_and_time(note.published_at)) 
 link_to note.redirect.from_url, note.redirect.from_url 
 author_link note 
 unless note.twitter_id.blank? 
  " | #{link_to(t(".view_on_twitter"), note.twitter_url, {class: 'u-syndication', rel: 'syndication'})}" 
 end 
 

end

    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
  author_picture note 
 note.html(:body) 
 link_to_permalink(note, display_date_and_time(note.published_at)) 
 link_to note.redirect.from_url, note.redirect.from_url 
 author_link note 
 unless note.twitter_id.blank? 
  " | #{link_to(t(".view_on_twitter"), note.twitter_url, {class: 'u-syndication', rel: 'syndication'})}" 
 end 
 

end

  end

  private

  def set_blog_infos
    @keywords = this_blog.meta_keywords
    @page_title = this_blog.statuses_title_template.to_title(@notes, this_blog, params)
    @description = this_blog.statuses_desc_template.to_title(@notes, this_blog, params)
  end
end
