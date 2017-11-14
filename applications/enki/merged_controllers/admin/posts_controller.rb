class Admin::PostsController < Admin::BaseController
  before_filter :find_post, :only => [:show, :update, :destroy]

  def index
    respond_to do |format|
      format.html {
        @posts = Post.paginate(:page => params[:page]).order("coalesce(published_at, updated_at) DESC")
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
 if @posts.empty? 
 else 
  cycle('', 'alt') 
 post.published_at.try(:strftime, '%d %b, %Y') 
 link_to (post.title == '' ? '[Untitled]' : truncate(post.title, :length => 30)), admin_post_path(post) 
 tmpc = truncate(post.body, :length => 55) 
 (tmpc != '' ? tmpc : '&nbsp;') 
 post.approved_comments.size 
 link_to(image_tag('silk/pencil.png', :alt => 'edit'), admin_post_path(post)) 
 form_for(post, :as => :post, :url => admin_post_path(post), :html => {:class => 'delete-item', :method => :delete}) do |form| 
 image_submit_tag("silk/delete.png", :alt => 'Delete Post') 
 end 
 
 end 
 if @posts.total_pages > 1 
 will_paginate(@posts, :previous_label => '« Newer', :next_label => 'Older »') 
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

  def create
    @post = Post.new(post_params)
    if @post.save
      respond_to do |format|
        format.html {
          flash[:notice] = "Created post '#{@post.title}'"
          redirect_to(:action => 'show', :id => @post)
        }
      end
    else
      respond_to do |format|
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 semantic_form_for([:admin, @post]) do |form| 
  form.inputs do 
 form.input :title 
 form.input :body, :hint => "<a href='http://redcloth.org/textile'>Textile enabled</a>. Use Ctrl+E to switch between preview and edit mode.".html_safe 
 form.input :tag_list, :input_html => { :value => @post.tag_list.join(', ')}, :as => 'string', :required => false, :hint => 'Comma separated: ruby, rails&hellip;'.html_safe 
 end 
 form.inputs do 
 form.input :published_at_natural, :label => 'Published at', :as => 'string', :hint => 'Examples: now, yesterday, 1 hour from now, '.html_safe + link_to("etc".html_safe, "http://chronic.rubyforge.org/") + '. Leave blank for an unpublished draft.' 
 form.input :slug, :hint => "Leave blank for an auto-generated slug based on the title." 
 form.input :minor_edit, :as => 'boolean', :hint => 'Minor edits will not show up as refreshed in feed readers. Use this to fix spelling mistakes and the like.' unless @post.new_record? 
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
 }
      end
    end
  end

  def update
    if @post.update_attributes(post_params)
      respond_to do |format|
        format.html {
          flash[:notice] = "Updated post '#{@post.title}'"
          redirect_to(:action => 'show', :id => @post)
        }
      end
    else
      respond_to do |format|
        format.html { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 link_to_post(@post) 
 semantic_form_for([:admin, @post]) do |form| 
  form.inputs do 
 form.input :title 
 form.input :body, :hint => "<a href='http://redcloth.org/textile'>Textile enabled</a>. Use Ctrl+E to switch between preview and edit mode.".html_safe 
 form.input :tag_list, :input_html => { :value => @post.tag_list.join(', ')}, :as => 'string', :required => false, :hint => 'Comma separated: ruby, rails&hellip;'.html_safe 
 end 
 form.inputs do 
 form.input :published_at_natural, :label => 'Published at', :as => 'string', :hint => 'Examples: now, yesterday, 1 hour from now, '.html_safe + link_to("etc".html_safe, "http://chronic.rubyforge.org/") + '. Leave blank for an unpublished draft.' 
 form.input :slug, :hint => "Leave blank for an auto-generated slug based on the title." 
 form.input :minor_edit, :as => 'boolean', :hint => 'Minor edits will not show up as refreshed in feed readers. Use this to fix spelling mistakes and the like.' unless @post.new_record? 
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
 }
      end
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
 cycle('', 'alt') 
 post.published_at.try(:strftime, '%d %b, %Y') 
 link_to (post.title == '' ? '[Untitled]' : truncate(post.title, :length => 30)), admin_post_path(post) 
 tmpc = truncate(post.body, :length => 55) 
 (tmpc != '' ? tmpc : '&nbsp;') 
 post.approved_comments.size 
 link_to(image_tag('silk/pencil.png', :alt => 'edit'), admin_post_path(post)) 
 form_for(post, :as => :post, :url => admin_post_path(post), :html => {:class => 'delete-item', :method => :delete}) do |form| 
 image_submit_tag("silk/delete.png", :alt => 'Delete Post') 
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
 link_to_post(@post) 
 semantic_form_for([:admin, @post]) do |form| 
  form.inputs do 
 form.input :title 
 form.input :body, :hint => "<a href='http://redcloth.org/textile'>Textile enabled</a>. Use Ctrl+E to switch between preview and edit mode.".html_safe 
 form.input :tag_list, :input_html => { :value => @post.tag_list.join(', ')}, :as => 'string', :required => false, :hint => 'Comma separated: ruby, rails&hellip;'.html_safe 
 end 
 form.inputs do 
 form.input :published_at_natural, :label => 'Published at', :as => 'string', :hint => 'Examples: now, yesterday, 1 hour from now, '.html_safe + link_to("etc".html_safe, "http://chronic.rubyforge.org/") + '. Leave blank for an unpublished draft.' 
 form.input :slug, :hint => "Leave blank for an auto-generated slug based on the title." 
 form.input :minor_edit, :as => 'boolean', :hint => 'Minor edits will not show up as refreshed in feed readers. Use this to fix spelling mistakes and the like.' unless @post.new_record? 
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

  def new
    @post = Post.new
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
 semantic_form_for([:admin, @post]) do |form| 
  form.inputs do 
 form.input :title 
 form.input :body, :hint => "<a href='http://redcloth.org/textile'>Textile enabled</a>. Use Ctrl+E to switch between preview and edit mode.".html_safe 
 form.input :tag_list, :input_html => { :value => @post.tag_list.join(', ')}, :as => 'string', :required => false, :hint => 'Comma separated: ruby, rails&hellip;'.html_safe 
 end 
 form.inputs do 
 form.input :published_at_natural, :label => 'Published at', :as => 'string', :hint => 'Examples: now, yesterday, 1 hour from now, '.html_safe + link_to("etc".html_safe, "http://chronic.rubyforge.org/") + '. Leave blank for an unpublished draft.' 
 form.input :slug, :hint => "Leave blank for an auto-generated slug based on the title." 
 form.input :minor_edit, :as => 'boolean', :hint => 'Minor edits will not show up as refreshed in feed readers. Use this to fix spelling mistakes and the like.' unless @post.new_record? 
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

  def preview
    @post = Post.build_for_preview(post_params)

    respond_to do |format|
      format.js {
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
 link_to_post(post) 
 raw(post.body_html) 
 format_post_date(post.published_at) if post.published? 
 link_to_post_comments post 
 unless post.tags.empty? 
 linked_tag_list(post.tags) 
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
  end

  def destroy
    undo_item = @post.destroy_with_undo

    respond_to do |format|
      format.html do
        flash[:notice] = "Deleted post '#{@post.title}'"
        redirect_to :action => 'index'
      end
      format.json {
        render :json => {
          :undo_path    => undo_admin_undo_item_path(undo_item),
          :undo_message => undo_item.description,
          :post         => @post.attributes
        }
      }
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :tag_list, :published_at_natural, :slug, :minor_edit)
  end

  protected

  def find_post
    @post = Post.find(params[:id])
  end

end
