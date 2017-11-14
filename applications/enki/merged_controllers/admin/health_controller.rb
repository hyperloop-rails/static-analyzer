class Admin::HealthController < Admin::BaseController
  before_filter :require_login
  verify :method => 'post',
         :only   => 'generate_exception',
         :add_headers => {
           "Allow" => "POST"},
         :render => {
           :text   => 'Method not allowed',
           :status => 405}

  def index
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
 button_to("Throw exception", admin_health_path(:action => 'generate_exception')) 
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

  def generate_exception
    raise RuntimeError
  end
end
