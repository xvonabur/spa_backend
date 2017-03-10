# frozen_string_literal: true
class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :username, :created_at, :updated_at
  link(:self) { api_post_path(object) }
end
