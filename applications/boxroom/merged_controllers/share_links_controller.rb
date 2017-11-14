class ShareLinksController < ApplicationController
  before_action :require_admin, :only => [:index, :destroy]
  before_action :require_existing_file, :except => [:index, :destroy]
  before_action :require_existing_share_link, :only => :destroy
  before_action :require_read_permission, :only => [:new, :create]
  skip_before_action :require_login, :only => :show

  rescue_from ActiveRecord::RecordNotFound, NoMethodError, RuntimeError, :with => :redirect_to_root_or_signin_and_show_alert

  def index
    @share_links = ShareLink.active_share_links
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if content_for? :title 
 content_for :title 
 else 
 end 
 stylesheet_link_tag 'application' 
 javascript_include_tag 'application' 
 csrf_meta_tag 
 if flash[:notice] 
 flash[:notice] 
 end 
 if flash[:alert] 
 flash[:alert] 
 end 
  if signed_in? 
 t :hello 
 current_user.name 
 link_to t(:settings), edit_user_path(current_user) 
 link_to t(:sign_out), signout_path, :method => :delete 
 end 
 link_to image_tag('logo.png', :alt => 'Boxroom'), root_path 
 
  if signed_in? 
 link_to t(:folders), folders_path 
 if current_user.member_of_admins? 
 link_to t(:users), users_path 
 link_to t(:groups), groups_path 
 link_to t(:shared_files), share_links_path 
 end 
 end 
 
 content_for :title, t(:shared_files) 
 content_for :title 
 t('activerecord.models.user_file') 
 t(:shared_by) 
 t('activerecord.attributes.share_link.emails') 
 t('activerecord.attributes.share_link.expires_at') 
 @share_links.each do |share_link| 
 cycle('even','odd') 
 image_tag file_icon(share_link.user_file.extension) 
 link_to truncate(share_link.user_file.attachment_file_name, :length => 24), share_link.user_file.folder, :title => "#{share_link.user_file.attachment_file_name} (#{share_link.user_file.folder.name})" 
 share_link.user.name 
 share_link.emails 
 truncate(share_link.emails, :length => 36) 
 l share_link.link_expires_at, :format => :very_short 
 link_to image_tag('delete.png', :alt => t(:delete_item)), share_link_path(share_link), :method => :delete, :data => { :confirm => t(:are_you_sure) }, :title => t(:unshare) 
 end 
  

end

  end

  # Note: @file is set in require_existing_file
  def show
    send_file @file.attachment.path, :filename => @file.attachment_file_name unless @file.nil?
  end

  # Note: @file is set in require_existing_file
  def new
    @share_link = @file.share_links.build
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if content_for? :title 
 content_for :title 
 else 
 end 
 stylesheet_link_tag 'application' 
 javascript_include_tag 'application' 
 csrf_meta_tag 
 if flash[:notice] 
 flash[:notice] 
 end 
 if flash[:alert] 
 flash[:alert] 
 end 
  if signed_in? 
 t :hello 
 current_user.name 
 link_to t(:settings), edit_user_path(current_user) 
 link_to t(:sign_out), signout_path, :method => :delete 
 end 
 link_to image_tag('logo.png', :alt => 'Boxroom'), root_path 
 
  if signed_in? 
 link_to t(:folders), folders_path 
 if current_user.member_of_admins? 
 link_to t(:users), users_path 
 link_to t(:groups), groups_path 
 link_to t(:shared_files), share_links_path 
 end 
 end 
 
 content_for :title, t(:share_file) 
 content_for :title 
 form_for [@file, @share_link], :url => { :action => 'create' } do |f| 
 f.error_messages :header_message => t(:share_link_could_not_be_sent) 
 t :you_are_about_to_share_the_following_file 
 image_tag(file_icon(@file.extension)) 
 link_to @file.attachment_file_name, @folder 
 f.label :emails, t(:emails_to_share_with) 
 t :comma_seperated 
 f.text_area :emails, :class => 'emails_to_share_with' 
 t :number_of_charachters 
 @share_link.emails.nil? ? 0 : @share_link.emails.length 
 f.label :message, t(:shared_message) 
 t :optional 
 f.text_area :message, :class => 'share_message' 
 f.label t(:link_expires) 
 f.select :link_expires_at, options_for_select([
        [t(:tomorrow), 1.day.from_now.end_of_day],
        [t(:three_days_from_now), 3.day.from_now.end_of_day],
        [t(:one_week_from_now), 1.week.from_now.end_of_day],
        [t(:ten_days_from_now), 10.days.from_now.end_of_day],
        [t(:two_weeks_from_now), 2.weeks.from_now.end_of_day],
        [t(:three_weeks_from_now), 3.weeks.from_now.end_of_day],
        [t(:one_month_from_now), 1.month.from_now.end_of_day],
        [t(:two_months_from_now), 2.months.from_now.end_of_day],
        [t(:three_months_from_now), 3.months.from_now.end_of_day],
        [t(:half_year_from_now), 6.months.from_now.end_of_day]
    ], 2.weeks.from_now.end_of_day) 
 f.submit t(:share) 
 link_to t(:back), @folder 
 end 
  

end

  end

  # Note: @file and @folder are set in require_existing_file
  def create
    @share_link = @file.share_links.build(permitted_params.share_link)
    @share_link.user = current_user

    if @share_link.save
      UserMailer.share_link_email(@share_link).deliver_now
      redirect_to @folder, :notice => t(:shared_successfully)
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if content_for? :title 
 content_for :title 
 else 
 end 
 stylesheet_link_tag 'application' 
 javascript_include_tag 'application' 
 csrf_meta_tag 
 if flash[:notice] 
 flash[:notice] 
 end 
 if flash[:alert] 
 flash[:alert] 
 end 
  if signed_in? 
 t :hello 
 current_user.name 
 link_to t(:settings), edit_user_path(current_user) 
 link_to t(:sign_out), signout_path, :method => :delete 
 end 
 link_to image_tag('logo.png', :alt => 'Boxroom'), root_path 
 
  if signed_in? 
 link_to t(:folders), folders_path 
 if current_user.member_of_admins? 
 link_to t(:users), users_path 
 link_to t(:groups), groups_path 
 link_to t(:shared_files), share_links_path 
 end 
 end 
 
 content_for :title, t(:share_file) 
 content_for :title 
 form_for [@file, @share_link], :url => { :action => 'create' } do |f| 
 f.error_messages :header_message => t(:share_link_could_not_be_sent) 
 t :you_are_about_to_share_the_following_file 
 image_tag(file_icon(@file.extension)) 
 link_to @file.attachment_file_name, @folder 
 f.label :emails, t(:emails_to_share_with) 
 t :comma_seperated 
 f.text_area :emails, :class => 'emails_to_share_with' 
 t :number_of_charachters 
 @share_link.emails.nil? ? 0 : @share_link.emails.length 
 f.label :message, t(:shared_message) 
 t :optional 
 f.text_area :message, :class => 'share_message' 
 f.label t(:link_expires) 
 f.select :link_expires_at, options_for_select([
        [t(:tomorrow), 1.day.from_now.end_of_day],
        [t(:three_days_from_now), 3.day.from_now.end_of_day],
        [t(:one_week_from_now), 1.week.from_now.end_of_day],
        [t(:ten_days_from_now), 10.days.from_now.end_of_day],
        [t(:two_weeks_from_now), 2.weeks.from_now.end_of_day],
        [t(:three_weeks_from_now), 3.weeks.from_now.end_of_day],
        [t(:one_month_from_now), 1.month.from_now.end_of_day],
        [t(:two_months_from_now), 2.months.from_now.end_of_day],
        [t(:three_months_from_now), 3.months.from_now.end_of_day],
        [t(:half_year_from_now), 6.months.from_now.end_of_day]
    ], 2.weeks.from_now.end_of_day) 
 f.submit t(:share) 
 link_to t(:back), @folder 
 end 
  

end

    end
  end

  # Note: @share_link is set in require_existing_share_link
  def destroy
    @share_link.destroy
    redirect_to share_links_url
  end

  private

  def require_existing_file
    @file = params[:file_id].blank? ? ShareLink.file_for_token(params[:id]) : UserFile.find(params[:file_id])
    @folder = @file.folder
  end

  def require_existing_share_link
    @share_link = ShareLink.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to share_links_url, :alert => t(:already_deleted, :type => t(:this_share_link))
  end

  def redirect_to_root_or_signin_and_show_alert
    if signed_in?
      redirect_to Folder.root, :alert => t(:already_deleted, :type => t(:this_file))
    else
      redirect_to signin_url, :alert => t(:already_deleted, :type => t(:this_file))
    end
  end
end
