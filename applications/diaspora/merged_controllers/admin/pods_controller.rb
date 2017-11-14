
module Admin
  class PodsController < AdminController
    respond_to :html, :json

    def index
      pods_json = PodPresenter.as_collection(Pod.all)

      respond_with do |format|
        format.html do
          gon.preloads[:pods] = pods_json
          gon.unchecked_count = Pod.unchecked.count
          gon.error_count = Pod.check_failed.count

          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
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
 
 t(".pod_network") 

end

        end
        format.json { render json: pods_json }
      end
    end

    def recheck
      pod = Pod.find(params[:pod_id])
      pod.test_connection!

      respond_with do |format|
        format.html { redirect_to admin_pods_path }
        format.json { render json: PodPresenter.new(pod).as_json }
      end
    end
  end
end
