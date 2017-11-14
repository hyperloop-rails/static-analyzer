class Admin::CommentsController < Admin::BaseController
  before_filter :find_comment, :only => [:show, :update, :destroy]

  def index
    @comments = Comment.paginate(:page => params[:page]).includes(:post).order("created_at DESC")
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 enki_config[:title] 
 csrf_meta_tag 
 javascript_include_tag 'admin' 
 stylesheet_link_tag 'admin' 
 yield(:head) 
 if flash[:notice] 
 javascript_tag do 
 escape_javascript(flash[:notice]) 
 end 
 end 
 if @comments.empty? 
 else 
  comment.id 
 cycle('', 'alt') 
 comment.created_at.strftime('%d %b, %Y') 
 link_to(comment.author, admin_comment_path(comment)) 
 truncate(comment.body, :length => 40) 
 link_to(comment.post_title, admin_post_path(comment.post))
 link_to(image_tag('silk/pencil.png', :alt => 'edit'), admin_comment_path(comment)) 
 form_for(comment, :as => :comment, :url => admin_comment_path(comment), :html => {:class => 'delete-item', :method => :delete}) do |form| 
 image_submit_tag("silk/delete.png", :alt => "Delete Comment") 
 end 
 
 end 
 if @comments.total_pages > 1 
 will_paginate(@comments, :previous_label => '« Newer', :next_label => 'Older »') 
 end 
 nav_link_to("Dashboard", admin_root_path,       :accesskey => '1') 
 nav_link_to("Posts",     admin_posts_path,      :accesskey => '2') 
 nav_link_to("(+)", new_admin_post_path, :accesskey => 'n') 
 nav_link_to("Pages",     admin_pages_path,      :accesskey => '3') 
 nav_link_to("(+)", new_admin_page_path, :accesskey => 'p') 
 nav_link_to("Comments",  admin_comments_path,   :accesskey => '4') 
 nav_link_to("Actions",   admin_undo_items_path, :accesskey => '5') 
 nav_link_to("Health",    admin_health_path,     :accesskey => '6') 
 link_to("Logout", admin_session_path, :accesskey => 'l', :method => :delete) 
 link_to("View Site", root_path,       :accesskey => 'v', :title => 'View Site') 

end

  end

  def show
    respond_to do |format|
      format.html {
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 enki_config[:title] 
 csrf_meta_tag 
 javascript_include_tag 'admin' 
 stylesheet_link_tag 'admin' 
 yield(:head) 
 if flash[:notice] 
 javascript_tag do 
 escape_javascript(flash[:notice]) 
 end 
 end 
 comment.id 
 cycle('', 'alt') 
 comment.created_at.strftime('%d %b, %Y') 
 link_to(comment.author, admin_comment_path(comment)) 
 truncate(comment.body, :length => 40) 
 link_to(comment.post_title, admin_post_path(comment.post))
 link_to(image_tag('silk/pencil.png', :alt => 'edit'), admin_comment_path(comment)) 
 form_for(comment, :as => :comment, :url => admin_comment_path(comment), :html => {:class => 'delete-item', :method => :delete}) do |form| 
 image_submit_tag("silk/delete.png", :alt => "Delete Comment") 
 end 
 nav_link_to("Dashboard", admin_root_path,       :accesskey => '1') 
 nav_link_to("Posts",     admin_posts_path,      :accesskey => '2') 
 nav_link_to("(+)", new_admin_post_path, :accesskey => 'n') 
 nav_link_to("Pages",     admin_pages_path,      :accesskey => '3') 
 nav_link_to("(+)", new_admin_page_path, :accesskey => 'p') 
 nav_link_to("Comments",  admin_comments_path,   :accesskey => '4') 
 nav_link_to("Actions",   admin_undo_items_path, :accesskey => '5') 
 nav_link_to("Health",    admin_health_path,     :accesskey => '6') 
 link_to("Logout", admin_session_path, :accesskey => 'l', :method => :delete) 
 link_to("View Site", root_path,       :accesskey => 'v', :title => 'View Site') 

end

      }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 enki_config[:title] 
 csrf_meta_tag 
 javascript_include_tag 'admin' 
 stylesheet_link_tag 'admin' 
 yield(:head) 
 if flash[:notice] 
 javascript_tag do 
 escape_javascript(flash[:notice]) 
 end 
 end 
 @comment.author 
 semantic_form_for([:admin, @comment]) do |form| 
 form.inputs do 
 form.input :author 
 form.input :author_url, :required => false 
 form.input :author_email, :required => false 
 form.input :body, :hint => "<a href='http://lesstile.rubyforge.org'>Lesstile enabled</a>.".html_safe 
 end 
 form.actions do 
 form.action :submit, :as => :button 
 end 
 end 
 nav_link_to("Dashboard", admin_root_path,       :accesskey => '1') 
 nav_link_to("Posts",     admin_posts_path,      :accesskey => '2') 
 nav_link_to("(+)", new_admin_post_path, :accesskey => 'n') 
 nav_link_to("Pages",     admin_pages_path,      :accesskey => '3') 
 nav_link_to("(+)", new_admin_page_path, :accesskey => 'p') 
 nav_link_to("Comments",  admin_comments_path,   :accesskey => '4') 
 nav_link_to("Actions",   admin_undo_items_path, :accesskey => '5') 
 nav_link_to("Health",    admin_health_path,     :accesskey => '6') 
 link_to("Logout", admin_session_path, :accesskey => 'l', :method => :delete) 
 link_to("View Site", root_path,       :accesskey => 'v', :title => 'View Site') 

end

  end

  def update
    if @comment.update_attributes(comment_params)
      flash[:notice] = "Updated comment by #{@comment.author}"
      redirect_to :action => 'index'
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 enki_config[:title] 
 csrf_meta_tag 
 javascript_include_tag 'admin' 
 stylesheet_link_tag 'admin' 
 yield(:head) 
 if flash[:notice] 
 javascript_tag do 
 escape_javascript(flash[:notice]) 
 end 
 end 
 @comment.author 
 semantic_form_for([:admin, @comment]) do |form| 
 form.inputs do 
 form.input :author 
 form.input :author_url, :required => false 
 form.input :author_email, :required => false 
 form.input :body, :hint => "<a href='http://lesstile.rubyforge.org'>Lesstile enabled</a>.".html_safe 
 end 
 form.actions do 
 form.action :submit, :as => :button 
 end 
 end 
 nav_link_to("Dashboard", admin_root_path,       :accesskey => '1') 
 nav_link_to("Posts",     admin_posts_path,      :accesskey => '2') 
 nav_link_to("(+)", new_admin_post_path, :accesskey => 'n') 
 nav_link_to("Pages",     admin_pages_path,      :accesskey => '3') 
 nav_link_to("(+)", new_admin_page_path, :accesskey => 'p') 
 nav_link_to("Comments",  admin_comments_path,   :accesskey => '4') 
 nav_link_to("Actions",   admin_undo_items_path, :accesskey => '5') 
 nav_link_to("Health",    admin_health_path,     :accesskey => '6') 
 link_to("Logout", admin_session_path, :accesskey => 'l', :method => :delete) 
 link_to("View Site", root_path,       :accesskey => 'v', :title => 'View Site') 

end

    end
  end

  def destroy
    undo_item = @comment.destroy_with_undo

    respond_to do |format|
      format.html do
        flash[:notice] = "Deleted comment by #{@comment.author}"
        redirect_to :action => 'index'
      end
      format.json {
        render :json => {
          :undo_path    => undo_admin_undo_item_path(undo_item),
          :undo_message => undo_item.description,
          :comment      => @comment.attributes
        }.to_json
      }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:author, :author_url, :author_email, :body)
  end

  protected

  def find_comment
    @comment = Comment.find(params[:id])
  end
end
