# frozen_string_literal: true
module Api
  module V1
    class PostSerializer < ActiveModel::Serializer
      attributes :id, :title, :body, :user_id, :created_at, :updated_at
      link(:self) { api_post_path(object) }
    end
  end
end
