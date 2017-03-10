# frozen_string_literal: true
module Api
  class PostsController < ApplicationController
    before_action :set_post, only: [:show, :update, :destroy]

    def index
      @posts = Post.all

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
      @post = Post.new(post_params)

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
      params.require(:post).permit(:title, :body, :username)
    end

    def set_post
      @post = Post.find_by(id: params[:id])
    end
  end
end
