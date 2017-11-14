class ThemeController < ContentController
  def stylesheets
    render_theme_item(:stylesheets, params[:filename], 'text/css; charset=utf-8')
  end

  def javascript
    render_theme_item(:javascript, params[:filename], 'text/javascript; charset=utf-8')
  end

  def images
    render_theme_item(:images, params[:filename])
  end

  def fonts
    render_theme_item(:fonts, params[:filename])
  end

  def error
    render nothing: true, status: 404
  end

  def static_view_test
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

  end

  private

  def render_theme_item(type, file, mime = nil)
    mime ||= mime_for(file)
    if file.split(%r{[\\/]}).include?('..')
      return (ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("errors.page_not_found") 
 t("errors.the_page_you_are_looking_for") 

end
)
    end

    src = this_blog.current_theme.path + "/#{type}/#{file}"
    return (render text: 'Not Found', status: 404) unless File.exist? src

    cache_page File.read(src) if perform_caching

    send_file(src, type: mime, disposition: 'inline', stream: true)
  end

  def mime_for(filename)
    case filename.downcase
    when /\.js$/
      'text/javascript'
    when /\.css$/
      'text/css'
    when /\.gif$/
      'image/gif'
    when /(\.jpg|\.jpeg)$/
      'image/jpeg'
    when /\.png$/
      'image/png'
    when /\.swf$/
      'application/x-shockwave-flash'
    else
      'application/binary'
    end
  end
end
