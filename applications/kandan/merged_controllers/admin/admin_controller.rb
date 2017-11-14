module Admin
  class AdminController < BaseController

    def index
      @settings = Setting.my_settings
      @all_users = User.find(:all, :conditions => ["id != ?", current_user.id])

      @waiting_for_approval_users = []
      @approved_users = []

      # Iterate over the array to get approved and non-approved users
      @all_users.each{|user| user.registration_status.waiting_approval? ? @waiting_for_approval_users.push(user) : @approved_users.push(user) }
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 content_for :head do 
 javascript_include_tag "admin/admin" 
 end 
 content_for :header do 
 link_to content_tag(:i, nil, class: 'icon-angle-left'), root_path, class: 'button left' 
 end 
 form_for @settings, :url => admin_update_path, :method => :post do |f| 
 f.label :max_rooms do 
 f.number_field :max_rooms, :class => "input-mini pull-right" 
 end 
 f.label :disable_conn_disconn_activity do 
 f.check_box :disable_conn_disconn_activity, :class => "switch" 
 end 
 f.label :public_site do 
 f.check_box :public_site, :class => "switch" 
 end 
 f.submit :class => "btn btn-success" 
 end 
  user.id
 user.full_name_or_username 
 image_tag avatar_url_for(user, :size => 70), class: 'avatar' 
 if user.full_name.blank? 
 user.username 
 else 
 "#{user.full_name} (#{user.username})" 
 end 
 user.email 
 user_status_badge(user) 
 user_status_button(user) 
 user_admin_button(user) 
 
  user.id
 user.full_name_or_username 
 image_tag avatar_url_for(user, :size => 70), class: 'avatar' 
 if user.full_name.blank? 
 user.username 
 else 
 "#{user.full_name} (#{user.username})" 
 end 
 user.email 
 user_status_badge(user) 
 user_status_button(user) 
 user_admin_button(user) 
 

end

    end

    def update

      max_rooms = params[:setting][:max_rooms].to_i
      public_site = params[:setting][:public_site] == "1"
      disable_conn_disconn_activity = params[:setting][:disable_conn_disconn_activity] == "1"

      Setting.set_values(:max_rooms => max_rooms, :public_site => public_site, :disable_conn_disconn_activity => disable_conn_disconn_activity)

      redirect_to :admin_root
    end

    def update_user
      user_id = params[:user_id]
      action = params[:action_taken].to_s

      user = User.find(user_id)

      case action
      when "activate", "approve"
        user.activate!
      when "suspend"
        user.suspend!
      end

      render :json => user, :status => 200
    end

    def toggle_admin
      user_id = params[:user_id]

      user = User.find(user_id)

      user.is_admin = !user.is_admin?

      user.save!

      render :json => user, :status => 200
    end

  end
end
