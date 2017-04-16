# frozen_string_literal: true
module Api::V2
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :locale, :created_at, :updated_at
    link(:self) { api_user_path(object) }
  end
end
