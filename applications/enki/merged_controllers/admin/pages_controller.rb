class Admin::PagesController < Admin::BaseController
  before_filter :find_page, :only => [:show, :update, :destroy]

  def index
    respond_to do |format|
      format.html {
        @pages = Page.paginate(:page => params[:page]).order("created_at DESC")
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
 if @pages.empty? 
 else 
  cycle('', 'alt') 
 page.created_at.strftime('%d %b, %Y') 
 link_to(page.title, admin_page_path(page)) 
 truncate(page.body, :length => 50) 
 page.slug 
 link_to(image_tag('silk/pencil.png', :alt => 'edit'), admin_page_path(page)) 
 form_for(page, :as => :page, :url => admin_page_path(page), :html => {:class => 'delete-item', :method => :delete}) do |form| 
 image_submit_tag("silk/delete.png", :alt => 'Delete Comment') 
 end 
 
 end 
 if @pages.total_pages > 1 
 will_paginate(@pages, :previous_label => '« Newer', :next_label => 'Older »') 
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
    @page = Page.new(page_params)
    if @page.save
      respond_to do |format|
        format.html {
          flash[:notice] = "Created page '#{@page.title}'"
          redirect_to(:action => 'show', :id => @page)
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
 semantic_form_for([:admin, @page]) do |form| 
  form.inputs do 
 form.input :title 
 form.input :slug, :hint => "Leave blank for an auto-generated slug based on the title." 
 form.input :body, :hint => "<a href='http://textile.thresholdstate.com/'>Textile enabled</a>. Use Ctrl+E to switch between preview and edit mode.".html_safe 
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
    if @page.update_attributes(page_params)
      respond_to do |format|
        format.html {
          flash[:notice] = "Updated page '#{@page.title}'"
          redirect_to(:action => 'show', :id => @page)
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
 link_to(@page.title, page_path(@page.slug)) 
 semantic_form_for([:admin, @page]) do |form| 
  form.inputs do 
 form.input :title 
 form.input :slug, :hint => "Leave blank for an auto-generated slug based on the title." 
 form.input :body, :hint => "<a href='http://textile.thresholdstate.com/'>Textile enabled</a>. Use Ctrl+E to switch between preview and edit mode.".html_safe 
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
 page.created_at.strftime('%d %b, %Y') 
 link_to(page.title, admin_page_path(page)) 
 truncate(page.body, :length => 50) 
 page.slug 
 link_to(image_tag('silk/pencil.png', :alt => 'edit'), admin_page_path(page)) 
 form_for(page, :as => :page, :url => admin_page_path(page), :html => {:class => 'delete-item', :method => :delete}) do |form| 
 image_submit_tag("silk/delete.png", :alt => 'Delete Comment') 
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
 link_to(@page.title, page_path(@page.slug)) 
 semantic_form_for([:admin, @page]) do |form| 
  form.inputs do 
 form.input :title 
 form.input :slug, :hint => "Leave blank for an auto-generated slug based on the title." 
 form.input :body, :hint => "<a href='http://textile.thresholdstate.com/'>Textile enabled</a>. Use Ctrl+E to switch between preview and edit mode.".html_safe 
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
    @page = Page.new
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
 semantic_form_for([:admin, @page]) do |form| 
  form.inputs do 
 form.input :title 
 form.input :slug, :hint => "Leave blank for an auto-generated slug based on the title." 
 form.input :body, :hint => "<a href='http://textile.thresholdstate.com/'>Textile enabled</a>. Use Ctrl+E to switch between preview and edit mode.".html_safe 
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
    @page = Page.build_for_preview(page_params)

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
 raw(page.body_html) 
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
    undo_item = @page.destroy_with_undo

    respond_to do |format|
      format.html do
        flash[:notice] = "Deleted page '#{@page.title}'"
        redirect_to :action => 'index'
      end
      format.json {
        render :json => {
          :undo_path    => undo_admin_undo_item_path(undo_item),
          :undo_message => undo_item.description,
          :page         => @page.attributes
        }.to_json
      }
    end
  end

  protected

  def page_params
    params.require(:page).permit(:title, :slug, :body)
  end

  def find_page
    @page = Page.find(params[:id])
  end
end
