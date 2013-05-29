module Forem
  class ForumsController < Forem::ApplicationController
    load_and_authorize_resource :only => :show
    helper 'forem/topics'

    def index
      @categories = Forem::Category.all
      @unread_forum_ids = forem_user.unread_topics.map {|topic| topic.forum_id.to_i} if forem_user
    end

    def show
      register_view

      @topics = if forem_admin_or_moderator?(@forum)
        @forum.topics
      else
        @forum.topics.visible.approved_or_pending_review_for(forem_user)
      end

      @topics = @topics.by_pinned_or_most_recent_post.page(params[:page]).per(Forem.per_page)

      respond_to do |format|
        format.html
        format.atom { render :layout => false }
      end
    end

    private
    def register_view
      @forum.register_view_by(forem_user)
    end
  end
end
