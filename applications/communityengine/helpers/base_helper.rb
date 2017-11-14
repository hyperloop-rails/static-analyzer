require 'digest/md5'

# Methods added to this helper will be available to all templates in the application.
module BaseHelper
  include ActsAsTaggableOn::TagsHelper

  def commentable_url(comment)
    if comment.recipient && comment.commentable
      if comment.commentable_type != "User"
        polymorphic_url([comment.recipient, comment.commentable])+"#comment-#{comment.id}"
      elsif comment
        user_url(comment.recipient)+"#comment-#{comment.id}"
      end
    elsif comment.commentable
      polymorphic_url(comment.commentable)+"#comment-#{comment.id}"
    end
  end

  def forum_page?
    %w(forums topics sb_posts).include?(controller.controller_name)
  end

  def is_current_user_and_featured?(u)
    u && u.eql?(current_user) && u.featured_writer?
  end

  def rounded(options={}, &content)
    options = {:class=>"box"}.merge(options)
    options[:class] = "box " << options[:class] if options[:class]!="box"

    str = '<div'
    options.collect {|key,val| str << " #{key}=\"#{val}\"" }
    str << '><div class="box_top"></div>'
    str << "\n"

    concat(str.html_safe)
    yield(content)
    concat('<br class="clear" /><div class="box_bottom"></div></div>'.html_safe)
  end

  def block_to_partial(partial_name, html_options = {}, &block)
    concat(render(:partial => partial_name, :locals => {:body => capture(&block), :html_options => html_options}))
  end

  def box(html_options = {}, &block)
    block_to_partial('shared/box', html_options, &block)
  end



  def widget(html_options = {}, &block)
    @widgets ||= ''
    @widgets << render(:partial => 'shared/widget', :locals => {:body => capture(&block), :html_options => html_options})
    return ''
  end

  def render_widgets
    if @widgets
      @widgets.html_safe
    end
  end

  def jumbotron(html_options = {}, &block)
    @jumbotron = render(:partial => 'shared/jumbotron', :locals => {:body => capture(&block), :html_options => html_options})
    return ''
  end

  def render_jumbotron
    if @jumbotron
      @jumbotron.html_safe
    end
  end

  def city_cloud(cities, classes)
    max, min = 0, 0
    cities.each { |c|
      max = c.users.size.to_i if c.users.size.to_i > max
      min = c.users.size.to_i if c.users.size.to_i < min
    }

    divisor = ((max - min) / classes.size) + 1

    cities.each { |c|
      yield c, classes[(c.users.size.to_i - min) / divisor]
    }
  end

  def truncate_words(text, length = 30, end_string = '...')
    return if text.blank?
    words = strip_tags(text).split()
    string = words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
    string.html_safe
  end

  def truncate_words_with_highlight(text, phrase)
    t = excerpt(text, phrase)
    highlight truncate_words(t, 18), phrase
  end

  def excerpt_with_jump(text, end_string = ' ...')
    return if text.blank?
    doc = Hpricot( text )
    paragraph = doc.at("p")
    if paragraph
      paragraph.to_html + end_string
    else
      truncate_words(text, 150, end_string)
    end
  end

  def page_title
    divider = " | ".html_safe

    app_base = configatron.community_name
    tagline = " #{divider} #{configatron.community_tagline}"
		title = app_base

		case controller.controller_name
			when 'base'
        title += tagline
      when 'pages'
        if @page and @page.title
          title = @page.title + divider + app_base + tagline
        end
			when 'posts'
        if @post and @post.title
          title = @post.title + divider + app_base + tagline
          title += (@post.tags.empty? ? '' : "#{divider}#{:keywords.l}: " + @post.tags[0...4].join(', ') )
          @canonical_url = user_post_url(@post.user, @post)
        end
      when 'users'
        if @user && !@user.new_record? && @user.login
          title = @user.login
          title += divider + app_base + tagline
          @canonical_url = user_url(@user)
        else
          title = :showing_users.l+divider + app_base + tagline
        end
      when 'photos'
        if @user and @user.login
          title = :users_photos.l(:user => @user.login) + divider + app_base + tagline
        end
      when 'clippings'
        if @user and @user.login
          title = :user_clippings.l(:user => @user.login) + divider + app_base + tagline
        end
      when 'tags'
        case controller.action_name
          when 'show'
            if params[:type]
              title = I18n.translate('all_' + params[:type].downcase.pluralize + '_tagged', :tag_name => @tags.map(&:name).join(', '))
            else
              title = :posts_photos_and_bookmarks.l(:name => @tags.map(&:name).join(', '))
            end
            title += " (#{:related_tags.l}: #{@related_tags.join(', ')})" if @related_tags
            title += divider + app_base
            @canonical_url = tag_url(URI.escape(URI.escape(@tags_raw), /[\/.?#]/)) if @tags_raw
          else
            title = "Showing tags #{divider} #{app_base} #{tagline}"
          end
      when 'categories'
        if @category and @category.name
          title = :posts_photos_and_bookmarks.l(:name => @category.name) + divider + app_base + tagline
        else
          title = :showing_categories.l + divider + app_base + tagline
        end
      when 'sessions'
        title = :login.l + divider + app_base + tagline
    end

    if @page_title
      title = @page_title + divider + app_base + tagline
    elsif title == app_base
		  title = :showing.l + ' ' + controller.controller_name + divider + app_base + tagline
    end

    title
  end

  def container_title
    app_base = configatron.community_name
    title = app_base

    case controller.controller_name
      when 'pages'
        if @page and @page.title
          title = @page.title
        end
      when 'posts'
        if @post and @post.title
          title = @post.title
          @canonical_url = user_post_url(@post.user, @post)
        end
      when 'users'
        if @user && !@user.new_record? && @user.login
          title = @user.login
          @canonical_url = user_url(@user)
        else
          title = :showing_users.l
        end
      when 'photos'
        if @user and @user.login
          title = :users_photos.l(:user => @user.login)
        end
      when 'clippings'
        if @user and @user.login
          title = :user_clippings.l(:user => @user.login)
        end
      when 'tags'
        case controller.action_name
          when 'show'
            if params[:type]
              title = I18n.translate('all_' + params[:type].downcase.pluralize + '_tagged', :tag_name => @tags.map(&:name).join(', '))
            else
              title = :posts_photos_and_bookmarks.l(:name => @tags.map(&:name).join(', '))
            end
            title += " (#{:related_tags.l}: #{@related_tags.join(', ')})" if @related_tags
            @canonical_url = tag_url(URI.escape(URI.escape(@tags_raw), /[\/.?#]/)) if @tags_raw
          else
            title = "Showing tags"
          end
      when 'categories'
        if @category and @category.name
          title = :posts_photos_and_bookmarks.l(:name => @category.name)
        else
          title = :showing_categories.l
        end
      when 'sessions'
        title = :login.l
    end

    if @page_title
      title = @page_title
    elsif title == app_base
      title = :showing.l + ' ' + controller.controller_name
    end

    title
  end

  def add_friend_link(user = nil)
		html = ""
    html << render(:partial => 'shared/add_friend_link', :locals => {:user => user})
		html.html_safe
  end

  def topnav_tab(name, options)
    classes = [options.delete(:class)]
    classes << 'current' if options[:section] && (options.delete(:section).to_a.include?(@section))

    string = "<li class='#{classes.join(' ')}'>" + link_to( content_tag(:span, name), options.delete(:url), options) + "</li>"
    string.html_safe
  end

  def more_comments_links(commentable)
    html = link_to fa_icon('plus-circle', :text => :all_comments.l), commentable_comments_url(commentable.class.to_s.tableize, commentable.to_param)
    html += "<br />".html_safe
    html += link_to fa_icon('rss', :text => :comments_rss.l), commentable_comments_url(commentable.class.to_s.tableize, commentable.to_param, :format => :rss)
    html.html_safe
  end

  def show_footer_content?
    return true #you can override this in your app
  end

  def clippings_link
    "javascript:(function() {d=document, w=window, e=w.getSelection, k=d.getSelection, x=d.selection, s=(e?e():(k)?k():(x?x.createRange().text:0)), e=encodeURIComponent, document.location='#{home_url}new_clipping?uri='+e(document.location)+'&title='+e(document.title)+'&selection='+e(s);} )();"
  end

  def paginating_links(paginator, options = {}, html_options = {})
    paginate paginator, :theme => 'bootstrap'
  end

  def last_active
    session[:last_active] ||= Time.now.utc
  end

  def ajax_spinner_for(id, spinner="spinner.gif")
    image_tag spinner, class: 'hide', id: "#{id.to_s}_spinner"
  end

  def avatar_for(user, size=32)
    image_tag user.avatar_photo_url(:thumb), :class => 'thumbnail'
  end

  def search_posts_title
    (params[:q].blank? ? :recent_posts.l : :searching_for.l+" '#{h params[:q]}'").tap do |title|
      title << " by #{h User.find(params[:user_id]).display_name}" if params[:user_id]
      title << " in #{h Forum.find(params[:forum_id]).name}"       if params[:forum_id]
    end
  end

  def search_user_posts_path(rss = false)
    options = params[:q].blank? ? {} : {:q => params[:q]}
    options[:format] = :rss if rss
    [[:user, :user_id], [:forum, :forum_id]].each do |(route_key, param_key)|
      return send("#{route_key}_sb_posts_path", options.update(param_key => params[param_key])) if params[param_key]
    end
    options[:q] ? search_all_sb_posts_path(options) : send("all_#{prefix}sb_posts_path", options)
  end

  def time_ago_in_words(from_time, to_time = Time.now, include_seconds = false)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round

    case distance_in_minutes
      when 0              then :a_few_seconds_ago.l
      when 1..59          then :minutes_ago.l(:count => distance_in_minutes)
      when 60..1440       then :hours_ago.l(:count => (distance_in_minutes.to_f / 60.0).round)
      when 1440..2880     then :days_ago.l(:count => (distance_in_minutes.to_f / 1440.0).round) # 1.5 days to 2 days
      else I18n.l(from_time, :format => :short)
    end
  end

  def time_ago_in_words_or_date(date)
    if date.to_date.eql?(Time.now.to_date)
      display = I18n.l(date.to_time.localtime, :format => :time_ago)
    elsif date.to_date.eql?(Time.now.to_date - 1)
      display = :yesterday.l
    else
      display = I18n.l(date.to_date, :format => :short)
    end
  end

  def profile_completeness(user)
    segments = [
      {:val => 2, :action => link_to(:upload_a_profile_photo.l, edit_user_path(user, :anchor => 'profile_details')), :test => !user.avatar.nil? },
      {:val => 1, :action => link_to(:tell_us_about_yourself.l, edit_user_path(user, :anchor => 'user_description')), :test => !user.description.blank?},
      {:val => 2, :action => link_to(:select_your_city.l, edit_user_path(user, :anchor => 'location_chooser')), :test => !user.metro_area.nil? },
      {:val => 1, :action => link_to(:tag_yourself.l, edit_user_path(user, :anchor => "user_tags")), :test => user.tags.any?},
      {:val => 1, :action => link_to(:invite_some_friends.l, new_invitation_path), :test => user.invitations.any?}
    ]

    completed_score = segments.select{|s| s[:test].eql?(true)}.sum{|s| s[:val]}
    incomplete = segments.select{|s| !s[:test] }

    total = segments.sum{|s| s[:val] }
    score = (completed_score.to_f/total.to_f)*100

    {:score => score, :incomplete => incomplete, :total => total}
  end


  def possesive(user)
    user.gender ? (user.male? ? :his.l : :her.l)  : :their.l
  end

  def tiny_mce_init_if_needed
    if !@uses_tiny_mce.blank?
      javascript_tag(tiny_mce_js)
    end
  end

  def tiny_mce_js
    selector = @tiny_mce_configuration['selector']
    "jQuery(function(){jQuery('#{selector}').RichTextEditor(#{@tiny_mce_configuration.to_json})});".html_safe
  end

  def flash_class(level)
    case level
      when :notice then "alert-info"
      when :error then "alert-danger"
      when :alert then "alert-warning"
    end
  end

  def tag_auto_complete_field(id, options = {})
    options[:url][:format] = 'json'
    html = ""
    html << render(:partial => 'shared/tag_auto_complete', :locals => {:id => id, :options => options})
    html.html_safe
  end
end
