class NodeInfoController < ApplicationController
  respond_to :json
  respond_to :html, only: :statistics

  def jrd
    render json: NodeInfo.jrd(CGI.unescape(node_info_url("123.123").sub("123.123", "%{version}")))
  end

  def document
    if NodeInfo.supported_version?(params[:version])
      document = NodeInfoPresenter.new(params[:version])
      render json: document, content_type: document.content_type
    else
      head :not_found
    end
  end

  def statistics
    respond_to do |format|
      format.json { render json: StatisticsPresenter.new }
      format.all { @statistics = NodeInfoPresenter.new("1.0") }
    end
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
 
  render "statistics" 
 
 
 yield :after_content 
 include_chartbeat 
 include_mixpanel_guid 
 flash_messages 

end

  end
end
