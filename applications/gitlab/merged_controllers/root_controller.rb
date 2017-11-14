# RootController
#
# This controller exists solely to handle requests to `root_url`. When a user is
# logged in and has customized their `dashboard` setting, they will be
# redirected to their preferred location.
#
# For users who haven't customized the setting, we simply delegate to
# `DashboardController#show`, which is the default.
class RootController < Dashboard::ProjectsController
  before_action :redirect_to_custom_dashboard, only: [:index]

  def index
    super
  end

  private

  def redirect_to_custom_dashboard
    return unless current_user

    case current_user.dashboard
    when 'stars'
      flash.keep
      redirect_to starred_dashboard_projects_path
    when 'project_activity'
      redirect_to activity_dashboard_path
    when 'starred_project_activity'
      redirect_to activity_dashboard_path(filter: 'starred')
    when 'groups'
      redirect_to dashboard_groups_path
    when 'todos'
      redirect_to dashboard_todos_path
    else
      return
    end
  end
end
