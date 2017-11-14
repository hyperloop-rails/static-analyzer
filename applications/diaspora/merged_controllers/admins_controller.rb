class AdminsController < Admin::AdminController
  include ApplicationHelper

  def dashboard
    gon.push(pod_version: pod_version)
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
 
 t(".pod_status") 
 t(".fetching_diaspora_version") 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def user_search
    if params[:admins_controller_user_search]
      search_params = params.require(:admins_controller_user_search)
                            .permit(:username, :email, :guid, :under13)
      @search = UserSearch.new(search_params)
      @users = @search.perform
    end

    @search ||= UserSearch.new
    @users ||= []
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
 
 t('admins.admin_bar.user_search') 
 form_for @search, url: {action: 'user_search'}, html: {method: :get, class: 'form-horizontal'} do |f| 
 f.label :username, t('username'), class: 'col-sm-2 control-label' 
 f.text_field :username, class: "form-control" 
 f.label :email, t('email'), class: 'col-sm-2 control-label' 
 f.text_field :email, class: "form-control" 
 f.label :guid, t('admins.user_entry.guid'), class: 'col-sm-2 control-label' 
 f.text_field :guid, class: "form-control" 
 f.label :under13 do 
 f.check_box :under13 
 t(".under_13") 
 end 
 submit_tag t("admins.stats.go"), class: "btn btn-primary pull-right" 
 end 
 t("shared.invitations.invites") 
 raw(t(".you_currently", count: current_user.invitation_code.count,                link: link_to(t(".add_invites"), add_invites_path(current_user.invitation_code),                class: "btn btn-link pull-right"))) 
 form_tag "admin_inviter", method: :get, class: "form-horizontal" do 
 t(".email_to") 
 text_field_tag "identifier", nil, class: "form-control" 
 submit_tag t("services.remote_friend.invite"), class: "btn btn-default pull-right" 
 end 
 t('.users', :count => @users.count) 
 @users.each do |user| 
  
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def admin_inviter
    inviter = InvitationCode.default_inviter_or(current_user)
    email = params[:identifier]
    user = User.find_by_email(email)

    unless user
      EmailInviter.new(email, inviter).send!
      flash[:notice] = "invitation sent to #{email}"
    else
      flash[:notice]= "error sending invite to #{email}"
    end
    redirect_to user_search_path, :notice => flash[:notice]
  end

  def add_invites
    InvitationCode.find_by_token(params[:invite_code_id]).add_invites!
    redirect_to user_search_path
  end

  def weekly_user_stats
    @created_users_by_week = Hash.new{ |h,k| h[k] = [] }
    @created_users = User.where("username IS NOT NULL and created_at IS NOT NULL")
    @created_users.find_each do |u|
      week = u.created_at.beginning_of_week.strftime("%Y-%m-%d")
      @created_users_by_week[week] << u.username
    end

    @selected_week = params[:week] || @created_users_by_week.keys.last
    @counter = @created_users_by_week[@selected_week].count
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
 
 t('.current_server', date: Time.now.to_date) 
 form_tag('/admins/weekly_user_stats', method: 'get', class: 'form-inline') do 
 select_tag(:week, options_for_select(@created_users_by_week.keys.reverse, @selected_week), class: "form-control") 
 submit_tag t('admins.stats.go'), class: 'btn btn-primary' 
 end 
 t('.amount_of', count: @counter) 
 @created_users_by_week[@selected_week].each do |m| 
 link_to m, "/u/" 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  def stats
    @popular_tags = ActsAsTaggableOn::Tagging.joins(:tag).limit(50).order('count(taggings.id) DESC').group(:tag).count

    case params[:range]
    when "week"
      range = 1.week
      @segment = t('admins.stats.week')
    when "2weeks"
      range = 2.weeks
      @segment = t('admins.stats.2weeks')
    when "month"
      range = 1.month
      @segment = t('admins.stats.month')
    else
      range = 1.day
      @segment = t('admins.stats.daily')
    end

    [Post, Comment, AspectMembership, User].each do |model|
      create_hash(model, :range => range)
    end

    @posts_per_day = Post.where("created_at >= ?", Date.today - 21.days).group("DATE(created_at)").order("DATE(created_at) ASC").count
    @most_posts_within = @posts_per_day.values.max.to_f

    @user_count = User.count

    #@posts[:new_public] = Post.where(:type => ['StatusMessage','ActivityStreams::Photo'],
    #                                 :public => true).order('created_at DESC').limit(15).all

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
 
 t('.usage_statistic') 
 form_tag('/admins/stats', :method => 'get', class: 'form-inline') do 
 ('selected' if params[:range] == 'daily') 
 t('.daily') 
 ('selected' if params[:range] == 'week') 
 t('.week') 
 ('selected' if params[:range] == '2weeks') 
 t('.2weeks') 
 ('selected' if params[:range] == 'month') 
 t('.month') 
 submit_tag t('.go'), class: 'btn btn-primary' 
 end 
 raw(t('.display_results', :segment => @segment)) 
 [:posts, :comments, :aspect_memberships, :users].each do |name| 
 model = eval("@") 
 if name == :aspect_memberships 
 name = t('.shares', :count => model[:yesterday]) 
 end 
 if name == :posts 
 name = t('.posts', :count => model[:yesterday]) 
 end 
 if name == :comments 
 name = t('.comments', :count => model[:yesterday]) 
 end 
 if name == :users 
 name = t('.users', :count => model[:yesterday]) 
 end 
 name.to_s 
 model[:day_before] 
 "(%)" 
 end 
 raw(t('.current_segment', :post_yest => @posts[:yesterday]/@user_count.to_f, :post_day => @posts[:day_before]/@user_count.to_f)) 
 t('.50_most') 
 @popular_tags.each do |name,count| 
 raw(t('.tag_name', :name_tag => name, :count_tag => count)) 
 end 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end

  private

  def percent_change(today, yesterday)
    sprintf( "%0.02f", ((today-yesterday) / yesterday.to_f)*100).to_f
  end

  def create_hash(model, opts={})
    opts[:range] ||= 1.day
    plural = model.to_s.underscore.pluralize
    eval(<<DATA
      @#{plural} = {
        :day_before => #{model}.where(:created_at => ((Time.now.midnight - #{opts[:range]*2})..Time.now.midnight - #{opts[:range]})).count,
        :yesterday => #{model}.where(:created_at => ((Time.now.midnight - #{opts[:range]})..Time.now.midnight)).count
      }
      @#{plural}[:change] = percent_change(@#{plural}[:yesterday], @#{plural}[:day_before])
DATA
    )
  end


  class UserSearch
    include ActiveModel::Model
    include ActiveModel::Conversion
    include ActiveModel::Validations

    attr_accessor :username, :email, :guid, :under13

    validate :any_searchfield_present?

    def initialize(attributes={})
      assign_attributes(attributes)
      yield(self) if block_given?
    end

    def assign_attributes(values)
      values.each do |k, v|
        public_send("#{k}=", v)
      end
    end

    def any_searchfield_present?
      if %w(username email guid under13).all? { |attr| public_send(attr).blank? }
        errors.add :base, "no fields for search set"
      end
    end

    def perform
      return User.none unless valid?

      users = User.arel_table
      people = Person.arel_table
      profiles = Profile.arel_table
      res = User.joins(person: :profile)
      res = res.where(users[:username].matches("%#{username}%")) unless username.blank?
      res = res.where(users[:email].matches("%#{email}%")) unless email.blank?
      res = res.where(people[:guid].matches("%#{guid}%")) unless guid.blank?
      res = res.where(profiles[:birthday].gt(Date.today-13.years)) if under13 == '1'
      res
    end
  end
end
