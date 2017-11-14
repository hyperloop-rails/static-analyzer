module Shoppe
  class StockLevelAdjustmentsController < ApplicationController
    SUITABLE_OBJECTS = ['Shoppe::Product'].freeze
    before_filter do
      fail Shoppe::Error, t('shoppe.stock_level_adjustments.invalid_item_type', suitable_objects:  SUITABLE_OBJECTS.to_sentence) unless SUITABLE_OBJECTS.include?(params[:item_type])
      @item = params[:item_type].constantize.find(params[:item_id].to_i)
    end
    before_filter { params[:id] && @sla = @item.stock_level_adjustments.find(params[:id].to_i) }

    def index
      @stock_level_adjustments = @item.stock_level_adjustments.ordered.page(params[:page]).per(10)
      @new_sla = @item.stock_level_adjustments.build if @new_sla.nil?
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 @page_title = t('shoppe.stock_level_adjustments.stock_levels_title', item_name: @item.name) 
 content_for :header do 
 case @item 
 when Shoppe::Product 
 @active_nav = :products 
 link_to t('shoppe.stock_level_adjustments.edit_product'), [:edit, @item], :class => 'button' 
 link_to t('shoppe.stock_level_adjustments.back_to_product'), :products, :class => 'button' 
 end 
 t('shoppe.stock_level_adjustments.stock_levels_for', item_name: @item.name) 
 end 
 t('shoppe.stock_level_adjustments.current_stock_level_html', item_stock: @item.stock).html_safe 
 page_entries_info @stock_level_adjustments 
 form_for @new_sla do |f| 
 hidden_field_tag 'item_type', params[:item_type] 
 hidden_field_tag 'item_id', params[:item_id] 
 t('shoppe.stock_level_adjustments.date') 
 t('shoppe.stock_level_adjustments.description') 
 t('shoppe.stock_level_adjustments.adjustment') 
 f.text_field :description 
 f.text_field :adjustment 
 f.submit t('shoppe.stock_level_adjustments.add'), :class => 'button button-mini green' 
 for sla in @stock_level_adjustments 
 l(sla.created_at, format: :long) 
 sla.description 
 sla.adjustment > 0  ? "+#{sla.adjustment}" : sla.adjustment 
 end 
 paginate @stock_level_adjustments 
 end 

end

    end

    def create
      @new_sla = @item.stock_level_adjustments.build(params[:stock_level_adjustment].permit(:description, :adjustment))
      if @new_sla.save
        if request.xhr?
          @new_sla = @item.stock_level_adjustments.build
          index
        else
          redirect_to stock_level_adjustments_path(item_id: params[:item_id], item_type: params[:item_type]), notice: t('shoppe.stock_level_adjustments.create_notice')
        end
      else
        if request.xhr?
          render text: @new_sla.errors.full_messages.to_sentence, status: 422
        else
          index
          flash.now[:alert] = @new_sla.errors.full_messages.to_sentence
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag :application 
 javascript_include_tag :application 
 csrf_meta_tags 
 yield :head 
 link_to "Play with Shoppe Admin", "/shoppe" 
 link_to "Browse the code", "http://github.com/tryshoppe/core" 
 display_flash 
 link_to "Home", root_path, :nav_item => :home 
 link_to "Our catalogue", catalogue_path, :nav_item => :catalogue, :class => 'noborder' 
 for category in Shoppe::ProductCategory.ordered 
 link_to category.name, products_path(category.permalink) 
 end 
 link_to "Why shop with us?", page_path(:why), :nav_item => :why 
 link_to "FAQs", page_path(:faqs), :nav_item => :faqs 
 link_to "Get in touch", page_path(:contact), :nav_item => :contact 
 link_to Shoppe.settings.store_name, root_path 
 if @full_header 
 end 
 if @full_header 
 end 
 if content_for?(:sidebar) 
 yield :sidebar 
 else 
  if has_order? && current_order.has_items? 
 link_to "View my bag", basket_path 
 link_to "Checkout", checkout_path, :class => 'checkout' 
 else 
 end 
 
 end 
 @page_title = t('shoppe.stock_level_adjustments.stock_levels_title', item_name: @item.name) 
 content_for :header do 
 case @item 
 when Shoppe::Product 
 @active_nav = :products 
 link_to t('shoppe.stock_level_adjustments.edit_product'), [:edit, @item], :class => 'button' 
 link_to t('shoppe.stock_level_adjustments.back_to_product'), :products, :class => 'button' 
 end 
 t('shoppe.stock_level_adjustments.stock_levels_for', item_name: @item.name) 
 end 
 t('shoppe.stock_level_adjustments.current_stock_level_html', item_stock: @item.stock).html_safe 
 page_entries_info @stock_level_adjustments 
 form_for @new_sla do |f| 
 hidden_field_tag 'item_type', params[:item_type] 
 hidden_field_tag 'item_id', params[:item_id] 
 t('shoppe.stock_level_adjustments.date') 
 t('shoppe.stock_level_adjustments.description') 
 t('shoppe.stock_level_adjustments.adjustment') 
 f.text_field :description 
 f.text_field :adjustment 
 f.submit t('shoppe.stock_level_adjustments.add'), :class => 'button button-mini green' 
 for sla in @stock_level_adjustments 
 l(sla.created_at, format: :long) 
 sla.description 
 sla.adjustment > 0  ? "+#{sla.adjustment}" : sla.adjustment 
 end 
 paginate @stock_level_adjustments 
 end 
 link_to "Terms & Conditions", page_path(:terms) 
 link_to "Privacy policy", page_path(:privacy) 
 link_to "Returns policy", page_path(:returns) 
 link_to "Frequently asked questions", page_path(:faqs) 
 link_to "Cookie policy", page_path(:cookies) 
 link_to "Twitter", 'http://twitter.com/niftyware' 
 link_to "Facebook", "http://facebook.com/niftyware" 
 link_to "Pinterest", "http://pinterest.com" 
 link_to "Linked In", "http://linkedin.com" 
 link_to "Vimeo", "http://vimeo.com" 
 link_to "Youtube", "http://youtube.com" 

end

        end
      end
    end
  end
end
