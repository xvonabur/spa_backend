# frozen_string_literal: true
FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "Title #{n}" }
    sequence(:body) { |n| "Body #{n}" }
    sequence(:username) { |n| "User #{n}" }
  end
end
