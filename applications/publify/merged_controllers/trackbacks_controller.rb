class TrackbacksController < FeedbackController
  def create
    @error_message = catch(:error) do
      if this_blog.global_pings_disable
        throw :error, 'Trackback not saved'
      elsif params[:__mode] == 'rss'
        # Part of the trackback spec... not sure what we should be doing here though.
      else
        begin
          @trackback = this_blog.ping_article! trackback_params
        rescue ActiveRecord::RecordNotFound, ActiveRecord::StatementInvalid
          throw :error, "Article id #{params[:id]} not found."
        rescue ActiveRecord::RecordInvalid
          throw :error, 'Trackback not saved'
        end
      end
    end

    respond_to do |format|
      format.xml { ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 trackback.id 
 onhover_show_admin_tools(:trackback, trackback.id) 
 trackback.id 
 t(".from")
 trackback.blog_name 
 trackback.url 
h trackback.title 
 trackback.excerpt 

end
 }
      format.html { render nothing: true }
    end
  end

  protected

  def trackback_params
    params.
      permit(:blog_name, :excerpt, :title, :url, :article_id).
      merge(ip: request.remote_ip, published: true)
  end

  def get_article
    true
  end
end
