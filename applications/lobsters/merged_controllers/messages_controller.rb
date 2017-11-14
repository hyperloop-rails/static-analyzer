class MessagesController < ApplicationController
  before_filter :require_logged_in_user
  before_filter :find_message, :only => [ :show, :destroy, :keep_as_new ]

  def index
    @cur_url = "/messages"
    @title = "Messages"

    @new_message = Message.new

    @direction = :in
    @messages = @user.undeleted_received_messages

    if params[:to]
      @new_message.recipient_username = params[:to]
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @meta_tags 
 @meta_tags.each do |k,v| 
 k 
 v 
 end 
 end 
 if @short_url 
 @short_url 
 end 
 @title.present? ? "#{@title} | " : "" 

    Rails.application.name 
 stylesheet_link_tag "application", :media => "all" 
 if @user 
 javascript_include_tag "application" 
 @user.id 
 end 
 csrf_meta_tags 
 if @rss_link 
 @rss_link[:title] 
 @rss_link[:href] 
 end 
 if @comments_rss_link 
 @comments_rss_link[:title] 
 @comments_rss_link[:href] 
 end 
 sprintf("%02x%02x%02x",
        [ 255, (@traffic * 7).floor + 50.0 ].min, 0, 0) 
 Rails.application.name 
 @traffic.to_i 
 links = {
          "/" => @cur_url == "/" ? Rails.application.name : "Home",
          "/recent" => "Recent",
          "/comments" => "Comments"
        } 
 if @user 
 links.merge!({ "/threads" => "Your Threads",
            "/stories/new" => "Submit Story" }) 
 end 
 links.merge!({ "/search" => "Search" }) 
 if @cur_url.present? && !links.keys.include?(@cur_url) &&
        @heading.present? 
 @cur_url 
 @heading 
 end 
 links.each do |u,v| 
 u 
 u == @cur_url ? raw("class=\"cur_url\"") :
              "" 
 v 
 end 
 @cur_url == "/filters" ?
          raw("class=\"cur_url\"") : "" 
 if @user 
 if (count = @user.unread_message_count) > 0 
 @cur_url == "/messages" ?
              "cur_url" : "" 
 count 
 count == 1 ? "" :
              "s" 
 else 
 @cur_url == "/messages" ?
              raw("class=\"cur_url\"") : "" 
 end 
 @cur_url == "/settings" ?
            raw("class=\"cur_url\"") : "" 
 @user.username 
 @user.karma 
 link_to "Logout", { :controller => "login", :action => "logout" },
            :data => { :confirm => "Are you sure you want to logout?" },
            :method => "post" 
 else 
 end 
 [ :error, :success, :notice ].each do |f| 
 if flash[f].present? 
 f 
 flash[f] 
 end 
 end 
 if @direction == :out 
 else 
 end 
 if @direction == :out 
 end 
 if @messages.any? 
 form_tag batch_delete_messages_path do 
 check_box_tag "delete_all",
          :id => "delete_all" 
 @direction == :in ? "From" : "To" 
 @direction == :in ? "Received" : "Sent" 
 @messages.includes(:author, :recipient).each do |message| 
 message.has_been_read? ? "" : "bold" 
 check_box_tag "delete_#{message.short_id}" 
 if @direction == :in 
 if message.author 
 message.author.username 

                  message.author.username 
 else 
 message.author_username 
 end 
 else 
 message.recipient.username 

                message.recipient.username 
 end 
 time_ago_in_words_label(message.created_at) 
 message.short_id 
 message.subject
            
 end 
 submit_tag "Delete Selected" 
 end 
 else 
 @direction == :in ? "" : "sent" 
 end 
 form_for @new_message, :method => :post do |f| 
 error_messages_for @new_message 
 f.label :recipient_username, "To:", :class => "required" 
 f.text_field :recipient_username, :size => 20,
        :autocomplete => "off" 
 f.label :subject, "Subject:", :class => "required" 
 f.text_field :subject, :style => "width: 500px;",
        :autocomplete => "off" 
 f.label :body, "Message:", :class => "required" 
 f.text_area :body, :style => "width: 500px;", :rows => 5,
        :autocomplete => "off" 
 submit_tag "Send Message" 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

  end

  def sent
    @cur_url = "/messages"
    @title = "Messages Sent"

    @direction = :out
    @messages = @user.undeleted_sent_messages

    @new_message = Message.new

    ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @meta_tags 
 @meta_tags.each do |k,v| 
 k 
 v 
 end 
 end 
 if @short_url 
 @short_url 
 end 
 @title.present? ? "#{@title} | " : "" 

    Rails.application.name 
 stylesheet_link_tag "application", :media => "all" 
 if @user 
 javascript_include_tag "application" 
 @user.id 
 end 
 csrf_meta_tags 
 if @rss_link 
 @rss_link[:title] 
 @rss_link[:href] 
 end 
 if @comments_rss_link 
 @comments_rss_link[:title] 
 @comments_rss_link[:href] 
 end 
 sprintf("%02x%02x%02x",
        [ 255, (@traffic * 7).floor + 50.0 ].min, 0, 0) 
 Rails.application.name 
 @traffic.to_i 
 links = {
          "/" => @cur_url == "/" ? Rails.application.name : "Home",
          "/recent" => "Recent",
          "/comments" => "Comments"
        } 
 if @user 
 links.merge!({ "/threads" => "Your Threads",
            "/stories/new" => "Submit Story" }) 
 end 
 links.merge!({ "/search" => "Search" }) 
 if @cur_url.present? && !links.keys.include?(@cur_url) &&
        @heading.present? 
 @cur_url 
 @heading 
 end 
 links.each do |u,v| 
 u 
 u == @cur_url ? raw("class=\"cur_url\"") :
              "" 
 v 
 end 
 @cur_url == "/filters" ?
          raw("class=\"cur_url\"") : "" 
 if @user 
 if (count = @user.unread_message_count) > 0 
 @cur_url == "/messages" ?
              "cur_url" : "" 
 count 
 count == 1 ? "" :
              "s" 
 else 
 @cur_url == "/messages" ?
              raw("class=\"cur_url\"") : "" 
 end 
 @cur_url == "/settings" ?
            raw("class=\"cur_url\"") : "" 
 @user.username 
 @user.karma 
 link_to "Logout", { :controller => "login", :action => "logout" },
            :data => { :confirm => "Are you sure you want to logout?" },
            :method => "post" 
 else 
 end 
 [ :error, :success, :notice ].each do |f| 
 if flash[f].present? 
 f 
 flash[f] 
 end 
 end 
 if @direction == :out 
 else 
 end 
 if @direction == :out 
 end 
 if @messages.any? 
 form_tag batch_delete_messages_path do 
 check_box_tag "delete_all",
          :id => "delete_all" 
 @direction == :in ? "From" : "To" 
 @direction == :in ? "Received" : "Sent" 
 @messages.includes(:author, :recipient).each do |message| 
 message.has_been_read? ? "" : "bold" 
 check_box_tag "delete_#{message.short_id}" 
 if @direction == :in 
 if message.author 
 message.author.username 

                  message.author.username 
 else 
 message.author_username 
 end 
 else 
 message.recipient.username 

                message.recipient.username 
 end 
 time_ago_in_words_label(message.created_at) 
 message.short_id 
 message.subject
            
 end 
 submit_tag "Delete Selected" 
 end 
 else 
 @direction == :in ? "" : "sent" 
 end 
 form_for @new_message, :method => :post do |f| 
 error_messages_for @new_message 
 f.label :recipient_username, "To:", :class => "required" 
 f.text_field :recipient_username, :size => 20,
        :autocomplete => "off" 
 f.label :subject, "Subject:", :class => "required" 
 f.text_field :subject, :style => "width: 500px;",
        :autocomplete => "off" 
 f.label :body, "Message:", :class => "required" 
 f.text_area :body, :style => "width: 500px;", :rows => 5,
        :autocomplete => "off" 
 submit_tag "Send Message" 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

  end

  def create
    @cur_url = "/messages"
    @title = "Messages"

    puts "message params: "
    puts message_params

    @new_message = Message.new(message_params)
    @new_message.author_user_id = @user.id

    @direction = :out
    @messages = @user.undeleted_received_messages

    if @new_message.save
      flash[:success] = "Your message has been sent to " <<
        @new_message.recipient.username.to_s << "."
      return redirect_to "/messages"
    else
      ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @meta_tags 
 @meta_tags.each do |k,v| 
 k 
 v 
 end 
 end 
 if @short_url 
 @short_url 
 end 
 @title.present? ? "#{@title} | " : "" 

    Rails.application.name 
 stylesheet_link_tag "application", :media => "all" 
 if @user 
 javascript_include_tag "application" 
 @user.id 
 end 
 csrf_meta_tags 
 if @rss_link 
 @rss_link[:title] 
 @rss_link[:href] 
 end 
 if @comments_rss_link 
 @comments_rss_link[:title] 
 @comments_rss_link[:href] 
 end 
 sprintf("%02x%02x%02x",
        [ 255, (@traffic * 7).floor + 50.0 ].min, 0, 0) 
 Rails.application.name 
 @traffic.to_i 
 links = {
          "/" => @cur_url == "/" ? Rails.application.name : "Home",
          "/recent" => "Recent",
          "/comments" => "Comments"
        } 
 if @user 
 links.merge!({ "/threads" => "Your Threads",
            "/stories/new" => "Submit Story" }) 
 end 
 links.merge!({ "/search" => "Search" }) 
 if @cur_url.present? && !links.keys.include?(@cur_url) &&
        @heading.present? 
 @cur_url 
 @heading 
 end 
 links.each do |u,v| 
 u 
 u == @cur_url ? raw("class=\"cur_url\"") :
              "" 
 v 
 end 
 @cur_url == "/filters" ?
          raw("class=\"cur_url\"") : "" 
 if @user 
 if (count = @user.unread_message_count) > 0 
 @cur_url == "/messages" ?
              "cur_url" : "" 
 count 
 count == 1 ? "" :
              "s" 
 else 
 @cur_url == "/messages" ?
              raw("class=\"cur_url\"") : "" 
 end 
 @cur_url == "/settings" ?
            raw("class=\"cur_url\"") : "" 
 @user.username 
 @user.karma 
 link_to "Logout", { :controller => "login", :action => "logout" },
            :data => { :confirm => "Are you sure you want to logout?" },
            :method => "post" 
 else 
 end 
 [ :error, :success, :notice ].each do |f| 
 if flash[f].present? 
 f 
 flash[f] 
 end 
 end 
 if @direction == :out 
 else 
 end 
 if @direction == :out 
 end 
 if @messages.any? 
 form_tag batch_delete_messages_path do 
 check_box_tag "delete_all",
          :id => "delete_all" 
 @direction == :in ? "From" : "To" 
 @direction == :in ? "Received" : "Sent" 
 @messages.includes(:author, :recipient).each do |message| 
 message.has_been_read? ? "" : "bold" 
 check_box_tag "delete_#{message.short_id}" 
 if @direction == :in 
 if message.author 
 message.author.username 

                  message.author.username 
 else 
 message.author_username 
 end 
 else 
 message.recipient.username 

                message.recipient.username 
 end 
 time_ago_in_words_label(message.created_at) 
 message.short_id 
 message.subject
            
 end 
 submit_tag "Delete Selected" 
 end 
 else 
 @direction == :in ? "" : "sent" 
 end 
 form_for @new_message, :method => :post do |f| 
 error_messages_for @new_message 
 f.label :recipient_username, "To:", :class => "required" 
 f.text_field :recipient_username, :size => 20,
        :autocomplete => "off" 
 f.label :subject, "Subject:", :class => "required" 
 f.text_field :subject, :style => "width: 500px;",
        :autocomplete => "off" 
 f.label :body, "Message:", :class => "required" 
 f.text_area :body, :style => "width: 500px;", :rows => 5,
        :autocomplete => "off" 
 submit_tag "Send Message" 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

    end
  end

  def show
    @cur_url = "/messages"
    @title = @message.subject

    if @message.author
      @new_message = Message.new
      @new_message.recipient_username = (@message.author_user_id == @user.id ?
        @message.recipient.username : @message.author.username)

      if @message.subject.match(/^re:/i)
        @new_message.subject = @message.subject
      else
        @new_message.subject = "Re: #{@message.subject}"
      end
    end

    if @message.recipient_user_id == @user.id
      @message.has_been_read = true
      @message.save
    end
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 if @meta_tags 
 @meta_tags.each do |k,v| 
 k 
 v 
 end 
 end 
 if @short_url 
 @short_url 
 end 
 @title.present? ? "#{@title} | " : "" 

    Rails.application.name 
 stylesheet_link_tag "application", :media => "all" 
 if @user 
 javascript_include_tag "application" 
 @user.id 
 end 
 csrf_meta_tags 
 if @rss_link 
 @rss_link[:title] 
 @rss_link[:href] 
 end 
 if @comments_rss_link 
 @comments_rss_link[:title] 
 @comments_rss_link[:href] 
 end 
 sprintf("%02x%02x%02x",
        [ 255, (@traffic * 7).floor + 50.0 ].min, 0, 0) 
 Rails.application.name 
 @traffic.to_i 
 links = {
          "/" => @cur_url == "/" ? Rails.application.name : "Home",
          "/recent" => "Recent",
          "/comments" => "Comments"
        } 
 if @user 
 links.merge!({ "/threads" => "Your Threads",
            "/stories/new" => "Submit Story" }) 
 end 
 links.merge!({ "/search" => "Search" }) 
 if @cur_url.present? && !links.keys.include?(@cur_url) &&
        @heading.present? 
 @cur_url 
 @heading 
 end 
 links.each do |u,v| 
 u 
 u == @cur_url ? raw("class=\"cur_url\"") :
              "" 
 v 
 end 
 @cur_url == "/filters" ?
          raw("class=\"cur_url\"") : "" 
 if @user 
 if (count = @user.unread_message_count) > 0 
 @cur_url == "/messages" ?
              "cur_url" : "" 
 count 
 count == 1 ? "" :
              "s" 
 else 
 @cur_url == "/messages" ?
              raw("class=\"cur_url\"") : "" 
 end 
 @cur_url == "/settings" ?
            raw("class=\"cur_url\"") : "" 
 @user.username 
 @user.karma 
 link_to "Logout", { :controller => "login", :action => "logout" },
            :data => { :confirm => "Are you sure you want to logout?" },
            :method => "post" 
 else 
 end 
 [ :error, :success, :notice ].each do |f| 
 if flash[f].present? 
 f 
 flash[f] 
 end 
 end 
 if @message.author_user_id == @user.id 
 else 
 end 
 @message.subject 
 if @message.author 
 @message.author.username 

          @message.author.username 
 if @message.author.is_admin? 
 elsif @message.author.is_moderator? 
 end 
 else 
 @message.author_username 
 end 
 @message.recipient.username 

        @message.recipient.username 
 time_ago_in_words_label(@message.created_at) 
 raw @message.linkified_body 
 form_tag message_path(@message.short_id), :method => :delete do 
 submit_tag "Delete Message" 
 end 
 form_tag message_path(@message.short_id) + "/keep_as_new",
      :method => :post do 
 submit_tag "Keep As New" 
 end 
 if @new_message 
 @new_message.recipient_username 
 end 
 if @new_message 
 form_for @new_message, :method => :post do |f| 
 f.hidden_field :recipient_username 
 error_messages_for @new_message 
 f.text_field :subject, :style => "width: 500px;",
          :autocomplete => "off" 
 f.text_area :body, :style => "width: 500px;", :rows => 5,
          :autocomplete => "off" 
 submit_tag "Send Message" 
 end 
 else 
 end 
 if @user && !@user.is_new? &&
        (iqc = InvitationRequest.verified_count) > 0 
 iqc 
 end 
 if defined?(BbsController) 
 end 

end

  end

  def destroy
    if @message.author_user_id == @user.id
      @message.deleted_by_author = true
    end

    if @message.recipient_user_id == @user.id
      @message.deleted_by_recipient = true
    end

    @message.save!

    flash[:success] = "Deleted message."

    if @message.author_user_id == @user.id
      return redirect_to "/messages/sent"
    else
      return redirect_to "/messages"
    end
  end

  def batch_delete
    deleted = 0

    params.each do |k,v|
      if v.to_s == "1" && m = k.match(/^delete_(.+)$/)
        if (message = Message.where(:short_id => m[1]).first)
          ok = false
          if message.author_user_id == @user.id
            message.deleted_by_author = true
            ok = true
          end
          if message.recipient_user_id == @user.id
            message.deleted_by_recipient = true
            ok = true
          end

          if ok
            message.save!
            deleted += 1
          end
        end
      end
    end

    flash[:success] = "Deleted #{deleted} message#{deleted == 1 ? "" : "s"}."

    @user.update_unread_message_count!

    return redirect_to "/messages"
  end

  def keep_as_new
    @message.has_been_read = false
    @message.save

    return redirect_to "/messages"
  end

private
  def message_params
    params.require(:message).permit(
      :recipient_username, :subject, :body,
    )
  end

  def find_message
    if @message = Message.where(:short_id => params[:message_id] ||
    params[:id]).first
      if (@message.author_user_id == @user.id ||
      @message.recipient_user_id == @user.id)
        return true
      end
    end

    flash[:error] = "Could not find message."
    redirect_to "/messages"
    return false
  end
end
