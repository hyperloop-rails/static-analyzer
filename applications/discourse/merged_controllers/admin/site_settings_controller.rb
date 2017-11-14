class Admin::SiteSettingsController < Admin::AdminController

  def index
    render_json_dump(site_settings: SiteSetting.all_settings, diags: SiteSetting.diags)
  end

  def update
    params.require(:id)
    id = params[:id]
    value = params[id]
    value.strip! if value.is_a?(String)
    begin
      prev_value = SiteSetting.send(id)
      SiteSetting.set(id, value)
      StaffActionLogger.new(current_user).log_site_setting_change(id, prev_value, value) if SiteSetting.has_setting?(id)
      render nothing: true
    rescue Discourse::InvalidParameters => e
      render json: {errors: [e.message]}, status: 422
    end
  end

end
