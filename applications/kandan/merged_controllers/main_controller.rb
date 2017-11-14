class MainController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    # TODO this isn't being used right now. use this for faster app
    @channels = Channel.includes(:activities => :user).all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for?(:title) ? yield(:title) : "Kandan" 
 favicon_link_tag 
 csrf_meta_tags 
 stylesheet_link_tag "//fonts.googleapis.com/css?family=PT+Sans:400,700" 
 stylesheet_link_tag "application", media: "all" 
 javascript_include_tag "application" 
 yield :head 
 if user_signed_in? 
 javascript_tag do 
 json_escape(current_user_data.to_json.html_safe) 
 end 
 end 
 Kandan::Config.to_json 
 if content_for? :sidebar 
 avatar_url_for(current_user, :size => 25) 
 end 
   
 image_tag "logo.png" 
 
  unless controller.controller_name == 'channels' || controller.controller_name == 'main' 
 flash.each do |name, msg| 
 if msg.is_a?(String) 
name == :notice ? "success" : "danger"
 msg 
 end 
 end 
 end 
 
  
  
 current_user.full_name_or_username 
 link_to 'Admin console', admin_root_path if current_user.is_admin? 
 link_to 'Edit Account', users_edit_path 
 link_to 'Logout', destroy_user_session_path, :method => :delete 
 link_to 'About Kandan', about_path 
 
  
 params[:query].presence || "" 

end

  end

  def search
    minimum_query_length = 3

    if params[:query] and params[:query].length >= minimum_query_length
      @activities = Activity.includes(:user).where("LOWER(content) LIKE ?", "%#{params[:query]}%").limit(params[:limit] || 100).all
    end

    respond_to do |format|
      format.html
      format.json { render :json => @activities.to_json(:include => :user) }
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for?(:title) ? yield(:title) : "Kandan" 
 favicon_link_tag 
 csrf_meta_tags 
 stylesheet_link_tag "//fonts.googleapis.com/css?family=PT+Sans:400,700" 
 stylesheet_link_tag "application", media: "all" 
 javascript_include_tag "application" 
 yield :head 
 if user_signed_in? 
 javascript_tag do 
 json_escape(current_user_data.to_json.html_safe) 
 end 
 end 
 Kandan::Config.to_json 
 if content_for? :sidebar 
 yield :sidebar 
 end 
  link_to content_tag(:i, nil, class: 'icon-angle-left'), root_path, class: 'button left' 
 image_tag "logo.png" 
 
  unless controller.controller_name == 'channels' || controller.controller_name == 'main' 
 flash.each do |name, msg| 
 if msg.is_a?(String) 
name == :notice ? "success" : "danger"
 msg 
 end 
 end 
 end 
 
  
 javascript_tag do 
 json_escape(@activities.as_json(:include => { user: { :only => [:email, :first_name, :last_name, :username, :avatar_url, :gravatar_hash, :is_admin]} }).to_json.html_safe) 
 params[:query] 
 end 
  
 params[:query].presence || "" 

end

  end
end
