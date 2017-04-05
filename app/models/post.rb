# frozen_string_literal: true
class Post < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_title, against: :title

  belongs_to :user
  validates :title, presence: true
  paginates_per 5

  mount_uploader :image, ImageUploader

  def self.sorted_by(field, direction = :desc)
    return all if field.blank?
    direction = direction.to_sym == :asc ? :asc : :desc
    order(field => direction)
  end

  def self.filter_by_title(query)
    return all if query.blank?
    search_by_title(query.to_s)
  end
end
