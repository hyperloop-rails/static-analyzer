class ArchivesController < ApplicationController
  def index
    @months = Post.find_all_grouped_by_month
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 html_title archives_title 
 csrf_meta_tag 
 stylesheet_link_tag 'application' 
 javascript_include_tag 'application' 
 open_id_delegation_link_tags(enki_config[:open_id_delegation, :server], enki_config[:open_id_delegation, :delegate]) if enki_config[:open_id_delegation] 
 yield(:head) 
 root_url 
 enki_config[:title] 
  
 if @months.empty? 
 else 
 @months.each do |month| 
 format_month(month.date) 
 month.posts.each do |post| 
 link_to(post.title, post_path(post)) 
 unless post.tags.empty? 
 linked_tag_list(post.tags) 
 end 
 end 
 end 
 end 
 page_links_for_navigation.each do |link| 
 link_to(link.name, link.url) 
 end 
 unless category_links_for_navigation.empty? 
 category_links_for_navigation.each do |link| 
 link_to(link.name, link.url) 
 end 
 end 
 enki_config[:url] 
 enki_config[:title] 
 enki_config[:author, :name] 
 link_to "ATOM", "http://feedvalidator.org/check.cgi?url=#{enki_config[:url]}/posts.atom" 

end

  end
end
