class AuthorsController < ContentController
  layout :theme_layout

  def show
    @author = User.find_by_login(params[:id])
    raise ActiveRecord::RecordNotFound unless @author

    @articles = @author.articles.published.page(params[:page]).per(this_blog.per_page(params[:format]))
    @page_title = this_blog.author_title_template.to_title(@author, this_blog, params)
    @keywords = this_blog.meta_keywords
    @description = this_blog.author_desc_template.to_title(@author, this_blog, params)

    auto_discovery_feed(only_path: false)

    respond_to do |format|
      format.rss { render_feed 'rss' }
      format.atom { render_feed 'atom' }
      format.html
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @author.nickname 
 display_user_avatar(@author, 'thumb', 'alignright') 
 author_description @author 
 t(".contact_information") 
 display_profile_item @author.url, t(".web_site") 
 display_profile_item @author.msn, t(".msn") 
 display_profile_item @author.yahoo, t(".yahoo") 
 display_profile_item @author.jabber, t(".jabber") 
 display_profile_item @author.aim, t(".aim") 
 display_profile_item @author.twitter, t(".twitter") 
 if @articles.empty? 
 t(".this_author_has_not_published_any_article_yet")
 else
currentmonth = 0
currentyear = 0
for article in @articles
  if (article.published_at.month != currentmonth || article.published_at.year != currentyear)
    currentmonth = article.published_at.month
    currentyear = article.published_at.year 
 l(article.published_at, format: :letters_month_with_year) 
 end 
 article.published_at.mday 
 link_to_permalink(article,h(article.title)) 
 if !article.tags.empty? 
 t(".posted_in") 
 article.tags.collect {|c| link_to_permalink c,c.name }.join(", ") 
 end 
 end 
 paginate @articles, :next_label => "#{t(".next_page")} &raquo;", :previous_label => "&laquo; #{t('.previous_page')}" 
  end 

end

  end

  private

  def render_feed(format)
    render "show_#{format}_feed", layout: false
  end
end
