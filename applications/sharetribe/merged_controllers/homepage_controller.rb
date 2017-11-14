# encoding: utf-8
class HomepageController < ApplicationController

  before_filter :save_current_path, :except => :sign_in

  APP_DEFAULT_VIEW_TYPE = "grid"
  VIEW_TYPES = ["grid", "list", "map"]

  def index
    @homepage = true

    @view_type = HomepageController.selected_view_type(params[:view], @current_community.default_browse_view, APP_DEFAULT_VIEW_TYPE, VIEW_TYPES)

    @categories = @current_community.categories.includes(:children)
    @main_categories = @categories.select { |c| c.parent_id == nil }

    all_shapes = shapes.get(community_id: @current_community.id)[:data]

    # This assumes that we don't never ever have communities with only 1 main share type and
    # only 1 sub share type, as that would make the listing type menu visible and it would look bit silly
    listing_shape_menu_enabled = all_shapes.size > 1
    @show_categories = @categories.size > 1
    show_price_filter = @current_community.show_price_filter && all_shapes.any? { |s| s[:price_enabled] }
    @show_custom_fields = @current_community.custom_fields.any?(&:can_filter?) || show_price_filter
    @category_menu_enabled = @show_categories || @show_custom_fields

    @app_store_badge_filename = "/assets/Available_on_the_App_Store_Badge_en_135x40.svg"
    if File.exists?("app/assets/images/Available_on_the_App_Store_Badge_#{I18n.locale}_135x40.svg")
       @app_store_badge_filename = "/assets/Available_on_the_App_Store_Badge_#{I18n.locale}_135x40.svg"
    end

    filter_params = {}

    listing_shape_param = params[:transaction_type]

    all_shapes = shapes.get(community_id: @current_community.id)[:data]
    selected_shape = all_shapes.find { |s| s[:name] == listing_shape_param }

    filter_params[:listing_shape] = Maybe(selected_shape)[:id].or_else(nil)

    compact_filter_params = HashUtils.compact(filter_params)

    per_page = @view_type == "map" ? APP_CONFIG.map_listings_limit : APP_CONFIG.grid_listings_limit

    includes =
      case @view_type
      when "grid"
        [:author, :listing_images]
      when "list"
        [:author, :listing_images, :num_of_reviews]
      when "map"
        [:location]
      else
        raise ArgumentError.new("Unknown view_type #{@view_type}")
      end

    search_result = find_listings(params, per_page, compact_filter_params, includes.to_set)

    shape_name_map = all_shapes.map { |s| [s[:id], s[:name]]}.to_h

    if request.xhr? # checks if AJAX request
      search_result.on_success { |listings|
        @listings = listings # TODO Remove

        if @view_type == "grid" then
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
 
  frontpage_fragment_cache("grid_item", listing) do 
  link_to(listing_path(listing.url), :class => "#{modifier_class} fluid-thumbnail-grid-image-item-link") do 
 modifier_class 
 with_first_listing_image(listing) do |first_image_url| 
 image_tag first_image_url, {:alt => listed_listing_title(listing), :class => "#{modifier_class} fluid-thumbnail-grid-image-image"} 
 end 
 modifier_class 
 modifier_class 
 listing.title 
 modifier_class 
 if listing.price 
 humanized_money_with_symbol(listing.price).upcase 
 price_unit = price_quantity_slash_unit(listing) 
 if !price_unit.blank? 
 price_text = " " + price_unit 
 price_text 
 price_text 
 end 
 else 
 modifier_class 
 shape_name(listing) 
 end 
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

        else
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
 
  frontpage_fragment_cache("list_item", listing) do 
 if listing.listing_images.size > 0 
 link_to listing_path(listing.url), :class => "home-list-image-container-desktop" do 
 image_tag listing.listing_images.first[:small_3x2], {:alt => listed_listing_title(listing), :class => "home-list-image"} 
 end 
 end 
 if listing.listing_images.size > 0 
 link_to listing_path(listing.url), :class => "home-list-image-container-mobile" do 
 image_tag listing.listing_images.first[:thumb], {:alt => listed_listing_title(listing), :class => "home-list-image"} 
 end 
 end 
 if listing.price 
 humanized_money_with_symbol(listing.price).upcase 
 price_text = nil 
 if listing.quantity.present? 
 price_text = t("listings.form.price.per") + " " + listing.quantity 
 elsif listing.unit_type 
 price_text = price_quantity_per_unit(listing) 
 end 
 if price_text.present? 
 price_text 
 price_text 
 end 
 else 
 shape_name(listing) 
 end 
 (listing.listing_images.size > 0 ? "home-list-details-with-image" : "") 
 link_to listing_path(listing.url) do 
 listing.title 
 if @current_community.show_category_in_listing_list 
 root_path(:transaction_type => shape_name_map[listing.listing_shape_id], :view => :list) 
 icon_tag(listing.icon_name, ["icon-fix"]) 
 shape_name(listing) 
 end 
 end 
 (listing.listing_images.size > 0 ? "home-list-author-with-listing-image" : "home-list-author-without-listing-image") 
 link_to(person_path(id: listing.author.username), :class => "home-fluid-thumbnail-grid-author-avatar-image") do 
 image_tag(listing.author.avatar.thumb) 
 end 
 link_to(person_path(id: listing.author.username), :class => "home-list-author-name") do 
 PersonViewUtils::person_entity_display_name(listing.author, @current_community.name_display_type) 
 end 
 if testimonials_in_use 
 if listing.author.num_of_reviews > 0 
 icon_tag("testimonial") 
 pluralize(listing.author.num_of_reviews, t(".review"), t(".reviews")) 
 end 
 end 
 (listing.listing_images.size > 0 ? "home-list-price-mobile-with-listing-image" : "home-list-price-mobile-without-listing-image") 
 if listing.price 
 humanized_money_with_symbol(listing.price).upcase 
 price_text = nil 
 if listing.quantity.present? 
 price_text = t("listings.form.price.per") + " " + listing.quantity 
 elsif listing.unit_type 
 price_text = price_quantity_per_unit(listing) 
 end 
 if price_text.present? 
 price_text 
 price_text 
 end 
 else 
 shape_name(listing) 
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
      }.on_error {
        render nothing: true, status: 500
      }
    else
      search_result.on_success { |listings|
        @listings = listings
        render locals: {
                 shapes: all_shapes,
                 show_price_filter: show_price_filter,
                 selected_shape: selected_shape,
                 shape_name_map: shape_name_map,
                 testimonials_in_use: @current_community.testimonials_in_use,
                 listing_shape_menu_enabled: listing_shape_menu_enabled }
      }.on_error { |e|
        flash[:error] = t("homepage.errors.search_engine_not_responding")
        @listings = Listing.none.paginate(:per_page => 1, :page => 1)
        render status: 500, locals: {
                 shapes: all_shapes,
                 show_price_filter: show_price_filter,
                 selected_shape: selected_shape,
                 shape_name_map: shape_name_map,
                 testimonials_in_use: @current_community.testimonials_in_use,
                 listing_shape_menu_enabled: listing_shape_menu_enabled }
      }
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

  def self.selected_view_type(view_param, community_default, app_default, all_types)
    if view_param.present? and all_types.include?(view_param)
      view_param
    elsif community_default.present? and all_types.include?(community_default)
      community_default
    else
      app_default
    end
  end

  private

  def find_listings(params, listings_per_page, filter_params, includes)
    Maybe(@current_community.categories.find_by_url_or_id(params[:category])).each do |category|
      filter_params[:categories] = category.own_and_subcategory_ids
      @selected_category = category
    end

    filter_params[:search] = params[:q] if params[:q]
    filter_params[:custom_dropdown_field_options] = HomepageController.dropdown_field_options_for_search(params)
    filter_params[:custom_checkbox_field_options] = HomepageController.checkbox_field_options_for_search(params)

    filter_params[:price_cents] = filter_range(params[:price_min], params[:price_max])

    p = HomepageController.numeric_filter_params(params)
    p = HomepageController.parse_numeric_filter_params(p)
    p = HomepageController.group_to_ranges(p)
    numeric_search_params = HomepageController.filter_unnecessary(p, @current_community.custom_numeric_fields)

    filter_params = filter_params.reject {
      |_, value| (value == "all" || value == ["all"])
    } # all means the filter doesn't need to be included

    checkboxes = filter_params[:custom_checkbox_field_options].map { |checkbox_field| checkbox_field.merge(type: :selection_group, operator: :and) }
    dropdowns = filter_params[:custom_dropdown_field_options].map { |dropdown_field| dropdown_field.merge(type: :selection_group, operator: :or) }
    numbers = numeric_search_params.map { |numeric| numeric.merge(type: :numeric_range) }

    search = {
      # Add listing_id
      categories: filter_params[:categories],
      listing_shape_id: Maybe(filter_params)[:listing_shape].or_else(nil),
      price_cents: filter_params[:price_cents],
      keywords: filter_params[:search],
      fields: checkboxes.concat(dropdowns).concat(numbers),
      per_page: listings_per_page,
      page: params[:page].to_i > 0 ? params[:page].to_i : 1
    }

    ListingIndexService::API::Api.listings.search(community_id: @current_community.id, search: search, includes: includes).and_then { |res|
      Result::Success.new(
        ListingIndexViewUtils.to_struct(
        result: res,
        includes: includes,
        page: search[:page],
        per_page: search[:per_page]
      ))
    }
  end

  def filter_range(price_min, price_max)
    if (price_min && price_max)
      min = MoneyUtil.parse_str_to_money(price_min, @current_community.default_currency).cents
      max = MoneyUtil.parse_str_to_money(price_max, @current_community.default_currency).cents

      if ((@current_community.price_filter_min..@current_community.price_filter_max) != (min..max))
        (min..max)
      else
        nil
      end
    end
  end

  # Return all params starting with `numeric_filter_`
  def self.numeric_filter_params(all_params)
    all_params.select { |key, value| key.start_with?("nf_") }
  end

  def self.parse_numeric_filter_params(numeric_params)
    numeric_params.inject([]) do |memo, numeric_param|
      key, value = numeric_param
      _, boundary, id = key.split("_")

      hash = {id: id.to_i}
      hash[boundary.to_sym] = value
      memo << hash
    end
  end

  def self.group_to_ranges(parsed_params)
    parsed_params
      .group_by { |param| param[:id] }
      .map do |key, values|
        boundaries = values.inject(:merge)

        {
          id: key,
          value: (boundaries[:min].to_f..boundaries[:max].to_f)
        }
      end
  end

  # Filter search params if their values equal min/max
  def self.filter_unnecessary(search_params, numeric_fields)
    search_params.reject do |search_param|
      numeric_field = numeric_fields.find(search_param[:id])
      search_param == { id: numeric_field.id, value: (numeric_field.min..numeric_field.max) }
    end
  end

  def self.options_from_params(params, regexp)
    option_ids = HashUtils.select_by_key_regexp(params, regexp).values

    array_for_search = CustomFieldOption.find(option_ids)
      .group_by { |option| option.custom_field_id }
      .map { |key, selected_options| {id: key, value: selected_options.collect(&:id) } }
  end

  def self.dropdown_field_options_for_search(params)
    options_from_params(params, /^filter_option/)
  end

  def self.checkbox_field_options_for_search(params)
    options_from_params(params, /^checkbox_filter_option/)
  end

  def shapes
    ListingService::API::Api.shapes
  end
end
