class EmbedController < ApplicationController
  skip_before_filter :check_xhr, :preload_json, :verify_authenticity_token

  before_filter :ensure_embeddable, except: [ :info ]
  before_filter :ensure_api_request, only: [ :info ]

  layout 'embed'

  def comments
    embed_url = params[:embed_url]
    embed_username = params[:discourse_username]

    topic_id = nil
    if embed_url.present?
      topic_id = TopicEmbed.topic_id_for_embed(embed_url)
    else
      topic_id = params[:topic_id].to_i
    end

    if topic_id
      @topic_view = TopicView.new(topic_id,
                                  current_user,
                                  limit: SiteSetting.embed_post_limit,
                                  exclude_first: true,
                                  exclude_deleted_users: true)

      @second_post_url = "#{@topic_view.topic.url}/2" if @topic_view
      @posts_left = 0
      if @topic_view && @topic_view.posts.size == SiteSetting.embed_post_limit
        @posts_left = @topic_view.topic.posts_count - SiteSetting.embed_post_limit - 1
      end

      if @topic_view
        @reply_count = @topic_view.topic.posts_count - 1
        @reply_count = 0 if @reply_count < 0
      end

    elsif embed_url.present?
      Jobs.enqueue(:retrieve_topic, user_id: current_user.try(:id), embed_url: embed_url, author_username: embed_username)
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag 'embed' 
 unless customization_disabled? 
 SiteCustomization.custom_stylesheet(session[:preview_style], :embedded) 
 end 
 javascript_include_tag 'break_string' 
 if @topic_view && @topic_view.page_title.present? 
 @topic_view.page_title 
 SiteSetting.title 
 end 
 request.referer 
 t 'embed.loading' 
 link_to(image_tag(SiteSetting.logo_url, class: 'logo'), Discourse.base_url) 

end

    end

    discourse_expires_in 1.minute
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 stylesheet_link_tag 'embed' 
 unless customization_disabled? 
 SiteCustomization.custom_stylesheet(session[:preview_style], :embedded) 
 end 
 javascript_include_tag 'break_string' 
 if @topic_view && @topic_view.page_title.present? 
 @topic_view.page_title 
 SiteSetting.title 
 end 
 request.referer 
 if @topic_view.topic.posts_count < 2 
 link_to(I18n.t('embed.start_discussion'), @topic_view.topic.url, class: 'button', target: '_blank') 
 elsif @topic_view.topic.posts_count > 10 
 link_to(I18n.t('embed.continue'), @second_post_url, class: 'button', target: '_blank') 
 end 
 I18n.t('embed.replies', count: @reply_count) 
 if @topic_view.posts.present? 
 @topic_view.posts.each do |post| 
 if post.trashed? 
 end 
 post.id.to_s 
 link_to embed_post_date(post.created_at), post.full_url, title: post.created_at.strftime("%B %e, %Y %l:%M%P"), class: 'post-date', target: "_blank" 
 if post.reply_to_post.present? && !post.cooked.index('aside') 
 link_to I18n.t('embed.in_reply_to', username: post.reply_to_post.username), post.reply_to_post.full_url, 'data-link-to-post' => post.reply_to_post.id.to_s, :class => 'in-reply-to' 
 end 
 Discourse.base_url 
 post.username 
 post.user.small_avatar_url 
 Discourse.base_url 
 post.username 
 if post.user.staff? 
 end 
 if post.user.new_user? 
 end 
 post.user.username 
 if post.user.title.present? 
 post.user.title 
 end 
 get_html(post.cooked) 
 if post.reply_count > 0 
 if post.reply_count == 1 
 link_to I18n.t('embed.replies', count: post.reply_count), post.full_url, 'data-link-to-post' => post.replies.first.id.to_s, :class => 'post-replies button' 
 else 
 link_to I18n.t('embed.replies', count: post.reply_count), post.full_url, class: 'post-replies button', target: "_blank" 
 end 
 end 
 end 
 if @topic_view.topic.posts_count > 0 
 link_to(image_tag(SiteSetting.logo_url, class: 'logo'), Discourse.base_url, target: '_blank') 
 link_to(I18n.t('embed.continue'), @topic_view.posts.last.full_url, class: 'button', target: '_blank') 
 if @posts_left > 0 
 I18n.t('embed.more_replies', count: @posts_left) 
 end 
 end 
 end 

end

  end

  def info
    embed_url = params.require(:embed_url)
    @topic_embed = TopicEmbed.where(embed_url: embed_url).first

    raise Discourse::NotFound if @topic_embed.nil?

    render_serialized(@topic_embed, TopicEmbedSerializer, root: false)
  end

  def count
    embed_urls = params[:embed_url]
    by_url = {}

    if embed_urls.present?
      urls = embed_urls.map {|u| u.sub(/#discourse-comments$/, '').sub(/\/$/, '') }
      topic_embeds = TopicEmbed.where(embed_url: urls).includes(:topic).references(:topic)

      topic_embeds.each do |te|
        url = te.embed_url
        url = "#{url}#discourse-comments" unless params[:embed_url].include?(url)
        by_url[url] = I18n.t('embed.replies', count: te.topic.posts_count - 1)
      end
    end

    render json: {counts: by_url}, callback: params[:callback]
  end

  private

    def ensure_api_request
      raise Discourse::InvalidAccess.new('api key not set') if !is_api?
    end

    def ensure_embeddable

      if !(Rails.env.development? && current_user.try(:admin?))
        raise Discourse::InvalidAccess.new('invalid referer host') unless EmbeddableHost.host_allowed?(request.referer)
      end

      response.headers['X-Frame-Options'] = "ALLOWALL"
    rescue URI::InvalidURIError
      raise Discourse::InvalidAccess.new('invalid referer host')
    end


end
