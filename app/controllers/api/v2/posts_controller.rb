# frozen_string_literal: true
module Api::V2
  class PostsController < ApplicationController
    before_action :authenticate_user, only: [:create, :update, :destroy]
    before_action :set_post, only: [:show, :update, :destroy]
    before_action :unauthorized_check, only: [:update, :destroy]

    def index
      @posts = posts_to_show.page params[:page]

      render json: @posts
    end

    def show
      if @post.present?
        render json: @post
      else
        render json: {}, status: :not_found
      end
    end

    def create
      @post = current_user.posts.build(post_params)

      if @post.save
        render json: @post, status: :created
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end

    def update
      if @post.update(post_params)
        render json: @post
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end

    def destroy
      if @post.present?
        @post.destroy
        render json: {}
      else
        render json: {}, status: :not_found
      end
    end

    private

    def post_params
      params.require(:post).permit(:title, :body, :user_id, :image)
    end

    def set_post
      @post = Post.find_by(id: params[:id])
    end

    def unauthorized_check
      if @post.present? && @post.user_id != current_user_id
        render json: {}, status: :forbidden
      end
    end

    def current_user_id
      current_user.blank? ? nil : current_user.id
    end

    def posts_to_show
      Post.filter_by_title(params[:search])
        .sorted_by(params[:sort_by], params[:sort_direction])
    end
  end
end
