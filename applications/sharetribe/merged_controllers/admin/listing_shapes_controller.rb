class Admin::ListingShapesController < ApplicationController
  before_filter :ensure_is_admin

  before_filter :ensure_no_braintree_or_checkout
  before_filter :set_url_name

  LISTING_SHAPES_NAVI_LINK = "listing_shapes"

  Shape = ListingShapeDataTypes::Shape

  def index
    category_count = @current_community.categories.count
    template_label_key_list = ListingShapeTemplates.new(process_summary).label_key_list

    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {'SiteName' : '#{@current_community.ident}'}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 I18n.locale 
 content_for :head 
  
 
  
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain || @current_community.ident}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {'SiteName' : '#{@current_community.ident}'}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 I18n.locale 
 content_for :head 
  
 
  
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 yield :title_header 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 yield :title_header 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
  end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain || @current_community.ident}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

  end

  def new
    template = ListingShapeTemplates.new(process_summary).find(params[:template], available_locales.map(&:second))

    unless template
      return redirect_to action: :index
    end

    render_new_form(template, process_summary, available_locales())
  end

  def edit
    shape = ShapeService.new(processes).get(
      community_id: @current_community.id,
      name: params[:url_name],
      locales: available_locales.map { |_, locale| locale }
    ).data

    return redirect_to error_not_found_path if shape.nil?

    render_edit_form(params[:url_name], shape, process_summary, available_locales())
  end

  def create
    shape = filter_uneditable_fields(FormViewLayer.params_to_shape(params), process_summary)

    create_result = validate_shape(shape).and_then { |shape|
      ShapeService.new(processes).create(
        community_id: @current_community.id,
        default_locale: @current_community.default_locale,
        opts: shape
      )
    }

    if create_result.success
      flash[:notice] = t("admin.listing_shapes.new.create_success", shape: pick_translation(shape[:name]))
      redirect_to action: :index
    else
      flash.now[:error] = t("admin.listing_shapes.new.create_failure", error_msg: create_result.error_msg)
      render_new_form(shape, process_summary, available_locales())
    end

  end

  def update
    shape = filter_uneditable_fields(FormViewLayer.params_to_shape(params), process_summary)

    update_result = validate_shape(shape).and_then { |shape|
      ShapeService.new(processes).update(
        community_id: @current_community.id,
        name: params[:url_name],
        opts: shape
      )
    }

    if update_result.success
      flash[:notice] = t("admin.listing_shapes.edit.update_success", shape: pick_translation(shape[:name]))
      return redirect_to admin_listing_shapes_path
    else
      flash.now[:error] = t("admin.listing_shapes.edit.update_failure", error_msg: update_result.error_msg)
      return render_edit_form(params[:url_name], shape, process_summary, available_locales())
    end
  end

  def order
    ordered_ids = params[:order].map(&:to_i)

    shapes = all_shapes(community_id: @current_community.id, include_categories: false)

    old_shape_order_id_map = shapes.map { |s|
      {
        id: s[:id],
        sort_priority: s[:sort_priority]
      }
    }

    old_shape_order = old_shape_order_id_map.map { |s| s[:sort_priority] }

    distinguisable_order = old_shape_order.reduce([old_shape_order.first]) { |memo, x|
      last = memo.last
      if x <= last
        memo << last + 1
      else
        memo << x
      end
    }

    new_shape_order_id_map = ordered_ids.zip(distinguisable_order).map { |id, sort|
      {
        id: id,
        sort_priority: sort
      }
    }

    diff = ArrayUtils.diff_by_key(old_shape_order_id_map, new_shape_order_id_map, :id)

    diff.select { |d| d[:action] == :changed }.each { |d|
      opts = { sort_priority: d[:value][:sort_priority]}
      listing_api.shapes.update(community_id: @current_community.id, listing_shape_id: d[:value][:id], opts: opts)
    }

    render nothing: true, status: 200
  end

  def close_listings
    listing_api.shapes.get(community_id: @current_community.id, name: params[:url_name]).and_then { |shape|
      listing_api.listings.update_all(community_id: @current_community.id, query: { listing_shape_id: shape[:id] }, opts: { open: false })
    }.on_success {
      flash[:notice] = t("admin.listing_shapes.successfully_closed")
      return redirect_to action: :edit, id: params[:url_name]
    }.on_error {
      flash[:error] = t("admin.listing_shapes.can_not_find_name", name: params[:url_name])
      return redirect_to action: :index
    }
  end

  def destroy
    can_delete_shape?(params[:url_name], all_shapes(community_id: @current_community.id, include_categories: true)).and_then { |s|
      listing_api.listings.update_all(community_id: @current_community.id, query: { listing_shape_id: s[:id] }, opts: { open: false, listing_shape_id: nil })
    }.and_then {
      listing_api.shapes.delete(
        community_id: @current_community.id,
        name: params[:url_name]
      )
    }.on_success { |deleted_shape|
      flash[:notice] = t("admin.listing_shapes.successfully_deleted", order_type: t(deleted_shape[:name_tr_key]))
    }.on_error { |error_msg|
      flash[:error] = "Cannot delete order type, error: #{error_msg}"
    }

    redirect_to action: :index
  end

  private

  def filter_uneditable_fields(shape, process_summary)
    uneditable_keys = uneditable_fields(process_summary, shape[:author_is_seller]).select { |_, uneditable| uneditable }.keys
    shape.except(*uneditable_keys)
  end

  def uneditable_fields(process_summary, author_is_seller)
    {
      shipping_enabled: !process_summary[:preauthorize_available] || !author_is_seller,
      online_payments: !process_summary[:preauthorize_available] || !author_is_seller,
    }
  end

  def render_new_form(form, process_summary, available_locs)
    locals = common_locals(form, 0, process_summary, available_locs)
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {'SiteName' : '#{@current_community.ident}'}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 I18n.locale 
 content_for :head 
  
 
  
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 t("layouts.admin.admin") 
 "-" 
 t("admin.listing_shapes.index.listing_shapes") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t("admin.listing_shapes.index.listing_shapes") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
   
 content_for :javascript do 
 end 
  
 t(".create_listing_shape") 
 form_tag(admin_listing_shapes_path, method: :post, id: "listing_shape_form") do 
  label_tag("", t("admin.listing_shapes.listing_shape_name"), class: "input") 
 translation_label_class = locale_name_mapping.size > 1 ? "col-2" : "hidden" 
 shape[:name].map do |(loc, translation)| 
 translation_label_class 
 label_tag "name[#{loc}]", locale_name_mapping[loc], class: "listing-shape-locale-label" 
 text_field_tag("name[#{loc}]", translation, class: "required", placeholder: t("admin.listing_shapes.listing_shape_name_placeholder")) 
 end 
 label_tag("", t("admin.listing_shapes.action_button_label"), class: "input") 
 shape[:action_button_label].map do |loc, translation| 
 translation_label_class 
 label_tag "action_button_label[#{loc}]", locale_name_mapping[loc], class: "listing-shape-locale-label" 
 text_field_tag("action_button_label[#{loc}]", translation, class: "required", placeholder: t("admin.listing_shapes.action_button_placeholder")) 
 end 
 if count > 0 
 icon_tag("alert", ["icon-fix"]) 
 t("admin.listing_shapes.open_listings_warning", count: count) 
 link_to close_listings_admin_listing_shape_path, class: "listing-shape-delete-button", confirm: t("admin.listing_shapes.confirm_close_listings_action", count: count) do 
 t("admin.listing_shapes.close_listings_action", count: count) 
 end 
 end 
 label_tag("", t("admin.listing_shapes.pricing_and_checkout_title"), class: "input") 
 check_box_tag(:price_enabled, "true", shape[:price_enabled], class: "checkbox-row-checkbox js-price-enabled") 
 label_tag(:price_enabled, t("admin.listing_shapes.price_label"), class: "checkbox-row-label js-price-enabled-label") 
 unless uneditable_fields[:online_payments] 
 check_box_tag(:online_payments, "true", shape[:online_payments], class: "checkbox-row-checkbox js-online-payments") 
 label_tag(:online_payments, t("admin.listing_shapes.online_payments_label"), class: "checkbox-row-label js-online-payments-label") 
 end 
 unless uneditable_fields[:shipping_enabled] 
 check_box_tag(:shipping_enabled, "true", shape[:shipping_enabled], class: "checkbox-row-checkbox js-shipping-enabled") 
 label_tag(:shipping_enabled, t("admin.listing_shapes.shipping_label"), class: "checkbox-row-label js-shipping-enabled-label") 
 end 
 label_tag("units_title", t("admin.listing_shapes.units_title"), class: "input") 
  icon_tag("information") 
 text 
 
 shape[:predefined_units].map do |unit| 
 check_box_tag("units[#{unit[:type]}]", "true", unit[:enabled], class: "js-unit-checkbox checkbox-row-checkbox") 
 label_tag("units[#{unit[:type]}]", unit[:label], class: "checkbox-row-label js-unit-label") 
 end 
 shape[:custom_units].each_with_index do |unit, index| 
 index 
 hidden_field_tag("custom_units[existing][#{index}]", unit[:value]) 
 label_tag("custom_units[existing][#{index}]", "#{t('admin.listing_shapes.custom_unit_form.per')} #{unit[:name][I18n.locale.to_s]}", class: "js-unit-label checkbox-row-label") 
 link_to_function(t("admin.listing_shapes.delete_custom_unit"), "", class: "js-remove-custom-unit", data: {customUnitIndex: index}) 
 end 
 t("admin.listing_shapes.add_custom_unit") 
 icon_tag("cross", ["listing-shape-close-custom-unit-form", "js-listing-shape-close-custom-unit-form"]) 
 label_tag("custom_units_title", t("admin.listing_shapes.custom_unit_form.title"), class: "input") 
 label_tag("", t("admin.listing_shapes.custom_unit_form.label_heading"), class: "input") 
 @current_community.locales.each do |locale| 
 input_id = "custom_units[new][${uniqueId}][name][#{locale}]" 
 translation_label_class 
 input_id 
 t("admin.communities.available_languages.#{locale}") 
 t('admin.listing_shapes.custom_unit_form.per') 
 input_id 
 input_id 
 t('admin.listing_shapes.custom_unit_form.label_placeholder') 
 :text 
 end 
 label_tag("", t("admin.listing_shapes.custom_unit_form.selector_label_heading"), class: "input") 
 @current_community.locales.each do |locale| 
 input_id = "custom_units[new][${uniqueId}][selector][#{locale}]" 
 translation_label_class 
 input_id 
 t("admin.communities.available_languages.#{locale}") 
 input_id 
 input_id 
 t('admin.listing_shapes.custom_unit_form.selector_placeholder') 
 :text 
 end 
 label_tag("", t("admin.listing_shapes.custom_unit_form.unit_type.heading"), class: "input") 
 quantity_radio_id = "custom_units_${uniqueId}_type_quantity" 
 quantity_radio_id 
 :radio 
 quantity_radio_id 
 t("admin.listing_shapes.custom_unit_form.unit_type.quantity_label") 
 time_radio_id = "custom_units_${uniqueId}_type_time" 
 time_radio_id 
 :radio 
 time_radio_id 
 t("admin.listing_shapes.custom_unit_form.unit_type.time_label") 
 hidden_field_tag("author_is_seller", shape[:author_is_seller]) 
 
 end 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain || @current_community.ident}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

  end

  def render_edit_form(url_name, form, process_summary, available_locs)
    can_delete_res = can_delete_shape?(url_name, all_shapes(community_id: @current_community.id, include_categories: true))
    cant_delete = !can_delete_res.success
    cant_delete_reason = cant_delete ? can_delete_res.error_msg : nil

    count = listing_api.listings.count(
      community_id: @current_community.id,
      query: {
        listing_shape_id: form[:id],
        open: true
      }).data

    locals = common_locals(form, count, process_summary, available_locs).merge(
      url_name: url_name,
      name: pick_translation(form[:name]),
      cant_delete: cant_delete,
      cant_delete_reason: cant_delete_reason
    )
    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
   if APP_CONFIG.use_kissmetrics 
 "_kms('//i.kissmetrics.com/i.js');_kms('#{APP_CONFIG.kissmetrics_url}');" 
 if @current_user 
 "_kmq.push(['identify', '#{@current_user.id}']);" 
 end 
 if @current_community 
 "_kmq.push(['set', {'SiteName' : '#{@current_community.ident}'}]);" 
 else 
 "_kmq.push(['set', {'SiteName' : 'dashboard'}]);" 
 end 
 end 
 
 I18n.locale 
 content_for :head 
  
 
  
 if display_expiration_notice? 
  content_for :javascript do 
 end 
 t("expiration.title") 
 t("expiration.sub_title_new") 
 external_plan_service_login_url 
 t("expiration.link_to_external_service") 
 t("expiration.need_more_info") 
 t("expiration.contact_us") 
 
 end 
 content_for(:page_content) do 
 with_big_cover_photo do 
 t("layouts.admin.admin") 
 "-" 
 t("admin.listing_shapes.index.listing_shapes") 
 end 
 with_small_cover_photo do 
 yield(:coverfade_class) 
 t("layouts.admin.admin") 
 "-" 
 t("admin.listing_shapes.index.listing_shapes") 
 end 
  { :notice => "ss-check", :warning => "ss-info", :error => "ss-alert" }.each do |announcement, icon_class| 
 if flash[announcement] 
 announcement.to_s 
 icon_class 
 flash[announcement] 
 end 
 end 
 
   
 content_for :javascript do 
 end 
  
 t(".edit_listing_shape", shape: name) 
 form_tag(admin_listing_shape_path(url_name), method: :put, id: "listing_shape_form") do 
  label_tag("", t("admin.listing_shapes.listing_shape_name"), class: "input") 
 translation_label_class = locale_name_mapping.size > 1 ? "col-2" : "hidden" 
 shape[:name].map do |(loc, translation)| 
 translation_label_class 
 label_tag "name[#{loc}]", locale_name_mapping[loc], class: "listing-shape-locale-label" 
 text_field_tag("name[#{loc}]", translation, class: "required", placeholder: t("admin.listing_shapes.listing_shape_name_placeholder")) 
 end 
 label_tag("", t("admin.listing_shapes.action_button_label"), class: "input") 
 shape[:action_button_label].map do |loc, translation| 
 translation_label_class 
 label_tag "action_button_label[#{loc}]", locale_name_mapping[loc], class: "listing-shape-locale-label" 
 text_field_tag("action_button_label[#{loc}]", translation, class: "required", placeholder: t("admin.listing_shapes.action_button_placeholder")) 
 end 
 if count > 0 
 icon_tag("alert", ["icon-fix"]) 
 t("admin.listing_shapes.open_listings_warning", count: count) 
 link_to close_listings_admin_listing_shape_path, class: "listing-shape-delete-button", confirm: t("admin.listing_shapes.confirm_close_listings_action", count: count) do 
 t("admin.listing_shapes.close_listings_action", count: count) 
 end 
 end 
 label_tag("", t("admin.listing_shapes.pricing_and_checkout_title"), class: "input") 
 check_box_tag(:price_enabled, "true", shape[:price_enabled], class: "checkbox-row-checkbox js-price-enabled") 
 label_tag(:price_enabled, t("admin.listing_shapes.price_label"), class: "checkbox-row-label js-price-enabled-label") 
 unless uneditable_fields[:online_payments] 
 check_box_tag(:online_payments, "true", shape[:online_payments], class: "checkbox-row-checkbox js-online-payments") 
 label_tag(:online_payments, t("admin.listing_shapes.online_payments_label"), class: "checkbox-row-label js-online-payments-label") 
 end 
 unless uneditable_fields[:shipping_enabled] 
 check_box_tag(:shipping_enabled, "true", shape[:shipping_enabled], class: "checkbox-row-checkbox js-shipping-enabled") 
 label_tag(:shipping_enabled, t("admin.listing_shapes.shipping_label"), class: "checkbox-row-label js-shipping-enabled-label") 
 end 
 label_tag("units_title", t("admin.listing_shapes.units_title"), class: "input") 
  icon_tag("information") 
 text 
 
 shape[:predefined_units].map do |unit| 
 check_box_tag("units[#{unit[:type]}]", "true", unit[:enabled], class: "js-unit-checkbox checkbox-row-checkbox") 
 label_tag("units[#{unit[:type]}]", unit[:label], class: "checkbox-row-label js-unit-label") 
 end 
 shape[:custom_units].each_with_index do |unit, index| 
 index 
 hidden_field_tag("custom_units[existing][#{index}]", unit[:value]) 
 label_tag("custom_units[existing][#{index}]", "#{t('admin.listing_shapes.custom_unit_form.per')} #{unit[:name][I18n.locale.to_s]}", class: "js-unit-label checkbox-row-label") 
 link_to_function(t("admin.listing_shapes.delete_custom_unit"), "", class: "js-remove-custom-unit", data: {customUnitIndex: index}) 
 end 
 t("admin.listing_shapes.add_custom_unit") 
 icon_tag("cross", ["listing-shape-close-custom-unit-form", "js-listing-shape-close-custom-unit-form"]) 
 label_tag("custom_units_title", t("admin.listing_shapes.custom_unit_form.title"), class: "input") 
 label_tag("", t("admin.listing_shapes.custom_unit_form.label_heading"), class: "input") 
 @current_community.locales.each do |locale| 
 input_id = "custom_units[new][${uniqueId}][name][#{locale}]" 
 translation_label_class 
 input_id 
 t("admin.communities.available_languages.#{locale}") 
 t('admin.listing_shapes.custom_unit_form.per') 
 input_id 
 input_id 
 t('admin.listing_shapes.custom_unit_form.label_placeholder') 
 :text 
 end 
 label_tag("", t("admin.listing_shapes.custom_unit_form.selector_label_heading"), class: "input") 
 @current_community.locales.each do |locale| 
 input_id = "custom_units[new][${uniqueId}][selector][#{locale}]" 
 translation_label_class 
 input_id 
 t("admin.communities.available_languages.#{locale}") 
 input_id 
 input_id 
 t('admin.listing_shapes.custom_unit_form.selector_placeholder') 
 :text 
 end 
 label_tag("", t("admin.listing_shapes.custom_unit_form.unit_type.heading"), class: "input") 
 quantity_radio_id = "custom_units_${uniqueId}_type_quantity" 
 quantity_radio_id 
 :radio 
 quantity_radio_id 
 t("admin.listing_shapes.custom_unit_form.unit_type.quantity_label") 
 time_radio_id = "custom_units_${uniqueId}_type_time" 
 time_radio_id 
 :radio 
 time_radio_id 
 t("admin.listing_shapes.custom_unit_form.unit_type.time_label") 
 hidden_field_tag("author_is_seller", shape[:author_is_seller]) 
 
 end 
 end 
 if params[:controller] == "homepage" && params[:action] == "index" 
 params.except("action", "controller", "q", "view", "utf8").each do |param, value| 
 unless param.match(/^filter_option/) || param.match(/^checkbox_filter_option/) || param.match(/^nf_/) || param.match(/^price_/) 
 hidden_field_tag param, value 
 end 
 end 
 hidden_field_tag "view", @view_type 
 content_for(:page_content) 
 else 
 content_for(:page_content) 
 end 
  if (APP_CONFIG.use_google_analytics) 
 "_gaq.push(['_setAccount', '#{APP_CONFIG.google_analytics_key}']);" 
 "_gaq.push(['_setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 if @current_community && @current_community.google_analytics_key 
 "_gaq.push(['b._setAccount', '#{@current_community.google_analytics_key}']);" 
 "_gaq.push(['b._setDomainName', '.#{PublicSuffix.parse(request.host).domain}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{Maybe(@current_community.name(I18n.locale)).gsub("'","").or_else("")}']);" 
 "_gaq.push(['b._addIgnoredOrganic', '#{@current_community.domain || @current_community.ident}']);" 
 end 
 end 
 
 content_for(:location_search) 
  
 javascript_include_tag 'application' 
 if @analytics_event 
 end 
 if Rails.env.test? 
 end 
 content_for :extra_javascript 
  t('error_pages.no_javascript.javascript_is_disabled_in_your_browser') 
 t('error_pages.no_javascript.kassi_does_not_currently_work_without_javascript') 
 

end

  end

  def common_locals(form, count, process_summary, available_locs)
    { selected_left_navi_link: LISTING_SHAPES_NAVI_LINK,
      uneditable_fields: uneditable_fields(process_summary, form[:author_is_seller]),
      shape: FormViewLayer.shape_to_locals(form),
      count: count,
      locale_name_mapping: available_locs.map { |name, l| [l, name] }.to_h
    }
  end

  def can_delete_shape?(current_shape_name, shapes)
    listing_shapes_categories_map = shapes.map { |shape|
      [shape[:name], shape[:category_ids]]
    }

    categories_listing_shapes_map = HashUtils.transpose(listing_shapes_categories_map)

    last_in_category_ids = categories_listing_shapes_map.select { |category_id, shape_names|
      shape_names.size == 1 && shape_names.include?(current_shape_name)
    }.keys

    shape = shapes.find { |s| s[:name] == current_shape_name }

    if !shape
      Result::Error.new(t("admin.listing_shapes.can_not_find_name", name: current_shape_name))
    elsif shapes.length == 1
      Result::Error.new(t("admin.listing_shapes.edit.can_not_delete_last"))
    elsif !last_in_category_ids.empty?
      categories = ListingService::API::Api.categories.get_all(community_id: @current_community).data
      category_names = pick_category_names(categories, last_in_category_ids, I18n.locale)

      Result::Error.new(t("admin.listing_shapes.edit.can_not_delete_only_one_in_categories", categories: category_names.join(", ")))
    else
      Result::Success.new(shape)
    end
  end

  def pick_category_names(categories, ids, locale)
    locale = locale.to_s

    pick_categories(categories, ids)
      .map { |c| Maybe(c[:translations].find { |t| t[:locale] == locale }).or_else(c[:translations].first) }
      .map { |t| t[:name] }
  end

  def pick_categories(category_tree, ids)
    category_tree.reduce([]) { |acc, category|
      if ids.include?(category[:id])
        acc << category
      end

      if category[:children].present?
        acc.concat(pick_categories(category[:children], ids))
      end

      acc
    }
  end

  def listing_api
    ListingService::API::Api
  end

  def all_shapes(community_id:, include_categories:)
    listing_api.shapes.get(community_id: community_id, include_categories: include_categories)
      .maybe()
      .or_else([])
  end

  def process_summary
    @process_summary ||= processes.reduce({}) { |info, process|
      info[:preauthorize_available] = true if process[:process] == :preauthorize
      info[:request_available] = true if process[:author_is_seller] == false
      info
    }
  end

  def processes
    @processes ||= TransactionService::API::Api.processes.get(community_id: @current_community.id)[:data]
  end

  def validate_shape(form)
    form = Shape.call(form)

    errors = []

    if form[:shipping_enabled] && !form[:online_payments]
      errors << "Shipping cannot be enabled without online payments"
    end

    if form[:online_payments] && !form[:price_enabled]
      errors << "Online payments cannot be enabled without price"
    end

    if (form[:units].present? || form[:custom_units].present?) && !form[:price_enabled]
      errors << "Price units cannot be used without price field"
    end

    if errors.empty?
      Result::Success.new(form)
    else
      Result::Error.new(errors.join(", "))
    end
  end

  def pick_translation(translations)
    translations.find { |(locale, translation)|
      locale.to_s == I18n.locale.to_s
    }.second
  end

  def ensure_no_braintree_or_checkout
    gw = PaymentGateway.where(community_id: @current_community.id).first
    if !@current_user.is_admin? && gw
      flash[:error] = "Not available for your payment gateway: #{gw.type}"
      redirect_to edit_details_admin_community_path(@current_community.id)
    end
  end

  # FormViewLayer provides helper functions to transform:
  # - Shape hash to renderable format
  # - params from form back to Shape
  #
  module FormViewLayer
    module_function

    def params_to_shape(params)
      form_params = HashUtils.symbolize_keys(params)

      units = parse_predefined_units(form_params[:units])
        .concat(parse_existing_custom_units(Maybe(form_params)[:custom_units][:existing].or_else([])))
        .concat(parse_new_custom_units(Maybe(form_params)[:custom_units][:new].or_else([])))

      parsed_params = form_params.merge(
        units: units,
        author_is_seller: form_params[:author_is_seller] == "false" ? false : true # default true
      )

      Shape.call(parsed_params)
    end

    def shape_to_locals(shape)
      shape = Shape.call(shape)

      shape.merge(
        predefined_units: expand_predefined_units(shape[:units]),
        custom_units: encode_custom_units(shape[:units].select { |unit| unit[:type] == :custom })
      )
    end

    # private

    def expand_predefined_units(shape_units)
      shape_units_set = shape_units.map { |t| t[:type] }.to_set

      ListingShapeHelper.predefined_unit_types
        .map { |t| {type: t, enabled: shape_units_set.include?(t), label: I18n.t("admin.listing_shapes.units.#{t}")} }
    end

    def encode_custom_units(custom_units)
      custom_units.map { |u|
        {
          name: u[:name],
          value: ListingShapeDataTypes::Unit.serialize(u)
        }
      }
    end

    def parse_predefined_units(selected_units)
      (selected_units || []).map { |type, _| {type: type.to_sym, enabled: true}}
    end

    def parse_existing_custom_units(existing_units)
      existing_units.map { |_, unit|
        ListingShapeDataTypes::Unit.deserialize(unit)
          .merge({type: :custom, enabled: true})
      }
    end

    def parse_new_custom_units(new_units)
      new_units.map(&:second).map { |u|
        u.merge(type: :custom, enabled: true)
          .except(:name_tr_key, :selector_tr_key)
      }
    end
  end

  # The shape name is used as 'id'
  def set_url_name
    params[:url_name] = params[:id]
    params.delete :id
  end
end
