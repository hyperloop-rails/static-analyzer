  module Admin
    class TopicsController < BaseController
      before_filter :find_topic

      def update
        if @topic.update_attributes(topic_params)
          flash[:notice] = t("forem.topic.updated")
          redirect_to forum_topic_path(@topic.forum, @topic)
        else
          flash.alert = t("forem.topic.not_updated")
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("forem.topic.edit", :subject => @topic.subject) 
  simple_form_for [forem, :admin, @topic.forum, @topic] do |f| 
 f.input :subject 
 f.association :forum , :label => "Forum" 
 f.label :locked 
 f.check_box :locked 
 f.label :pinned 
 f.check_box :pinned 
 f.label :hidden 
 f.check_box :hidden 
 f.submit :class => "btn btn-primary" 
 end 
 

end

        end
      end

      def destroy
        forum = @topic.forum
        @topic.destroy
        flash[:notice] = t("forem.topic.deleted")
        redirect_to forum_topics_path(forum)
      end

      def toggle_hide
        @topic.toggle!(:hidden)
        flash[:notice] = t("forem.topic.hidden.#{@topic.hidden?}")
        redirect_to forum_topic_path(@topic.forum, @topic)
      end

      def toggle_lock
        @topic.toggle!(:locked)
        flash[:notice] = t("forem.topic.locked.#{@topic.locked?}")
        redirect_to forum_topic_path(@topic.forum, @topic)
      end

      def toggle_pin
        @topic.toggle!(:pinned)
        flash[:notice] = t("forem.topic.pinned.#{@topic.pinned?}")
        redirect_to forum_topic_path(@topic.forum, @topic)
      end

      private

        def topic_params
          params.require(:topic).permit(:subject, :forum_id, :locked, :pinned, :hidden)
        end

        def find_topic
          @topic = Topic.friendly.find(params[:id])
        end
    end
  end
