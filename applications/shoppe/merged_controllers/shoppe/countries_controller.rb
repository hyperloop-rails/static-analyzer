module Shoppe
  class CountriesController < Shoppe::ApplicationController
    before_filter { @active_nav = :countries }
    before_filter { params[:id] && @country = Shoppe::Country.find(params[:id]) }

    def index
      @countries = Shoppe::Country.ordered
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag 'shoppe/application' 
 javascript_include_tag 'shoppe/application' 
 csrf_meta_tags 
 link_to "Shoppe", root_path 
 t('.logged_in_as', user_name: current_user.full_name) 
 for item in Shoppe::NavigationManager.find(:admin_primary).items 
 navigation_manager_link item 
 end 
 link_to t('.logout'), [:logout], :method => :delete 
 link_to t('shoppe.countries.new_country') , :new_country, class: 'button green' 
 t('shoppe.countries.countries') 
 display_flash 
 @page_title = t('shoppe.countries.countries') 
  
 t('shoppe.countries.name') 
 t('shoppe.countries.iso_alpha_2') 
 t('shoppe.countries.iso_alpha_3') 
 t('shoppe.countries.continent') 
 t('shoppe.countries.tld') 
 t('shoppe.countries.eu?') 
 for country in @countries 
 link_to country.name, [:edit, country] 
 country.code2 
 country.code3 
 country.continent 
 country.tld 
 boolean_tag country.eu_member? 
 end 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def new
      @country = Shoppe::Country.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag 'shoppe/application' 
 javascript_include_tag 'shoppe/application' 
 csrf_meta_tags 
 link_to "Shoppe", root_path 
 t('.logged_in_as', user_name: current_user.full_name) 
 for item in Shoppe::NavigationManager.find(:admin_primary).items 
 navigation_manager_link item 
 end 
 link_to t('.logout'), [:logout], :method => :delete 
 link_to t('shoppe.countries.back') , :countries, class: 'button' 
 t('shoppe.countries.countries') 
 display_flash 
 @page_title = t('shoppe.countries.countries') 
  
  form_for @country do |f| 
 f.error_messages 
 field_set_tag t('shoppe.countries.country_details') do 
 f.label :name, t('shoppe.countries.name') 
 f.text_field :name, class: 'focus text' 
 f.label :code2, t('shoppe.countries.iso_alpha_2') 
 f.text_field :code2, class: 'text' 
 f.label :code3, t('shoppe.countries.iso_alpha_3') 
 f.text_field :code3, class: 'text' 
 f.label :continent, t('shoppe.countries.continent') 
 f.text_field :continent, class: 'text' 
 f.label :tld, t('shoppe.countries.tld') 
 f.text_field :tld, class: 'text' 
 f.label :eu_member, t('shoppe.countries.eu_member') 
 f.check_box :eu_member 
 f.label :eu_member, t('shoppe.countries.is_eu_member') 
 end 
 unless @country.new_record? 
 link_to t('shoppe.delete'), @country, class: 'button purple',          method: :delete, data: { confirm: t('shoppe.countries.delete_confirmation') } 
 end 
 f.submit t('shoppe.submit'), class: 'button green' 
 link_to t('shoppe.cancel'), :countries, class: 'button' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def create
      @country = Shoppe::Country.new(safe_params)
      if @country.save
        redirect_to :countries, flash: { notice: t('shoppe.countries.create_notice') }
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag 'shoppe/application' 
 javascript_include_tag 'shoppe/application' 
 csrf_meta_tags 
 link_to "Shoppe", root_path 
 t('.logged_in_as', user_name: current_user.full_name) 
 for item in Shoppe::NavigationManager.find(:admin_primary).items 
 navigation_manager_link item 
 end 
 link_to t('.logout'), [:logout], :method => :delete 
 link_to t('shoppe.countries.back') , :countries, class: 'button' 
 t('shoppe.countries.countries') 
 display_flash 
 @page_title = t('shoppe.countries.countries') 
  
  form_for @country do |f| 
 f.error_messages 
 field_set_tag t('shoppe.countries.country_details') do 
 f.label :name, t('shoppe.countries.name') 
 f.text_field :name, class: 'focus text' 
 f.label :code2, t('shoppe.countries.iso_alpha_2') 
 f.text_field :code2, class: 'text' 
 f.label :code3, t('shoppe.countries.iso_alpha_3') 
 f.text_field :code3, class: 'text' 
 f.label :continent, t('shoppe.countries.continent') 
 f.text_field :continent, class: 'text' 
 f.label :tld, t('shoppe.countries.tld') 
 f.text_field :tld, class: 'text' 
 f.label :eu_member, t('shoppe.countries.eu_member') 
 f.check_box :eu_member 
 f.label :eu_member, t('shoppe.countries.is_eu_member') 
 end 
 unless @country.new_record? 
 link_to t('shoppe.delete'), @country, class: 'button purple',          method: :delete, data: { confirm: t('shoppe.countries.delete_confirmation') } 
 end 
 f.submit t('shoppe.submit'), class: 'button green' 
 link_to t('shoppe.cancel'), :countries, class: 'button' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
    end

    def edit
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag 'shoppe/application' 
 javascript_include_tag 'shoppe/application' 
 csrf_meta_tags 
 link_to "Shoppe", root_path 
 t('.logged_in_as', user_name: current_user.full_name) 
 for item in Shoppe::NavigationManager.find(:admin_primary).items 
 navigation_manager_link item 
 end 
 link_to t('.logout'), [:logout], :method => :delete 
 link_to t('shoppe.countries.back'), :countries, class: 'button' 
 t('shoppe.countries.countries') 
 display_flash 
 @page_title = t('shoppe.countries.countries') 
  
  form_for @country do |f| 
 f.error_messages 
 field_set_tag t('shoppe.countries.country_details') do 
 f.label :name, t('shoppe.countries.name') 
 f.text_field :name, class: 'focus text' 
 f.label :code2, t('shoppe.countries.iso_alpha_2') 
 f.text_field :code2, class: 'text' 
 f.label :code3, t('shoppe.countries.iso_alpha_3') 
 f.text_field :code3, class: 'text' 
 f.label :continent, t('shoppe.countries.continent') 
 f.text_field :continent, class: 'text' 
 f.label :tld, t('shoppe.countries.tld') 
 f.text_field :tld, class: 'text' 
 f.label :eu_member, t('shoppe.countries.eu_member') 
 f.check_box :eu_member 
 f.label :eu_member, t('shoppe.countries.is_eu_member') 
 end 
 unless @country.new_record? 
 link_to t('shoppe.delete'), @country, class: 'button purple',          method: :delete, data: { confirm: t('shoppe.countries.delete_confirmation') } 
 end 
 f.submit t('shoppe.submit'), class: 'button green' 
 link_to t('shoppe.cancel'), :countries, class: 'button' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

    end

    def update
      if @country.update(safe_params)
        redirect_to [:edit, @country], flash: { notice: t('shoppe.countries.update_notice') }
      else
        ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag 'shoppe/application' 
 javascript_include_tag 'shoppe/application' 
 csrf_meta_tags 
 link_to "Shoppe", root_path 
 t('.logged_in_as', user_name: current_user.full_name) 
 for item in Shoppe::NavigationManager.find(:admin_primary).items 
 navigation_manager_link item 
 end 
 link_to t('.logout'), [:logout], :method => :delete 
 link_to t('shoppe.countries.back'), :countries, class: 'button' 
 t('shoppe.countries.countries') 
 display_flash 
 @page_title = t('shoppe.countries.countries') 
  
  form_for @country do |f| 
 f.error_messages 
 field_set_tag t('shoppe.countries.country_details') do 
 f.label :name, t('shoppe.countries.name') 
 f.text_field :name, class: 'focus text' 
 f.label :code2, t('shoppe.countries.iso_alpha_2') 
 f.text_field :code2, class: 'text' 
 f.label :code3, t('shoppe.countries.iso_alpha_3') 
 f.text_field :code3, class: 'text' 
 f.label :continent, t('shoppe.countries.continent') 
 f.text_field :continent, class: 'text' 
 f.label :tld, t('shoppe.countries.tld') 
 f.text_field :tld, class: 'text' 
 f.label :eu_member, t('shoppe.countries.eu_member') 
 f.check_box :eu_member 
 f.label :eu_member, t('shoppe.countries.is_eu_member') 
 end 
 unless @country.new_record? 
 link_to t('shoppe.delete'), @country, class: 'button purple',          method: :delete, data: { confirm: t('shoppe.countries.delete_confirmation') } 
 end 
 f.submit t('shoppe.submit'), class: 'button green' 
 link_to t('shoppe.cancel'), :countries, class: 'button' 
 end 
 
 link_to "&larr; #{t('.goto')} #{Shoppe.settings.store_name}".html_safe, '/' 

end

      end
    end

    def destroy
      @country.destroy
      redirect_to :countries, flash: { notice: t('shoppe.countries.destroy_notice') }
    end

    private

    def safe_params
      params[:country].permit(:name, :code2, :code3, :continent, :tld, :currency, :eu_member)
    end
  end
end
