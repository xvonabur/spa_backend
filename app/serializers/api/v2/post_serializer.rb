# frozen_string_literal: true
module Api::V2
  class PostSerializer < ActiveModel::Serializer
    attributes :id, :title, :body, :image, :user_id, :created_at, :updated_at
    link(:self) { api_post_path(object) }
  end
end
