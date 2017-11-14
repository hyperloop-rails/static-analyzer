#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class ReportController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unless_moderator, except: [:create]

  def index
    @reports = Report.where(reviewed: false)
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 og_prefix 
 page_title yield(:page_title) 
  if @post.present? 
 og_page_post_tags(@post) 
 else 
 og_general_tags 
 end 
 
 chartbeat_head_block 
 include_mixpanel 
 include_color_theme 
 if rtl? 
 stylesheet_link_tag :rtl, media:  'all' 
 end 
 old_browser_js_support 
 javascript_include_tag :ie 
 jquery_include_tag 
 unless @landing_page 
 javascript_include_tag :main, :templates 
 load_javascript_locales 
 end 
 translation_missing_warnings 
 current_user_atom_tag 
 yield(:head) 
 csrf_meta_tag 
 include_gon(camel_case:  true) 
 yield :before_content 
 
 content_for :head do 
 stylesheet_link_tag :admin 
 end 
 if current_user.admin? 
  content_for :head do 
 stylesheet_link_tag :admin 
 end 
 t(".pages") 
 current_page?(admin_dashboard_path) 
 link_to t(".dashboard"), admin_dashboard_path 
 current_page?(user_search_path) 
 link_to t(".user_search"), user_search_path 
 current_page?(weekly_user_stats_path) 
 link_to t(".weekly_user_stats"), weekly_user_stats_path 
 current_page?(pod_stats_path) 
 link_to t(".pod_stats"), pod_stats_path 
 current_page?(report_index_path) 
 link_to t(".report"), report_index_path 
 current_page?(admin_pods_path) 
 link_to t(".pod_network"), admin_pods_path 
 current_page?(sidekiq_path) 
 link_to t(".sidekiq_monitor"), sidekiq_path 
 
 end 
 t("report.title") 
 @reports.each do |report| 
 if report.item 
 username = report.user.username 
 raw t("report.reported_label", person: link_to(username, user_profile_path(username))) 
 report_content(report) 
 t("report.reason_label", text: report.text) 
 button_to t("report.reported_user_details"),                  user_search_path(admins_controller_user_search: {guid: report.reported_author.guid}),                  class: "btn pull-left btn-info btn-small", method: :post 
 button_to t("report.review_link"), report_path(report.id, type: report.item_type),                  class: "btn pull-left btn-info btn-small", method: :put 
 button_to t("report.delete_link"), report_path(report.id, type: report.item_type),                  data: {confirm: t("report.confirm_deletion")},                  class: "btn pull-right btn-danger btn-small", method: :delete 
 else 
 username = report.user.username 
 raw t("report.reported_label", person: link_to(username, user_profile_path(username))) 
 report_content(report) 
 button_to t("report.review_link"), report_path(report.id, type: report.item_type),                  class: "btn pull-left btn-info btn-small", method: :put 
 end 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def update
    if report = Report.where(id: params[:id]).first
      report.mark_as_reviewed
    end
    redirect_to :action => :index
  end

  def destroy
    if (report = Report.where(id: params[:id]).first) && report.destroy_reported_item
      flash[:notice] = I18n.t "report.status.destroyed"
    else
      flash[:error] = I18n.t "report.status.failed"
    end
    redirect_to action: :index
  end

  def create
    report = current_user.reports.new(report_params)
    if report.save
      render json: true, status: 200
    else
      render nothing: true, status: 409
    end
  end

  private
    def report_params
      params.require(:report).permit(:item_id, :item_type, :text)
    end
end
