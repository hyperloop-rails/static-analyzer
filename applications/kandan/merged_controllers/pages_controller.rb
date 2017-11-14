class PagesController < ApplicationController
  
  before_filter :authenticate_user!, :except => :about

  skip_filter :force_approved_account, :only => :approval
  skip_filter :redirect_suspended_account, :only => :suspended

  def approval
  	redirect_to(root_path) && return unless current_user.registration_status.waiting_approval?
  end

  def suspended
  	redirect_to(root_path) && return unless current_user.registration_status.suspended?
  end

  def about
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
 
 content_for :title, "About Kandan" 
  
 AppName::VERSION 
 AppName::REVISION 
 javascript_tag do 
 end 
 yield :end 

end

  end

end
