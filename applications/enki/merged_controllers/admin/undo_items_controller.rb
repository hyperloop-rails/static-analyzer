class Admin::UndoItemsController < Admin::BaseController
  def index
    @undo_items = UndoItem.order('created_at DESC').limit(50).all
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
 @undo_items.each do |undo_item| 
 cycle('', 'alt') 
 undo_item.created_at.strftime('%d %b, %Y') 
 undo_item.description 
 form_for(undo_item, :as => :undo_item, :url => undo_admin_undo_item_path(undo_item), :html => {:class => 'undo-item', :method => :post}) do |form| 
 image_submit_tag("silk/arrow_undo.png", :alt => 'Undo') 
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

  def undo
    item = UndoItem.find(params[:id])
    begin
      object = item.process!

      respond_to do |format|
        format.html do
          flash[:notice] = item.complete_description
          redirect_to(:back)
        end
        format.json {
          render :json => {
            :message => item.complete_description,
            :obj     => object.attributes
          }
        }
      end
    rescue UndoFailed
      msg = "Could not undo, would result in an invalid state (i.e. a comment with no post)"
      respond_to do |format|
        format.html do
          flash[:notice] = msg
          redirect_to(:back)
        end
        format.json { render :json => { :message => msg } }
      end
    end
  end
end
