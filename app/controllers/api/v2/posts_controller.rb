# frozen_string_literal: true
module Api::V2
  class PostsController < Api::PostsController
    def index
      @posts = posts_to_show.page(page_number).per(page_size)

      render json: @posts, meta: { total: posts_to_show.count, limit: page_size }
    end

    def show
      super
    end

    def create
      super
    end

    def update
      super
    end

    def destroy
      super
    end

    private

    def post_params
      params.require(:post).permit(:title, :body, :user_id, :image)
    end

    def posts_to_show
      Post.filter_by_title(params[:search])
        .sorted_by(params[:sort_by], params[:sort_direction])
    end

    def page_number
      return nil if params[:page].blank? || params[:page][:number].blank?
      params[:page][:number]
    end

    def page_size
      return Post.default_per_page if params[:page].blank? || params[:page][:size].blank?
      params[:page][:size]
    end
  end
end
