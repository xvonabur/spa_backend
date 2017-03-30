# frozen_string_literal: true
class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :posts
  alias_method :authenticate, :valid_password?

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 3 },
            if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true,
            if: -> { new_record? || changes[:crypted_password] }
end
